import pandas as pd
import yaml

# Read the Excel file with column mapping
excel_file = "column_mapping.xlsx"
df = pd.read_excel(excel_file)

# Initialize the schema dictionary
schema = {
    "version": 1,
    "models": [
        {
            "name": "your_model_name",  # Specify your model name here
            "description": "Your model description"
        }
    ],
    "columns": []
}

# Iterate through the Excel rows and add columns to the schema
for index, row in df.iterrows():
    column_info = {
        "name": row["Target Column"],
        "description": row["Target Attribute"],
        "column_type": row["Target Data Type"]
    }
    schema["columns"].append(column_info)

# Convert the schema dictionary to YAML format
schema_yaml = yaml.dump(schema, default_flow_style=False)

# Save the YAML to a file
with open("schema.yml", "w") as yaml_file:
    yaml_file.write(schema_yaml)

print("Schema YAML file generated: schema.yml")
