import traceback
try:
    x = 0
    print x/x
except:
    traceback.print_exc() # ZeroDivisionError: integer division or modulo by zero
