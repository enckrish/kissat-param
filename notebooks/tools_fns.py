from utils import run_command
import os

def verilog_to_aig(verilog_file, top_module, output_aig="output.aig"):
	"""
	Compile a specific Verilog module to AIG using Yosys.

	Args:
		verilog_file (str): Path to the Verilog source file
		top_module (str): Name of the module to synthesize
		output_aig (str): Output AIG file name
	"""
	print(f"Compiling {verilog_file} (top module: {top_module}) to AIG...")
		
	if type(verilog_file) is str:
		try:
			verilog_file = str(verilog_file)
		except Exception as e:
			raise ValueError(f"Invalid verilog_file path: {verilog_file}") from e
		
	if type(output_aig) is str:
		try:
			output_aig = str(output_aig)
		except Exception as e:
			raise ValueError(f"Invalid output_aig path: {output_aig}") from e
		
	# Create all leading dirs to output_aig if they don't exist
	output_dir = os.path.dirname(output_aig)
	if output_dir and not os.path.exists(output_dir):
		os.makedirs(output_dir)
		
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

def aig_cec(aig1, aig2):
	"""
	Run combinational equivalence checking (CEC) between two AIG files using ABC.

	Args:
		aig1 (str): Path to first AIG file
		aig2 (str): Path to second AIG file

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

def aig_to_dimacs(aig_file, output_dimacs="output.cnf"):
	"""
	Convert an AIG file to DIMACS CNF using ABC.

	Args:
		aig_file (str): Input AIG file
		output_dimacs (str): Output DIMACS CNF file

	Returns:
		(exit_code, output)
	"""

	# Create all leading dirs to output_aig if they don't exist
	output_dir = os.path.dirname(output_dimacs)
	if output_dir and not os.path.exists(output_dir):
		os.makedirs(output_dir)

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

def aig_to_blif(aig_file, output_blif="output.blif"):
	"""
	Convert an AIG file to BLIF using ABC.

	Args:
		aig_file (str): Input AIG file
		output_blif (str): Output BLIF file

	Returns:
		(exit_code, output)
	"""

	# Create all leading dirs to output_blif if they don't exist
	output_dir = os.path.dirname(output_blif)
	if output_dir and not os.path.exists(output_dir):
		os.makedirs(output_dir)

	abc_script = f"""
	read_aiger {aig_file};
	write_blif {output_blif}
	"""

	command = f'abc -c "{abc_script}"'
	out = run_command(command)
	if out.returncode != 0:
		raise RuntimeError(f"ABC BLIF conversion failed with exit code {out.returncode} and output:\n{out.output}")
	return out

def aig_miter(aig1, aig2, output_aig="miter.aig"):
	"""
	Generate a miter circuit from two AIG files using ABC.

	Args:
		aig1 (str): First AIG file
		aig2 (str): Second AIG file
		output_aig (str): Output miter AIG file

	Returns:
		(exit_code, output)
	"""

	# Create all leading dirs to output_aig if they don't exist
	output_dir = os.path.dirname(output_aig)
	if output_dir and not os.path.exists(output_dir):
		os.makedirs(output_dir)

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

def cadical_check(dimacs_file):
	"""
	Check satisfiability of a DIMACS CNF file using CaDiCaL.

	Args:
		dimacs_file (str): Input DIMACS CNF file

	Returns:
		(exit_code, output)
	"""
	err_c_map = {
		20: "UNSATISFIABLE",
		10: "SATISFIABLE",
		0: "INDETERMINATE"
	}

	command = f'cadical {dimacs_file}'
	out = run_command(command)
	
	return (err_c_map.get(out.returncode, "UNKNOWN"), out)

