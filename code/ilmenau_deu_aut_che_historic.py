import pandas as pd
import os
from os.path import exists

path = "../data-raw/Ilmenau DEU/"
files = os.listdir(path)

for file in files:
    if( exists("../data-raw/Ilmenau AUT/" + file[0:10] + "_ilmenau_aut_raw.csv") and exists("../data-raw/Ilmenau CHE/" + file[0:10] + "_ilmenau_che_raw.csv")):
        data_deu = pd.read_csv(path+file)
        data_aut = pd.read_csv("../data-raw/Ilmenau AUT/" + file[0:10] + "_ilmenau_aut_raw.csv")
        data_che = pd.read_csv("../data-raw/Ilmenau CHE/" + file[0:10] + "_ilmenau_che_raw.csv")
        df = pd.DataFrame()

        for i in range(0, len(data_deu)):
            df = df.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["7 day R", "7 day R", "7 day R"], 'date': [data_deu.iloc[i, 0], data_deu.iloc[i, 0], data_deu.iloc[i, 0]], 'location': ["DE", "DE", "DE"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [data_deu.iloc[i, 2], data_deu.iloc[i, 4], data_deu.iloc[i, 5]]}))
        
        for i in range(0, len(data_aut)):
            df = df.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["7 day R", "7 day R", "7 day R"], 'date': [data_aut.iloc[i, 0], data_aut.iloc[i, 0], data_aut.iloc[i, 0]], 'location': ["AT", "AT", "AT"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [data_aut.iloc[i, 2], data_aut.iloc[i, 4], data_aut.iloc[i, 5]]}))
        
        for i in range(0, len(data_che)):
            df = df.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["7 day R", "7 day R", "7 day R"], 'date': [data_che.iloc[i, 0], data_che.iloc[i, 0], data_che.iloc[i, 0]], 'location': ["CH", "CH", "CH"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [data_che.iloc[i, 2], data_che.iloc[i, 4], data_che.iloc[i, 5]]}))
        
        df.to_csv("../data-processed/ilmenau/" + file[0:10] + "-ilmenau.csv", index=False, index_label=False)
    
