import subprocess

class TermOutput:
	def __init__(self, returncode: int, output: str):
		self.returncode = returncode
		self.output = output
	
	def chk(self, returncode: int):
		assert returncode == self.returncode, f"Expected returncode {returncode}, got {self.returncode}"
		return self
	
	def print(self):
		print(f"return code: {self.returncode}")
		print(self.output)
		
def run_command(command: str):
	result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	return TermOutput(result.returncode, result.stdout.decode('utf-8') + result.stderr.decode('utf-8'))