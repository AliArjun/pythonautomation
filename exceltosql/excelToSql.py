import pandas as pd
from jinja2 import Template

# Load Excel data into a DataFrame
excel_file_path = 'C:\\Users\\Nag\\Documents\\elt1.xlsx'
df = pd.read_excel(excel_file_path)

# SQL template
sql_template1 = """
 from {{epb_db_dev}}.{{cda_base_schema}}.DRIVE_TABLE DRIVE
"""

sql_template2 = """
  left join {{epb_db_dev}}.{{cda_base_schema}}.{{source_table}} alias_{{n}}
  ON DRIVE.{{target_column}} = alias_{{n}}.ID
  and DRIVE.updatetime >= alias_{{n}}.rec_eff_ts
  and DRIVE.updatetime < alias_{{n}}.rec_expir_ts
"""

# Process each row in the Excel data
queries = []
for index, row in df.iterrows():
    variables = {
        'epb_db_dev': 'your_epb_db_dev',
        'cda_base_schema': 'your_cda_base_schema',
        'source_table': row['Source Table'],
        'target_column': row['Target Column'],
        'n': index + 1,
    }
    template1 = Template(sql_template1)
    query_base = template1.render(variables)
    template2 = Template(sql_template2)
    query = template2.render(variables)
    queries.append(query)
# Concatenate all queries into a single string
final_query = '\n'.join(queries)
print(query_base + '\n'+ final_query)
