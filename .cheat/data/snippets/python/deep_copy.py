# shallow copy
a = [[1, 2], [6, 7], [9, 4]]
a.append(a[-1])                     # now 'a' is [[1, 2], [6, 7], [9, 4], [9, 4]]
a[-1][0] = 122                      # now 'a' is [[1, 2], [6, 7], [122, 4], [122, 4]]

# deep copy
from copy import deepcopy
a = [[1, 2], [6, 7], [9, 4]]
a.append(deepcopy(a[-1]))           # now 'a' is [[1, 2], [6, 7], [9, 4], [9, 4]]
a[-1][0] = 122                      # now 'a' is [[1, 2], [6, 7], [9, 4], [122, 4]]

# custom but fast implementation of deepcopy
  def deepcopy(original):
    new = dict().fromkeys(original)
    for k, v in original.iteritems():
      try:
        new[k] = v.copy()  # dicts, sets
      except AttributeError:
        try:
          new[k] = v[:]  # lists, tuples, strings, unicode
        except TypeError:
          new[k] = v  # ints
    return new
    
