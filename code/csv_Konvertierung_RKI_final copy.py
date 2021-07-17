#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May  4 17:35:37 2021

@author: annaklesen
"""

#notwendige Importe tätigen 
import pandas as pd
import datetime 
import os

path = "./data-processed/RKI_7day/"
rki= os.listdir(path)
#rki.remove('.DS_Store')
rki.sort()

print(rki)

def autoconvert_datetime(value):
    formats = ['%d.%m.%Y', '%Y-%m-%d']  # formats to try
    result_format = '%Y-%m-%d'  # output format
    for dt_format in formats:
        try:
            dt_obj = datetime.strptime(value, dt_format)
            return dt_obj.strftime(result_format)
        except Exception as e:  # throws exception when format doesn't match
            pass
    return value  # let it be if it doesn't match

for file in rki:
    df_rki= pd.read_csv(path+'/'+file, delimiter=",")  

    df_rki.rename({'quantil': 'quantile'}, axis=1, inplace=True) 

    df_rki['date'] = df_rki['date'].apply(autoconvert_datetime)         

    #df_rki['type'].replace({'UG_PI_Reproduktionszahl_R':'quantile'}, inplace=True)
    df_rki['value'].apply(lambda x: str(x).replace(',','.'))
    #df_rki.drop('Unnamed: 0', axis=1, inplace=True)
    #df_rki['quantile'].replace({'nan': 'NA'}, inplace=True)
    df_rki['quantile']=df_rki['quantile'].fillna('NA')
    df_rki['type'].replace({'quantil': 'quantile'}, inplace=True)

    df_rki.to_csv(path+'/'+file, index=False)