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
		
def run_command(command: str, timeout: int | None = None):
    try:
        result = subprocess.run(
            command, 
            shell=True, 
            stdout=subprocess.PIPE, 
            stderr=subprocess.PIPE,
            timeout=timeout  # Added timeout logic
        )
        output = result.stdout.decode('utf-8') + result.stderr.decode('utf-8')
        return TermOutput(result.returncode, output)
        
    except subprocess.TimeoutExpired as e:
        # Capture whatever output was produced before the timeout, if any
        stdout = e.stdout.decode('utf-8') if e.stdout else ""
        stderr = e.stderr.decode('utf-8') if e.stderr else ""
        timeout_msg = f"\n[ERROR]: Command timed out after {timeout} seconds."
        
        # Return a non-zero exit code (standard for errors)
        return TermOutput(124, stdout + stderr + timeout_msg)