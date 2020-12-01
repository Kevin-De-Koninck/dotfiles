# see https://stackoverflow.com/a/2829036/5149688
save_stdout = sys.stdout
sys.stdout = io.BytesIO()
# insert your code here
sys.stdout = save_stdout
