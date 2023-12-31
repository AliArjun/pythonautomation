import pandas as pd
import yaml

def excel_to_yaml(input_excel_path, output_yaml_path):
    # Read Excel file into a DataFrame
    df = pd.read_excel(input_excel_path)

    # Create a list to store the YAML data
    yaml_data = []

    # Iterate through each row in the DataFrame
    for index, row in df.iterrows():
        table_name = row['TABLE_NAME']
        table_desc = row['TABLE_DESC']

        # Create a dictionary for each table
        table_dict = {
            'name': f'HYPE_{table_name}',
            'database': 'DB_ONE',
            'schema': f'BONE_{table_name}',
            'tables': [{
                'name': table_name,
                'description': table_desc
            }]
        }

        # Add the table dictionary to the YAML data list
        yaml_data.append(table_dict)

    # Convert the list to YAML format
    yaml_output = yaml.dump({'version': 2, 'sources': yaml_data}, default_flow_style=False)

    # Write the YAML output to a file
    with open(output_yaml_path, 'w') as yaml_file:
        yaml_file.write(yaml_output)

if __name__ == "__main__":
    # Replace 'input.xlsx' and 'output.yaml' with your file paths
    excel_to_yaml('input.xlsx', 'output.yaml')
