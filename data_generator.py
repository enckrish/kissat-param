from setup import setup_tools, data_path, aig_path, verilog_path, cnf_path, aag_path
from tools_fns import verilog_to_aig, aig_miter, aig_to_dimacs, aig_cec, cadical_check, aig_to_aag
import os

setup_tools()

def process_n_bit_mult(n: int):
	width = n
	
    # Update the Verilog file with the current bit width
	with open(verilog_path / "multipliers.v", "r") as f:
		verilog_content = f.read()
	
	verilog_content = verilog_content.replace("{{BIT_WIDTH}}", str(width))
	
	# Write the updated content to a temporary file (to avoid modifying the original template)
	temp_verilog_file = verilog_path / f"multipliers_{width}bit.v"
	with open(temp_verilog_file, "w") as f:
		f.write(verilog_content)
	
	# Generate AIG files for both the unrolled and behavioral multiplier modules
	top_module_unrolled = f"unrolled_mult_{width}bit"
	top_module_behavioral = f"behavioral_mult_{width}bit"
	verilog_to_aig(temp_verilog_file, "unrolled_mult", aig_path/f"{top_module_unrolled}.aig")
	verilog_to_aig(temp_verilog_file, "behavioral_mult", aig_path/f"{top_module_behavioral}.aig")

	# Remove the temporary Verilog file
	os.remove(temp_verilog_file)

	aig_to_aag(aig_path/f"{top_module_unrolled}.aig", aag_path/f"{top_module_unrolled}.aag")
	aig_to_aag(aig_path/f"{top_module_behavioral}.aig", aag_path/f"{top_module_behavioral}.aag")

	aig_miter(aig_path/f"unrolled_mult_{width}bit.aig", aig_path/f"behavioral_mult_{width}bit.aig", aig_path/f"miter_mult_{width}bit.aig")
	aig_to_dimacs(aig_path/f"miter_mult_{width}bit.aig", cnf_path/f"miter_mult_{width}bit.cnf")
	aig_to_aag(aig_path/f"miter_mult_{width}bit.aig", aag_path/f"miter_mult_{width}bit.aag")

	aig_to_dimacs(aig_path/f"unrolled_mult_{width}bit.aig", cnf_path/f"unrolled_mult_{width}bit.cnf")
	aig_to_dimacs(aig_path/f"behavioral_mult_{width}bit.aig", cnf_path/f"behavioral_mult_{width}bit.cnf")

def process_n_bit_addr(n: int):
	width = n
	
    # Update the Verilog file with the current bit width
	with open(verilog_path / "adders.v", "r") as f:
		verilog_content = f.read()
	
	verilog_content = verilog_content.replace("{{BIT_WIDTH}}", str(width))
	
	# Write the updated content to a temporary file (to avoid modifying the original template)
	temp_verilog_file = verilog_path / f"adders_{width}bit.v"
	with open(temp_verilog_file, "w") as f:
		f.write(verilog_content)
	
	# Generate AIG files for both the unrolled and behavioral multiplier modules
	top_module_rc = f"rc_addr_{width}bit"
	top_module_behavioral = f"behavioral_addr_{width}bit"
	verilog_to_aig(temp_verilog_file, "ripple_carry_adder", aig_path/f"{top_module_rc}.aig")
	verilog_to_aig(temp_verilog_file, "behavioral_adder", aig_path/f"{top_module_behavioral}.aig")

	# Remove the temporary Verilog file
	os.remove(temp_verilog_file)

	aig_to_aag(aig_path/f"{top_module_rc}.aig", aag_path/f"{top_module_rc}.aag")
	aig_to_aag(aig_path/f"{top_module_behavioral}.aig", aag_path/f"{top_module_behavioral}.aag")

	aig_miter(aig_path/f"rc_addr_{width}bit.aig", aig_path/f"behavioral_addr_{width}bit.aig", aig_path/f"miter_addr_{width}bit.aig")
	aig_to_dimacs(aig_path/f"miter_addr_{width}bit.aig", cnf_path/f"miter_addr_{width}bit.cnf")
	aig_to_aag(aig_path/f"miter_addr_{width}bit.aig", aag_path/f"miter_addr_{width}bit.aag")

	aig_to_dimacs(aig_path/f"rc_addr_{width}bit.aig", cnf_path/f"rc_addr_{width}bit.cnf")
	aig_to_dimacs(aig_path/f"behavioral_addr_{width}bit.aig", cnf_path/f"behavioral_addr_{width}bit.cnf")


for width in range(1, 15):
	print(f"Processing {width}-bit multiplier...")
	process_n_bit_mult(width)

for width in range(1, 15):
	print(f"Processing {width}-bit adder...")
	process_n_bit_addr(width)

for width in range(1, 15):
	# Generate miter for adder with multiplier
	print(f"Generating miter for {width}-bit adder and multiplier...")
	aig_miter(aig_path/f"rc_addr_{width}bit.aig", aig_path/f"behavioral_mult_{width}bit.aig", aig_path/f"miter_addr_mult_{width}bit.aig")
	aig_to_aag(aig_path/f"miter_addr_mult_{width}bit.aig", aag_path/f"miter_addr_mult_{width}bit.aag")
	aig_to_dimacs(aig_path/f"miter_addr_mult_{width}bit.aig", cnf_path/f"miter_addr_mult_{width}bit.cnf")


def process_n_bit_mult_genmul(n: int, comp_name: str):
	width = n
	
	# Update the Verilog file with the current bit width
	v_file_path = verilog_path / "genmul_verilog_circuits" / f"{width}_{width}_{comp_name}_GenMul.v" 
	
	# Generate AIG files for both the unrolled and behavioral multiplier modules
	top_module = f"Mult_{bw}_{bw}"
	export_name = f"{comp_name}_{width}bit"
	verilog_to_aig(v_file_path, top_module, aig_path/f"{export_name}.aig", flatten=True)
	aig_to_aag(aig_path/f"{export_name}.aig", aag_path/f"{export_name}.aag")

	aig_to_dimacs(aig_path/f"{export_name}.aig", cnf_path/f"{export_name}.cnf")


comp_names = ["U_SP_AR_RC", "U_SP_DT_RC", "U_SP_WT_RC"]

for cn in comp_names:
	print(f"Processing {cn}...")
	for bw in range(6, 13):
		print(f"Synthesizing bit_width={bw}")
		process_n_bit_mult_genmul(bw, cn)
	print()

for bw in range(6, 13):
	print(f"Processing miters for bit_width={bw}")
	miter_combs = [(0, 1), (1, 2), (0, 2)]
	for src1, src2 in miter_combs:
		cn1 = comp_names[src1]
		cn2 = comp_names[src2]
		
		name1 = f"{cn1}_{bw}bit"
		name2 = f"{cn2}_{bw}bit"
		
		aig_miter(aig_path/f"{name1}.aig", aig_path/f"{name2}.aig", aig_path/f"miter_{cn1}_{cn2}_{bw}bit.aig")
		aig_to_aag(aig_path/f"miter_{cn1}_{cn2}_{bw}bit.aig", aag_path/f"miter_{cn1}_{cn2}_{bw}bit.aag")
		aig_to_dimacs(aig_path/f"miter_{cn1}_{cn2}_{bw}bit.aig", cnf_path/f"miter_{cn1}_{cn2}_{bw}bit.cnf")
		

