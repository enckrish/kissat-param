import subprocess

class TermOutput:
	def __init__(self, returncode, output):
		self.returncode = returncode
		self.output = output
		
def run_command(command):
	result = subprocess.run(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	return TermOutput(result.returncode, result.stdout.decode('utf-8') + result.stderr.decode('utf-8'))