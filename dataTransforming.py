import tabula
import pandas as pd
import zipfile

pdf_filename = 'Anexo_I_Rol_2021RN_465.2021_RN599_RN600.pdf'
tables = tabula.read_pdf(pdf_filename, pages='all', multiple_tables=True)

concat = pd.concat(tables)
concat.columns = concat.columns.map(lambda x: x.replace('\r', ''))

concat.map(lambda x: x.replace('\r', ' ') if isinstance(x, str) else x)
concat.replace({'OD': 'Odontologia', 'AMB': 'Ambulatorial'}, inplace=True)


csv_filename = 'tabelas.csv'
concat.to_csv(csv_filename, index=False, sep=';')
with zipfile.ZipFile('Teste_Felipe_Hansen.zip', 'w') as zipf:
  zipf.write(csv_filename)
