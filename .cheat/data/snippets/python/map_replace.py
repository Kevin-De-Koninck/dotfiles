#http://book.pythontips.com/en/latest/map_filter.html
#map(function_to_apply, list_of_inputs)
items = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x**2, items))
