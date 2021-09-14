# download raw-files with the "extract_file_history.ipynb" script, then process them with this script

import pandas as pd
import os

path = './data-raw/zidatalab/'
files  = os.listdir(path)


for file in files:
    data = pd.read_json(path + file)
    data_version = data.iloc[len(data)-1,0]
    s = str(data_version)

    data = data.loc[data.name == 'Gesamt']
    data.insert(0, 'data_version', s[0:10])
    data.insert(1, 'target', '7 day R')
    data.insert(3, 'location', 'DE')
    data.insert(4, 'type', 'point')
    data.insert(5, 'quantile', 'NA')
    data = data.rename(columns={'R':'value'})
    data = data.iloc[:, :-2]

    file_name = './data-processed/zidatalab/' + s[0:10] + '_zidatalab.csv'
    data.to_csv(file_name, index = False)
