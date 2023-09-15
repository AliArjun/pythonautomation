import yaml

data = {
    "name": "John",
    "age": 30,
    "city": "New York",
}

# Create a custom style function to apply double quotes to specific attributes
def custom_style(dumper, tag, value):
    if tag == "!!str":
        attribute_name = dumper.serializer.processed[-1]
        if attribute_name == "city":
            return dumper.represent_scalar(tag, value, style='"')
    return dumper.represent_scalar(tag, value)

# Use the custom style function when dumping the data to YAML
yaml_string = yaml.dump(data, default_style=custom_style)

print(yaml_string)
