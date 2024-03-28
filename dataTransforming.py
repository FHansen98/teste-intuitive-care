import tabula
import pandas as pd
import zipfile


pdf_filename = 'Anexo_I_Rol_2021RN_465.2021_RN599_RN600.pdf'
tables = tabula.read_pdf(pdf_filename, pages='all', multiple_tables=True)

concat = pd.concat(tables)
concat.replace({'OD': 'Odontologia', 'AMB': 'Ambulatorial'}, inplace=True)

# Salvar os dados em um arquivo CSV
csv_filename = 'tabelas.csv'
concat.to_csv(csv_filename, index=False)
with zipfile.ZipFile('Teste_Felipe_Hansen.zip', 'w') as zipf:
  zipf.write(csv_filename)

print(f"Dados extraídos e compactados do PDF do Anexo I e salvos em '{csv_filename}'")
