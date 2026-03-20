from enum import Enum
from pathlib import Path
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
        fanins: Tuple[Tuple[int, bool], Tuple[int, bool]] = ((-1, False), (-1, False)),
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
        self.fanins = fanins

    def add_fanin(self, fanin_id: int, is_inverted: bool) -> None:
        if self.fanins[0][0] == -1:
            self.fanins = ((fanin_id, is_inverted), self.fanins[1])
        elif self.fanins[1][0] == -1:
            self.fanins = (self.fanins[0], (fanin_id, is_inverted))
        else:
            raise ValueError(f"Node {self.node_id} already has 2 fanins, cannot add more")
        
_T_AIG_SimV = TypeVar("_T_AIG_SimV")


class AIG:
    def __init__(self, aiger_file: str | Path):
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

    def handle_aig(self, aiger_file: str|Path) -> None:
        raise NotImplementedError("AIG parsing not implemented yet")

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
                fanins=((fanin1_id, fanin1_inverted), (fanin2_id, fanin2_inverted)),
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
        node_vals = {i: random.getrandbits(simulation_bits) for i in self.input_ids}
        node_vals.update({0: 0})
        node_vals, out_vals = self.generalized_sim(
            node_vals,
            lambda x: x ^ ((1 << simulation_bits) - 1),
            lambda xy: xy[0] & xy[1],
        )
        return node_vals, out_vals


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