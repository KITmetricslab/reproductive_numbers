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

path = "./data-processed/RKI_4day/"
rki= os.listdir(path)
rki.remove('.DS_Store')
rki.sort()

print(rki)

for file in rki:
    df_rki= pd.read_csv(path+'/'+file, delimiter=",", index=False)            

    #df_rki['type'].replace({'UG_PI_Reproduktionszahl_R':'quantile'}, inplace=True)
    #df_rki['value'].apply(lambda x: str(x).replace(',','.'))
    df_rki.drop('Unnamed: 0', axis=1, inplace=True)
    df_rki['quantile'].replace({'': 'NA'}, inplace=True)
    df_rki['type'].replace({'quantil': 'quantile'}, inplace=True)

    df_rki.to_csv(path+'/'+file, index=False)