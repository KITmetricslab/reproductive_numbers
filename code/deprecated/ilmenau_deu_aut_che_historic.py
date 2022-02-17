
import datetime
import pandas as pd
from os.path import exists

path_d = "../data-raw/Ilmenau DEU/"
path_a = "../data-raw/Ilmenau AUT/"
path_c = "../data-raw/Ilmenau CHE/"

d1 = datetime.date(2020,11,3) # since this date all three files have the same format
today = datetime.date.today()
delta = datetime.timedelta(days=1)

while d1 < today:
    # empty DataFrame:
    df = pd.DataFrame()
    # flag to indicate if there exists a file for this date for at least one country, 
    # otherwise don't write a (empty) file:
    date_found = False

    # test for each day and country if the file exists:
    if exists(path_d + str(d1) + "_ilmenau_deu_raw.csv"):
        date_found = True 
        data_deu = pd.read_csv(path_d + str(d1) + "_ilmenau_deu_raw.csv")

        for i in range(0, len(data_deu)):
            df = df.append(pd.DataFrame({'data_version': [str(d1), str(d1), str(d1)], 'target': ["7 day R", "7 day R", "7 day R"], 'date': [data_deu.iloc[i, 0], data_deu.iloc[i, 0], data_deu.iloc[i, 0]], 'location': ["DE", "DE", "DE"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [data_deu.iloc[i, 2], data_deu.iloc[i, 4], data_deu.iloc[i, 5]]}))
   
    if exists(path_a + str(d1) + "_ilmenau_aut_raw.csv"):
        date_found = True
        data_aut = pd.read_csv(path_a + str(d1) + "_ilmenau_aut_raw.csv")    

        for i in range(0, len(data_aut)):
            df = df.append(pd.DataFrame({'data_version': [str(d1), str(d1), str(d1)], 'target': ["7 day R", "7 day R", "7 day R"], 'date': [data_aut.iloc[i, 0], data_aut.iloc[i, 0], data_aut.iloc[i, 0]], 'location': ["AT", "AT", "AT"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [data_aut.iloc[i, 2], data_aut.iloc[i, 4], data_aut.iloc[i, 5]]}))
        
    if exists(path_c + str(d1) + "_ilmenau_che_raw.csv"):
        date_found = True
        data_che = pd.read_csv(path_c + str(d1) + "_ilmenau_che_raw.csv")    

        for i in range(0, len(data_che)):
            df = df.append(pd.DataFrame({'data_version': [str(d1), str(d1), str(d1)], 'target': ["7 day R", "7 day R", "7 day R"], 'date': [data_che.iloc[i, 0], data_che.iloc[i, 0], data_che.iloc[i, 0]], 'location': ["CH", "CH", "CH"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [data_che.iloc[i, 2], data_che.iloc[i, 4], data_che.iloc[i, 5]]}))
        
    if date_found: # don't write an empty file, if none of the countries reported for this date
        print('found')
        df = df.drop_duplicates()
        df.to_csv("../data-processed/ilmenau/" + str(d1) + "-ilmenau.csv", index=False, index_label=False)
    
    # update the date
    d1 += delta 