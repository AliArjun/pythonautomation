import re

# Input string
input_string = ''"SomeText"''

# Use regular expression to remove double quotes
output_string = re.sub(r'^"(.*)"$', r'\1', input_string)

print(output_string)