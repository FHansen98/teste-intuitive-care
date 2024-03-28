import requests
from bs4 import BeautifulSoup
import os
import zipfile

def find_annex(body, text):
  body_soup = BeautifulSoup(body, "html.parser")
  annex_list = body_soup.find_all("a", class_="internal-link")
  for annex in annex_list:
    if annex and annex.get_text() == text:
      link = annex.get('href')
      if link.endswith('.pdf'):
          filename = os.path.basename(link)
          with open(filename, 'wb') as file:
              file.write(requests.get(link).content)
      break

url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos"

response = requests.get(url)
print(response)

if response.status_code==200:
  with zipfile.ZipFile('anexos.zip', 'w') as zipf:
    find_annex(response.content, 'Anexo I')
    find_annex(response.content, 'Anexo II.')
    for filename in os.listdir('.'):
      if filename.endswith('.pdf'):
        zipf.write(filename)