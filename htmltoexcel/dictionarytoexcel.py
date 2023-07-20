import os
import pandas as pd
from bs4 import BeautifulSoup

def extract_entity_info(file_path):
    with open(file_path, 'r') as file:
        soup = BeautifulSoup(file, 'html.parser')
        entity_name = soup.find('h1').text.strip()
        description = soup.find('h2').text.strip()
        fields = soup.find_all('h3')

        table_name = entity_name.split('(')[0].strip()
        columns = []
        column_descriptions = []

        for field in fields:
            column_name = field.text.strip().split()[0]
            column_description = field.find_next('p').text.strip()

            columns.append(column_name)
            column_descriptions.append(column_description)

        return table_name, columns, column_descriptions

def generate_excel(folder_path, output_file):
    table_names = []
    all_columns = []
    all_descriptions = []

    for file_name in os.listdir(folder_path):
        if file_name.endswith('.html'):
            file_path = os.path.join(folder_path, file_name)
            table_name, columns, column_descriptions = extract_entity_info(file_path)

            table_names.append(table_name)
            all_columns.append(columns)
            all_descriptions.append(column_descriptions)

    df = pd.DataFrame({'Table Name': table_names, 'Columns': all_columns, 'Description': all_descriptions})
    df.to_excel(output_file, index=False)

# Provide the folder path containing the HTML files and the output Excel file path
folder_path = 'path/to/html/files/folder'
output_file = 'path/to/output/excel/file.xlsx'

generate_excel(folder_path, output_file)