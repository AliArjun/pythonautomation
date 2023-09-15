import yaml

data = {
    "name": "John",
    "age": 30,
    "city": "New York",
}

# Create a custom representer function to apply double quotes to specific attributes
def custom_representer(dumper, data):
    if isinstance(data, str) and dumper.alias_key is None:
        attribute_name = dumper.serializer.processed[-1]
        if attribute_name == "city":
            return dumper.represent_scalar("tag:yaml.org,2002:str", data, style='"')
    return dumper.represent_scalar("tag:yaml.org,2002:str", data)

# Register the custom representer function
yaml.add_representer(str, custom_representer)

# Use yaml.dump() to serialize the data
yaml_string = yaml.dump(data)

print(yaml_string)
