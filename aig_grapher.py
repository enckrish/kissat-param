from enum import Enum
from pathlib import Path
from time import time, time_ns
from typing import Callable, List, Tuple, Dict, TypeVar
import random

# NOTE: All the inputs in the AIGs we are using are laid out LSB to MSB in the AAG file


def node_lit_to_id(node_lit: int) -> Tuple[int, bool]:
    """
    Convert a node literal to its corresponding node ID and inversion status.

    Args:
        node_lit (int): The node literal from the AAG file, where even numbers represent non-inverted nodes and odd numbers represent inverted nodes.

    Returns:
        Tuple[int, bool]: A tuple containing the node ID and a boolean indicating whether the node is inverted.
    """
    node_id = node_lit // 2
    is_inverted = (node_lit % 2) == 1
    return node_id, is_inverted


class AIGNodeType(Enum):
    INT = 0  # Intermediate node
    PI = 1
    PO = 2
    F = 3


class AIGNode:
    def __init__(
        self,
        node_id: int,
        typ: AIGNodeType,
        fanouts: List[Tuple[int, bool]],
        fanins: List[Tuple[int, bool]] = [(-1, False), (-1, False)], # using list for easier mutability
    ):
        """
        Args:
            node_id (int): Unique identifier for the node
            typ (AIGNodeType): Type of the node (INT, PI, PO)
            fanins (List[Tuple[int, bool]]): List of fanin nodes and their inversion status (node_id, is_inverted)
            fanouts (List[Tuple[int, bool]]): List of fanout nodes and their inversion status (node_id, is_inverted)
        """
        self.node_id = node_id
        self.typ = typ
        self.fanouts = fanouts
        self.fanins: List[Tuple[int, bool]] = fanins

    def add_fanin(self, fanin_id: int, is_inverted: bool) -> None:
        if self.fanins[0][0] == -1:
            self.fanins = [(fanin_id, is_inverted), self.fanins[1]]
        elif self.fanins[1][0] == -1:
            self.fanins = [self.fanins[0], (fanin_id, is_inverted)]
        else:
            raise ValueError(f"Node {self.node_id} already has 2 fanins, cannot add more")
        
_T_AIG_SimV = TypeVar("_T_AIG_SimV")


