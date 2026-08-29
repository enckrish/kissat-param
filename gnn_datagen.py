from setup import setup_tools, cnf_path
from tools_fns import kissat_check

setup_tools()

from math import ceil
from pathlib import Path

from ConfigSpace import Configuration, ConfigurationSpace

from smac import HyperparameterOptimizationFacade, Scenario

configspace = ConfigurationSpace(
	{
		'decay': [1] + [i for i in range(10, 201, 10)], 
		'eliminateeffort': [i for i in range(0, 2000, 100)], 
		'stable': [i for i in range(3)]
	})

circuit = cnf_path/"miter_mult_11bit.cnf"
reg_time, _, _ = kissat_check(circuit)
reg_time_fl = reg_time if reg_time else 0.0
timeout=int(ceil(ceil(reg_time_fl)*2.5))

print("Regular time:", reg_time_fl)

max_time_budget = 3600 * 3 # 3 hrs
min_iters = 20
time_budget = max(max_time_budget, min_iters * timeout)
print("Time budget:", time_budget)

def kissat_run(config: ConfigurationSpace, seed: int, dimacs: Path | str=circuit) -> float:
	rt, status, out = kissat_check(dimacs, config, timeout=timeout) # 2.5 x regular's timeout
	params_list = " ".join([f"--{k}={v}" for k, v in config.items()])
	print(rt, params_list)

	dimacs = Path(dimacs)
	config_str = ",".join(f"{k}-{v}" for k, v in config.items())
	log_fn = f"/home/krishnendu/Research/fv-invariant-mining/logs/kissat-{dimacs.stem}-{config_str}.log"
	with open(log_fn, "w", encoding="utf-8") as file:
		file.write(out.output)
	
	assert rt is not None
	if status == 'INDETERMINATE':
		rt *= 10 # penalize
	return float(rt)

# Scenario object specifying the optimization environment
scenario = Scenario(configspace, deterministic=True, n_trials=40, walltime_limit=time_budget)

# Use SMAC to find the best configuration/hyperparameters
smac = HyperparameterOptimizationFacade(scenario, kissat_run)
incumbent = smac.optimize()

