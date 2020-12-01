class base():
    def print_a(self):
        print "a"
    def print_b(self):
        print "b"
class inherit_1(base):
    def __init__(self):
        self.print_a()
class inherit_2(base):
    def __init__(self):
        self.print_a = self.print_b  # print_a know is the function print_b
        self.print_a()
c1 = inherit_1() # prints: 'a'
c2 = inherit_2() # prints: 'b'
