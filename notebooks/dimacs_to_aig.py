import sys
from typing import Dict, Tuple, List

class AIG:
    def __init__(self):
        self.next_var = 1  # AIG vars start from 1
        self.inputs: List[int] = []
        self.ands: List[Tuple[int, int, int]] = []
        self.var_map: Dict[int, int] = {}  # CNF var -> AIG var

    def new_var(self):
        v = self.next_var
        self.next_var += 1
        return v

    def lit(self, var: int, neg: bool=False):
        return 2 * var ^ int(neg)

    def add_input(self, cnf_var: int):
        if cnf_var not in self.var_map:
            v = self.new_var()
            self.var_map[cnf_var] = v
            self.inputs.append(self.lit(v))
        return self.var_map[cnf_var]

    def add_and(self, lhs_lit: int, rhs_lit: int):
        v = self.new_var()
        out_lit = self.lit(v)
        self.ands.append((out_lit, lhs_lit, rhs_lit))
        return out_lit

    def negate(self, lit: int):
        return lit ^ 1


def parse_dimacs(path: str) -> Tuple[int, List[List[int]]]:
    clauses: List[List[int]] = []
    n_vars = 0

    with open(path) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('c'):
                continue
            if line.startswith('p'):
                _, _, n_vars, _ = line.split()
                n_vars = int(n_vars)
            else:
                lits = list(map(int, line.split()))
                lits = [x for x in lits if x != 0]
                clauses.append(lits)

    return n_vars, clauses


def build_or(aig, lits):
    """
    Build OR of literals using De Morgan:
    a ∨ b = ¬(¬a ∧ ¬b)
    """
    assert len(lits) >= 1

    def lit_to_aig(l):
        v = abs(l)
        var = aig.add_input(v)
        return aig.lit(var, neg=(l < 0))

    # start from first literal
    cur = lit_to_aig(lits[0])

    for l in lits[1:]:
        nxt = lit_to_aig(l)

        # OR via De Morgan
        na = aig.negate(cur)
        nb = aig.negate(nxt)
        and_node = aig.add_and(na, nb)
        cur = aig.negate(and_node)

    return cur


def build_and_tree(aig, nodes):
    assert len(nodes) >= 1
    cur = nodes[0]
    for n in nodes[1:]:
        cur = aig.add_and(cur, n)
    return cur


def write_aag(aig, output_lit, path):
    M = aig.next_var - 1
    I = len(aig.inputs)
    L = 0
    O = 1
    A = len(aig.ands)

    with open(path, "w") as f:
        f.write(f"aag {M} {I} {L} {O} {A}\n")

        # inputs
        for inp in aig.inputs:
            f.write(f"{inp}\n")

        # output
        f.write(f"{output_lit}\n")

        # and gates
        for lhs, rhs0, rhs1 in aig.ands:
            f.write(f"{lhs} {rhs0} {rhs1}\n")


def cnf_to_aig(input_cnf: str, output_aag: str):
    _n_vars, clauses = parse_dimacs(input_cnf)

    aig = AIG()

    clause_nodes = []
    for clause in clauses:
        clause_nodes.append(build_or(aig, clause))

    if not clause_nodes:
        raise ValueError("Empty CNF")

    output = build_and_tree(aig, clause_nodes)

    write_aag(aig, output, output_aag)
