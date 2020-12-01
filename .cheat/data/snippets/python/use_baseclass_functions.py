class baseClass():
    def print_(self):
        print "a"
class inherit(baseClass):
    def print_(self):
        baseClass.print_(self)  # Use baseClass function, don't forget the 'self'
        print "b"
inherit().print_() # prints: 'a' 'b'
