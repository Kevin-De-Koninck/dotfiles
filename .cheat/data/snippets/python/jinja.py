from jinja2 import Template
print Template('{% if name != "Jeff" %}Nothing to see here move along{% else %}Hello {{name}}, how are you?{% endif %}').render({"name": "Jeff"})
print Template('{{ this_var_does_not_exist | default("hehe") }}').render({})