class AIG:
    def __init__(self, aiger_file: str | Path):
        self._init_from_file(aiger_file)

    def _init_from_file(self, aiger_file: str | Path) -> None:
        self.nodes: Dict[int, AIGNode] = {}
        self.input_ids: List[int] = []
        self.outputs: List[Tuple[int, bool]] = []

        self.nodes.update(
            {0: AIGNode(node_id=0, typ=AIGNodeType.F, fanouts=[])}
        )

        aiger_file = Path(aiger_file)
        
        if aiger_file.suffix == ".aig":
            self.handle_aig(aiger_file)
        elif aiger_file.suffix == ".aag":
            self.handle_aag(aiger_file)
        else:
            raise ValueError(f"Unsupported file format: {aiger_file}")

    # todo: untested
    def serialize(self) -> str:
        """
        Serialize the AIG back to AAG format.
        Note: This is a simple implementation and may not preserve the original structure or ordering of the AAG file.
        """
        lines = []
        M = max(self.nodes.keys()) * 2  # Maximum literal ID (node_id * 2)
        I = len(self.input_ids)
        L = 0  # Latches are not supported in this implementation
        O = len(self.outputs)
        A = len([node for node in self.nodes.values() if node.typ == AIGNodeType.INT])
        
        lines.append(f"aag {M} {I} {L} {O} {A}\n")
        
        # Add input literals
        for input_id in self.input_ids:
            lines.append(f"{input_id * 2}\n")
        
        # Add output literals
        for output_id, is_inverted in self.outputs:
            lit = output_id * 2 + (1 if is_inverted else 0)
            lines.append(f"{lit}\n")
        
        # Add AND gate definitions
        for node in self.nodes.values():
            if node.typ == AIGNodeType.INT:
                fanin1_id, fanin1_inv = node.fanins[0]
                fanin2_id, fanin2_inv = node.fanins[1]
                line = f"{node.node_id * 2} {fanin1_id * 2 + (1 if fanin1_inv else 0)} {fanin2_id * 2 + (1 if fanin2_inv else 0)}\n"
                lines.append(line)
        
        return "".join(lines)

    def handle_aag(self, aiger_file: str|Path) -> None:
        # Open file and read lines
        lines: List[str] = []
        with open(aiger_file, "r") as f:
            lines = f.readlines()

        header = lines[0].split()
        if header[0] != "aag":
            raise ValueError(f"Invalid AAG file: {aiger_file}")

        _M, I, L, O, A = map(int, header[1:6])  # noqa: E741

        assert L == 0, "Latches are not supported in this implementation"

        self.input_ids = [int(lines[i].strip()) // 2 for i in range(1, I + 1)]
        self.nodes.update(
            {
                i: AIGNode(node_id=i, typ=AIGNodeType.PI, fanouts=[])
                for i in self.input_ids
            }
        )

        # Output ids don't correspond to any new node, but provide important information about
        # which nodes are the outputs, their order and their polarity in the output.
        self.outputs = [
            node_lit_to_id(int(lines[i].strip())) for i in range(I + 1, I + O + 1)
        ]

        for i in range(I + O + 1, I + O + A + 1):
            line = lines[i].strip()
            if not line:
                continue
            parts = line.split()
            if len(parts) != 3:
                raise ValueError(f"Invalid AAG node line: {line}")

            node_id = int(parts[0]) // 2  # This is always even
            fanin1_id, fanin1_inverted = node_lit_to_id(int(parts[1]))
            fanin2_id, fanin2_inverted = node_lit_to_id(int(parts[2]))

            if fanin1_id not in self.nodes:
                self.nodes[fanin1_id] = AIGNode(
                    node_id=fanin1_id, typ=AIGNodeType.INT, fanouts=[]
                )
            if fanin2_id not in self.nodes:
                self.nodes[fanin2_id] = AIGNode(
                    node_id=fanin2_id, typ=AIGNodeType.INT, fanouts=[]
                )

            self.nodes[fanin1_id].fanouts.append((node_id, fanin1_inverted))
            self.nodes[fanin2_id].fanouts.append((node_id, fanin2_inverted))
            self.nodes[node_id] = AIGNode(
                node_id=node_id,
                typ=AIGNodeType.INT,
                fanouts=[],
                fanins=[(fanin1_id, fanin1_inverted), (fanin2_id, fanin2_inverted)],
            )

        len_nodes = len(self.nodes)
        if 0 in self.nodes:
            len_nodes -= 1

        assert len_nodes == A + I, (
            f"Expected {A + I} nodes but found {len_nodes} {self.nodes.keys()}"
        )

    def generalized_sim(
        self,
        node_values: Dict[int, _T_AIG_SimV],
        inv_fn: Callable[[_T_AIG_SimV], _T_AIG_SimV],
        and_fn: Callable[[Tuple[_T_AIG_SimV, _T_AIG_SimV]], _T_AIG_SimV],
    ) -> Tuple[Dict[int, _T_AIG_SimV], List[_T_AIG_SimV]]:
        assert 0 in self.nodes, (
            "Node 0 (constant false) must be present in the `node_values` dictionary."
        )

        def calculate_node_value(
            node_id: int, values: Dict[int, _T_AIG_SimV]
        ) -> _T_AIG_SimV:
            node = self.nodes[node_id]
            if node.typ == AIGNodeType.PI or node.typ == AIGNodeType.F:
                assert node_id in values, (
                    f"Value for input or constant node {node_id} not provided nor calculable from provided values"
                )
                return values[node_id]
            elif node.typ == AIGNodeType.INT:
                if node_id in values:
                    return values[node_id]

                fanin_values: List[_T_AIG_SimV] = []
                for fanin_id, is_inverted in node.fanins:
                    val = calculate_node_value(fanin_id, values)
                    if is_inverted:
                        val = inv_fn(val)
                    fanin_values.append(val)
                assert len(fanin_values) == 2, f"Expected 2 fanin values for node {node_id} but got {len(fanin_values)}"
                values[node_id] = and_fn((fanin_values[0], fanin_values[1]))
                return values[node_id]
            else:
                raise ValueError(f"Unsupported node type for simulation: {node.typ}")

        # May be mapped to self.outputs by the user for reference
        output_values: List[_T_AIG_SimV] = []
        for output_id, neg in self.outputs:
            val = calculate_node_value(output_id, node_values)
            if neg:
                val = inv_fn(val)
            output_values.append(val)

        return node_values, output_values

    def simulate(
        self, simulation_bits: int,
        seed: int | None = None
    ) -> Tuple[Dict[int, int], List[int]]:
        """
        Runs a simulation on each node.
        Args:
            simulation_bits: the number of bits to simulate for each input
        Out:
            (node_vals, out_vals):
                node_vals: maps node id to a `simulation_width` bit integer, holding the calculated value of the node during the simulation.
                out_vals: contains the ordered list of outputs.
        """
        if not seed:
            seed = time_ns()
        random.seed(seed)
        node_vals = {i: random.getrandbits(simulation_bits) for i in self.input_ids}
        node_vals.update({0: 0})
        node_vals, out_vals = self.generalized_sim(
            node_vals,
            lambda x: x ^ ((1 << simulation_bits) - 1),
            lambda xy: xy[0] & xy[1],
        )
        return node_vals, out_vals

    def to_graph_data(self):
        # only made for single output aigs for now 
        # what we want
        # node_typ: INP, OUT, INT
        # num_inverted_preds
        # edges
        # edge_types
        # out_is_inv
        assert len(self.outputs) == 1

        def _get_num_inv_preds(node: AIGNode):
            n = 0
            for _, inv in node.fanins:
                n += 1 if inv else 0
            return n
        
        # Adding entries for node 0 (FALSE) seperately
        node_typ = [3] + [int(node.typ.value) for node in self.nodes.values()]
        num_inv_preds = [0] + [_get_num_inv_preds(node) for node in self.nodes.values()]
        edge_out = []
        edge_in = []
        edge_typ = []
        for nid, node in self.nodes.items():
            for node_in, inv in node.fanouts:
                edge_out.append(nid)
                edge_in.append(node_in)
                edge_typ.append(inv)
        edges = [edge_out, edge_in]
        out_is_inv = self.outputs[0][1]
        return edges, edge_typ, node_typ, num_inv_preds, out_is_inv

    def to_cnf(self) -> Tuple[int, List[List[int]], Dict[int, Dict[str,int | AIGNodeType]]]:
        """
        Convert the AIG to CNF using Tseitin encoding.
        
        Tseitin encoding introduces auxiliary variables for each internal node and generates
        clauses to represent the AND gates and inversions.
        
        Returns:
            Tuple[int, List[List[int]], Dict[int, Dict[str, Dict[str, int | AIGNodeType]]]]: 
                - Number of variables in the CNF formula
                - List of clauses, where each clause is a list of literals (int).
                  Positive integers represent positive literals, negative represent negated literals.
                  Variable IDs start from 1. Node IDs are used as variable IDs.
                - Mapping from CNF variable IDs to AIG node information.
                  Maps var_id -> {'node_id': int, 'type': AIGNodeType}
        
        Example:
            For an AND gate with inputs a, b and output c:
            The encoding generates three clauses to enforce c iff (a AND b):
            - (~a | ~b | c)   : if both a and b are true, then c must be true
            - (a | ~c)        : if c is true, then a must be true
            - (b | ~c)        : if c is true, then b must be true
        """
        clauses: List[List[int]] = []
        var_to_node: Dict[int, Dict[str, int | AIGNodeType]] = {}
        
        # Process all intermediate nodes (AND gates)
        for node_id, node in self.nodes.items():
            if node.typ != AIGNodeType.INT or node_id == 0:
                continue
            
            # Get fanin information
            (fanin1_id, fanin1_inv), (fanin2_id, fanin2_inv) = node.fanins
            
            # Create literals for the fanins (negative if inverted)
            lit1 = -fanin1_id if fanin1_inv else fanin1_id
            lit2 = -fanin2_id if fanin2_inv else fanin2_id
            lit_out = node_id  # Output literal for this AND gate
            
            # Record the mapping for this variable
            var_to_node[node_id] = {'node_id': node_id, 'type': node.typ}
            
            # Tseitin encoding for AND gate: output iff (input1 AND input2)
            # This is enforced by three clauses:
            # 1. (~fanin1_inv(fanin1_id) | ~fanin2_inv(fanin2_id) | output)
            #    If both inputs are true, output must be true
            clauses.append([-lit1, -lit2, lit_out])
            
            # 2. (fanin1_inv(fanin1_id) | ~output)
            #    If output is true, first input must be true
            clauses.append([lit1, -lit_out])
            
            # 3. (fanin2_inv(fanin2_id) | ~output)
            #    If output is true, second input must be true
            clauses.append([lit2, -lit_out])
        
        # Add constraints for primary outputs
        # Each primary output must equal its corresponding internal node (with polarity)
        for output_node_id, output_inv in self.outputs:
            lit_output = -output_node_id if output_inv else output_node_id
            # The output literal must be true in the final formula
            clauses.append([lit_output])
        
        # Add mappings for all primary inputs
        for input_id in self.input_ids:
            var_to_node[input_id] = {'node_id': input_id, 'type': AIGNodeType.PI}
        
        # Add mapping for constant false node
        var_to_node[0] = {'node_id': 0, 'type': AIGNodeType.F}
        
        # Determine the number of variables (highest node ID used as variable ID)
        num_vars = max(self.nodes.keys()) if self.nodes else 0
        
        return num_vars, clauses, var_to_node

    def write_cnf_to_file(self, output_file: str | Path) -> None:
        """
        Convert the AIG to CNF using Tseitin encoding and write it to a DIMACS CNF file.
        
        Args:
            output_file (str | Path): Path to write the DIMACS CNF file to.
        """
        num_vars, clauses, _var_to_node = self.to_cnf()
        num_clauses = len(clauses)
        
        with open(output_file, "w") as f:
            # Write header
            f.write("c DIMACS CNF format\n")
            f.write("c Converted from AIG using Tseitin encoding\n")
            f.write(f"p cnf {num_vars} {num_clauses}\n")
            
            # Write clauses
            for clause in clauses:
                f.write(" ".join(map(str, clause)) + " 0\n")

    def bfs_levels(self) -> List[List[int]]:
        """
        Perform a breadth-first search (BFS) to determine the levels of nodes in the AIG.
        
        Returns:
            List[List[int]]: A list of levels, where each level is a list of node IDs at that level.
                             Level 0 contains primary inputs and the constant false node, level 1 contains nodes directly driven by level 0, and so on.
        """
        levels: List[List[int]] = []
        visited: set = set()
        queue: List[Tuple[int, int]] = []  # (node_id, level)
        
        # Start BFS with primary inputs and constant false node
        for input_id in self.input_ids:
            queue.append((input_id, 0))
            visited.add(input_id)
        if 0 in self.nodes:
            queue.append((0, 0))
            visited.add(0)
        
        while queue:
            node_id, level = queue.pop(0)
            if len(levels) <= level:
                levels.append([])
            levels[level].append(node_id)
            
            for fanout_id, _ in self.nodes[node_id].fanouts:
                if fanout_id not in visited:
                    visited.add(fanout_id)
                    queue.append((fanout_id, level + 1))
        
        return levels

# todo: untested
def extract_cone_for(aig: AIG, node_id: int) -> AIG:
    """
    Extract the cone of influence for a given node ID.
    
    The cone of influence includes all nodes that can affect the value of the specified node,
    which are all nodes that have a path to the specified node through fanins.
    
    Args:
        aig (AIG): The AIG instance from which to extract the cone.
        node_id (int): The ID of the node for which to extract the cone of influence.
    
    Returns:
        AIG: An AIG instance containing only the nodes in the cone of influence of the specified node.
    """
    cone = {}
    visited = set()

    def dfs(current_id):
        if current_id in visited:
            return
        visited.add(current_id)
        if current_id in aig.nodes:
            cone[current_id] = aig.nodes[current_id]
            for fanin_id in aig.nodes[current_id].fanins:
                dfs(fanin_id)

    dfs(node_id)

    AIG_cone = AIG.__new__(AIG)  # Create an uninitialized instance
    AIG_cone.nodes = cone
    AIG_cone.input_ids = [nid for nid in aig.input_ids if nid in cone]
    AIG_cone.outputs = [(node_id, False)]  # The specified node is the only output in the cone
    return AIG_cone


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="AIG Grapher")
    parser.add_argument(
        "aiger_file", type=str, help="Path to the AIG/AAG file to parse"
    )
    args = parser.parse_args()

    aig = AIG(args.aiger_file)
    print(
        f"Parsed AIG with {len(aig.nodes)} nodes (including node 0, if applicable), {len(aig.input_ids)} inputs, and {len(aig.outputs)} outputs."
    )

    # Print all nodes and their fanins/fanouts
    # print("Nodes and their fanins/fanouts:")
    # for node_id, node in aig.nodes.items():
    #     print(
    #         f"Node ID: {node_id}, Type: {node.typ}, Fanins: {node.fanins}, Fanouts: {node.fanouts}"
    #     )

    # Simulate the AIG with random values
    print("\nSimulating AIG with random input values...")
    import random

    # print(f"Input values: {input_values}")
    node_values, output_values = aig.simulate(16)

    # print all node values
    # print(f"All node values: {node_values}")
    print(f"Output values: {output_values}")

