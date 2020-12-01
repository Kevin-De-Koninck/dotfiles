def lala(a=None, b=None):
  print a
  print b
z = {"1": {'a': "6"},  # place arguments in dictionary (key must be string, and key is argument name)
     "2": {'b': "8"}}
lala(**z["1"])          # prints: 6, None
lala(**z["2"])      # prints: None, 8
