from collections import defaultdict

from aig_grapher import AIG
from setup import setup_tools

setup_tools()

from tools_fns import cadical_check

def get_simulation_classes(aig: AIG, bits: int = 128):
    node_vals, _ = aig.simulate(bits)
    classes = defaultdict(list)

    for k, v in node_vals.items():
        classes[v].append(k)

    return classes

def find_equivalences(aig: AIG, bits: int = 256):
    """
    Identifies functionally equivalent pairs using a representative-based 
    search with a 5s SAT timeout.
    """
    sim_classes = get_simulation_classes(aig, bits=bits)
    all_equivalences = []

    for signature, nodes in sim_classes.items():
        # Copy list to allow for removal/indexing logic
        working_set = list(nodes)
        
        while len(working_set) > 1:
            # Pick the first node as the candidate (representative)
            candidate = working_set.pop(0)
            eqv_found_for_this_candidate = []
            
            # Compare candidate against all remaining nodes in this sim-class
            remaining_nodes = list(working_set)
            for other_node in remaining_nodes:
                # cadical_check with 5s timeout
                # Note: cadical_check usually returns True (Equiv), False (Not Equiv), 
                # or None/Timeout. Check your setup_tools implementation for specifics.
                dimacs = 
                is_equiv = cadical_check(dimacs, timeout=2)
                
                if is_equiv is True:
                    all_equivalences.append((candidate, other_node))
                    eqv_found_for_this_candidate.append(other_node)
            
            # Remove all nodes found equivalent to the current candidate 
            # so they aren't used as representatives later
            for node in eqv_found_for_this_candidate:
                working_set.remove(node)
                
    return all_equivalences