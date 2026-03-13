from enum import Enum
from typing import List, Self, Tuple, Dict

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
    INT = 0 # Intermediate node
    PI = 1
    PO = 2
    F = 3

class AIGNode:
    def __init__(self, node_id: int, typ: AIGNodeType, fanins: List[Tuple[int, bool]], fanouts: List[Tuple[int, bool]]):
        """
        Args:
            node_id (int): Unique identifier for the node
            typ (AIGNodeType): Type of the node (INT, PI, PO)
            fanins (List[Tuple[int, bool]]): List of fanin nodes and their inversion status (node_id, is_inverted)
            fanouts (List[Tuple[int, bool]]): List of fanout nodes and their inversion status (node_id, is_inverted)
        """
        self.node_id = node_id
        self.typ = typ
        self.fanins = fanins
        self.fanouts = fanouts

class AIG:
    def __init__(self, aiger_file: str):
        self.nodes: Dict[int, AIGNode] = {}
        self.input_ids: List[int] = []
        self.outputs: List[Tuple[int, bool]] = []

        self.nodes.update({0: AIGNode(node_id=0, typ=AIGNodeType.F, fanins=[], fanouts=[])})
        
        if aiger_file.split('.')[-1] == 'aig':
            self.handle_aig(aiger_file)
        elif aiger_file.split('.')[-1] == 'aag':
            self.handle_aag(aiger_file)
        else:
            raise ValueError(f"Unsupported file format: {aiger_file}")
            
    def handle_aig(self, aiger_file: str) -> None:
        raise NotImplementedError("AIG parsing not implemented yet")

    def handle_aag(self, aiger_file: str) -> None:
        # Open file and read lines
        lines: List[str] = []
        with open(aiger_file, 'r') as f:
            lines = f.readlines()

        header = lines[0].split()
        if header[0] != 'aag':
            raise ValueError(f"Invalid AAG file: {aiger_file}")

        _M, I, L, O, A = map(int, header[1:6])  # noqa: E741

        assert L == 0, "Latches are not supported in this implementation"
        
        self.input_ids = [int(lines[i].strip()) // 2 for i in range(1, I + 1)]
        self.nodes.update({i: AIGNode(node_id=i, typ=AIGNodeType.PI, fanins=[], fanouts=[]) for i in self.input_ids})

        # Output ids don't correspond to any new node, but provide important information about
        # which nodes are the outputs, their order and their polarity in the output.
        self.outputs = [node_lit_to_id(int(lines[i].strip())) for i in range(I + 1, I + O + 1)]

        for i in range(I + O + 1, I + O + A + 1):
            line = lines[i].strip()
            if not line:
                continue
            parts = line.split()
            if len(parts) != 3:
                raise ValueError(f"Invalid AAG node line: {line}")
            
            node_id = int(parts[0]) // 2 # This is always even
            fanin1_id, fanin1_inverted = node_lit_to_id(int(parts[1]))
            fanin2_id, fanin2_inverted = node_lit_to_id(int(parts[2]))
            
            if fanin1_id not in self.nodes:
                self.nodes[fanin1_id] = AIGNode(node_id=fanin1_id, typ=AIGNodeType.INT, fanins=[], fanouts=[])
            if fanin2_id not in self.nodes:
                self.nodes[fanin2_id] = AIGNode(node_id=fanin2_id, typ=AIGNodeType.INT, fanins=[], fanouts=[])

            self.nodes[fanin1_id].fanouts.append((node_id, fanin1_inverted))
            self.nodes[fanin2_id].fanouts.append((node_id, fanin2_inverted))
            self.nodes[node_id] = AIGNode(node_id=node_id, typ=AIGNodeType.INT, fanins=[(fanin1_id, fanin1_inverted), (fanin2_id, fanin2_inverted)], fanouts=[])

        len_nodes = len(self.nodes)
        if 0 in self.nodes:
            len_nodes -= 1

        assert len_nodes == A + I, f"Expected {A + I} nodes but found {len_nodes} {self.nodes.keys()}"
            
    def downstream_aig(self, output_id: int) -> Self:
        """
        Get the downstream AIG for a given output node ID. This includes all nodes that are reachable from the specified output node.
        
        Args:
            output_id (int): The node ID of the output for which to extract the downstream AIG.
        Returns:
            AIG: A new AIG instance containing only the nodes that are downstream of the specified
                output node.
        """
        raise NotImplementedError("Downstream AIG extraction not implemented yet")

    def upstream_aig(self, output_id: int) -> Self:
        """
        Get the upstream AIG for a given output node ID. This includes all nodes that can reach the specified output node.
        
        Args:
            output_id (int): The node ID of the output for which to extract the upstream AIG.
        Returns:
            AIG: A new AIG instance containing only the nodes that are upstream of the specified
                output node.
        """
        raise NotImplementedError("Upstream AIG extraction not implemented yet")

    def simulate(self, node_values: Dict[int, bool]) -> Tuple[Dict[int, bool], List[bool]]:
        """
        Simulate the AIG for a given set of input values and compute the output values.
        
        Args:
            input_values (Dict[int, bool]): A dictionary mapping node IDs to their boolean values. Supports intermediate node value passing but correctness is the caller’s responsibility.
        Returns:
            Dict[int, bool]: A dictionary mapping output node IDs to their computed boolean values.
        """
        node_values.update({0: False})  # Constants

        def calculate_node_value(node_id: int, values: Dict[int, bool]) -> bool:
            node = self.nodes[node_id]
            if node.typ == AIGNodeType.PI:
                assert node_id in values, f"Value for input node {node_id} not provided nor calculable from provided values"
                return values[node_id]
            elif node.typ == AIGNodeType.F:
                return False
            elif node.typ == AIGNodeType.INT:
                if node_id in values:
                    return values[node_id]
                
                fanin_values: List[bool] = []
                for fanin_id, is_inverted in node.fanins:
                    val = calculate_node_value(fanin_id, values)
                    if is_inverted:
                        val = not val
                    fanin_values.append(val)
                values[node_id] = all(fanin_values)  # AND of the fanins
                return values[node_id]
            else:
                raise ValueError(f"Unsupported node type for simulation: {node.typ}")

        # May be mapped to self.outputs by the user for reference
        output_values: List[bool] = []
        for output_id, neg in self.outputs:
            output_values.append(calculate_node_value(output_id, node_values) ^ neg)  # XOR with negation status to get final output value

        return node_values, output_values

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="AIG Grapher")
    parser.add_argument("aiger_file", type=str, help="Path to the AIG/AAG file to parse")
    args = parser.parse_args()

    aig = AIG(args.aiger_file)
    print(f"Parsed AIG with {len(aig.nodes)} nodes (including node 0, if applicable), {len(aig.input_ids)} inputs, and {len(aig.outputs)} outputs.")

    # Print all nodes and their fanins/fanouts
    print("Nodes and their fanins/fanouts:")
    for node_id, node in aig.nodes.items():
        print(f"Node ID: {node_id}, Type: {node.typ}, Fanins: {node.fanins}, Fanouts: {node.fanouts}")

    # Simulate the AIG with random values
    print("\nSimulating AIG with random input values...")
    import random
    input_values = {node_id: random.choice([True, False]) for node_id in
                                                aig.input_ids}      
    print(f"Input values: {input_values}")
    node_values, output_values = aig.simulate(input_values)
    
    # print all node values
    print(f"All node values: {node_values}")
    print(f"Output values: {output_values}")
