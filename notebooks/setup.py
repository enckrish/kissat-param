import os
from pathlib import Path

PROJECT_ROOT = Path.cwd().resolve().parent
data_path = PROJECT_ROOT / "data"
circuits_path = data_path/"circuits"
verilog_path = circuits_path/"verilog"
aig_path = circuits_path/"aig"
blif_path = circuits_path/"blif"
cnf_path = circuits_path/"cnf"
aag_path = circuits_path/"aag"

def setup_tools():
    # Project root (directory containing this script)
    print(f"Setting project root: {PROJECT_ROOT}")

    # Tool paths
    tool_paths = [
        PROJECT_ROOT / ".tools/cadical/build",
        PROJECT_ROOT / ".tools/abc",
        PROJECT_ROOT / ".tools/oss-cad-suite/bin",
        PROJECT_ROOT / ".tools/aiger",
        PROJECT_ROOT / ".tools/cadiback/",
    ]

    # Update PATH (prepend like the shell script)
    os.environ["PATH"] = ":".join(map(str, tool_paths)) + ":" + os.environ["PATH"]

    print(f"Updated PATH to include: {tool_paths}")

    # If you also want the variable exported like in bash
    os.environ["PROJECT_ROOT"] = str(PROJECT_ROOT)