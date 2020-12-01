# lets say you want to pass this fucntion with parameters to another function: add(1, 2)
other_func(lambda: add(1,2))
def ohter_func(f):
    f()             # here you execute it

# -----------------------------------------------------------------------------

# Simple Lambda Function
a = lambda parameter: parameter + 40
print (a(2))                    # Outputs 42

# -----------------------------------------------------------------------------

# Lambda Functions Inside Real Functions
def subtract_func(n) :
    return lambda x: x - n
a = subtract_func(1)            # Sets n to 1 for a
b = subtract_func(2)            # Sets n to 2 for b
print(a(-4))                    # Outputs -5 ( -5 = -4 - 1 )
print(b(-2))                    # Outputs -4 ( -4 = -2 - 2 )

# -----------------------------------------------------------------------------

# Lambda Function with Multiple Parameters
f = lambda x, y : x + y
print( f(1,1) )                 # Outputs 2 ( 1 + 1 )

# -----------------------------------------------------------------------------

# map() + lambda functions
a = [1, 2, 3, 4, 5]
b = [1, 2, 3, 4, 5]
r = map(lambda x,y : x+y, a,b)  # map() will return an iterator
r_list = list(r)                # listify r
print(r_list)                   # prints [2, 4, 6, 8, 10]

# -----------------------------------------------------------------------------

# filter() + lambda functions
# Program to filter out only the even items from a list
my_list = [1, 5, 4, 6, 8, 11, 3, 12]
new_list = list(filter(lambda x: (x%2 == 0) , my_list))
print(new_list)                 # Output: [4, 6, 8, 12]

