from pathlib import Path
from typing import Any, Dict

from utils import run_command
import os

# Helper to create all leading directories for a given path if they don't exist
def ensure_output_dir(path: str | Path):
	output_dir = os.path.dirname(path)
	if output_dir and not os.path.exists(output_dir):
		os.makedirs(output_dir)


def verilog_to_aig(verilog_file: str | Path, top_module: str, output_aig: str | Path="output.aig"):
	"""
	Compile a specific Verilog module to AIG using Yosys.

	Args:
		verilog_file (str | Path): Path to the Verilog source file
		top_module (str): Name of the module to synthesize
		output_aig (str | Path): Output AIG file name
	"""
		
	ensure_output_dir(output_aig)
		
	yosys_script = f"""
	read_verilog {verilog_file}
	hierarchy -check -top {top_module}
	proc
	opt
	techmap
	aigmap
	write_aiger {output_aig}
	"""

	command = f'yosys -p "{yosys_script}"'
	
	out = run_command(command)
	if out.returncode != 0:
		raise RuntimeError(f"Yosys failed with exit code {out.returncode} and output:\n{out.output}")
	return out

def aig_to_aag(aig_file: str | Path, output_aag: str | Path="output.aag"):
	"""
	Convert an AIG file to AAG format using Yosys.

	Args:
		aig_file (str | Path): Input AIG file
		output_aag (str): Output AAG file

	Returns:
		(exit_code, output)
	"""

	ensure_output_dir(output_aag)

	yosys_script = f"""
	read_aiger {aig_file};
	write_aiger -ascii {output_aag}
	"""

	command = f'yosys -p "{yosys_script}"'
	out = run_command(command)
	if out.returncode != 0:
		raise RuntimeError(f"Yosys AAG conversion failed with exit code {out.returncode} and output:\n{out.output}")
	return out

def aig_to_rtlil(aig_file: str | Path, output_rtlil: str | Path="output.il"):
	"""
	Convert an AIG file to RTLIL format using Yosys.

	Args:
		aig_file (str | Path): Input AIG file
		output_rtlil (str | Path): Output RTLIL file

	Returns:
		(exit_code, output)
	"""

	ensure_output_dir(output_rtlil)

	yosys_script = f"""
	read_aiger {aig_file};
	write_rtlil {output_rtlil}
	"""

	command = f'yosys -p "{yosys_script}"'
	out = run_command(command)
	if out.returncode != 0:
		raise RuntimeError(f"Yosys RTLIL conversion failed with exit code {out.returncode} and output:\n{out.output}")
	return out

def aig_cec(aig1: str | Path, aig2: str | Path):
	"""
	Run combinational equivalence checking (CEC) between two AIG files using ABC.

	Args:
		aig1 (str | Path): Path to first AIG file
		aig2 (str | Path): Path to second AIG file

	Returns:
		(exit_code, output)
	"""

	abc_script = f"""
	read {aig1};
	cec {aig2}
	"""

	command = f'abc -c "{abc_script}"'
	out = run_command(command)
	if out.returncode != 0:
		raise RuntimeError(f"ABC CEC failed with exit code {out.returncode} and output:\n{out.output}")
	return out

def aig_to_dimacs(aig_file: str | Path, output_dimacs: str | Path="output.cnf"):
	"""
	Convert an AIG file to DIMACS CNF using ABC.

	Args:
		aig_file (str | Path): Input AIG file
		output_dimacs (str | Path): Output DIMACS CNF file

	Returns:
		(exit_code, output)
	"""

	ensure_output_dir(output_dimacs)

	abc_script = f"""
	read_aiger {aig_file};
	strash;
	write_cnf {output_dimacs}
	"""

	command = f'abc -c "{abc_script}"'
	out = run_command(command)
	if out.returncode != 0:
		raise RuntimeError(f"ABC CNF conversion failed with exit code {out.returncode} and output:\n{out.output}")
	return out

def aig_to_blif(aig_file: str | Path, output_blif: str | Path="output.blif"):
	"""
	Convert an AIG file to BLIF using ABC.

	Args:
		aig_file (str | Path): Input AIG file
		output_blif (str | Path): Output BLIF file

	Returns:
		(exit_code, output)
	"""

	ensure_output_dir(output_blif)

	abc_script = f"""
	read_aiger {aig_file};
	write_blif {output_blif}
	"""

	command = f'abc -c "{abc_script}"'
	out = run_command(command)
	if out.returncode != 0:
		raise RuntimeError(f"ABC BLIF conversion failed with exit code {out.returncode} and output:\n{out.output}")
	return out

def aig_miter(aig1: str | Path, aig2: str | Path, output_aig: str | Path="miter.aig"):
	"""
	Generate a miter circuit from two AIG files using ABC.

	Args:
		aig1 (str | Path): First AIG file
		aig2 (str | Path): Second AIG file
		output_aig (str | Path): Output miter AIG file

	Returns:
		(exit_code, output)
	"""

	ensure_output_dir(output_aig)

	abc_script = f"""
	read_aiger {aig1};
	miter {aig2};
	write_aiger {output_aig};
	"""

	command = f'abc -c "{abc_script}"'
	out = run_command(command)
	if out.returncode != 0:
		raise RuntimeError(f"ABC miter generation failed with exit code {out.returncode} and output:\n{out.output}")
	return out

SAT_err_c_map = {
	20: "UNSATISFIABLE",
	10: "SATISFIABLE",
	0: "INDETERMINATE"
}

def cadical_check(dimacs_file: str | Path, **kwargs):
	"""
	Check satisfiability of a DIMACS CNF file using CaDiCaL.

	Args:
		dimacs_file (str | Path): Input DIMACS CNF file

	Returns:
		(status, output): Tuple containing the SAT status ("SATISFIABLE", "UNSATISFIABLE", "INDETERMINATE") and the raw output from CaDiCaL
	"""

	command = f'cadical {dimacs_file}'
	out = run_command(command, **kwargs)
	
	return (SAT_err_c_map.get(out.returncode, "UNKNOWN"), out)

def kissat_check(dimacs_file: str | Path, params: Dict[str, Any] | None=None, timeout=None):
	params_list = " ".join([f"--{k}={v}" for k, v in params.items()]) if params else ""
	timeout_p = f"--time={timeout}" if timeout else ""
	command = f'kissat {dimacs_file} ' + params_list + " " + timeout_p
	out = run_command(command)

	ret_status = SAT_err_c_map.get(out.returncode, "UNKNOWN")

	runtime = None
	for line in out.output.splitlines():
		if "process-time:" in line:
			# Split by colon, take the second part, remove 'seconds', and strip whitespace
			runtime = float(line.split()[-2])

	return (runtime, ret_status, out)