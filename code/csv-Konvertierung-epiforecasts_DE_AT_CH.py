#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 19 12:16:18 2021

@author: annaklesen
"""

#notwendige Importe tätigen 
import pandas as pd
import datetime
import os

path = "./data-raw/epiforecast_au_ch_ger/"
epi= os.listdir(path)
epi.remove('.DS_Store')
epi.sort()

print(epi)

for file in epi[epi.index('2020-09-17_epiforecast_raw.csv'):]: # Spalte "mean" erst ab 17.09.2020 vorhanden
    df= pd.read_csv(path+'/'+file, delimiter= ',')

    #Datum extrahieren aus dem pfad
    datum = file.split("_", )

    df.insert(0, 'data_version', datum[0], True)

    #Spalte target
    df.insert(1, 'target', '1 day R', True)

    #Spalte country umbenennen
    df.rename({'country': 'location'}, axis=1, inplace=True)

    for column in df: print(column)

    #95%-Intervall schätzen
    df['upper_95']= df['mean']+ 1.96*df['sd']
    df['lower_95']=df['mean']-1.96*df['sd']

    #Spalten in Zeilen umtransformieren 
    df_t=df.melt(id_vars= ["data_version",'target','date', 'location', 'type'],
                value_vars= ['median',
                            'lower_95',
                             'lower_90',
                             'lower_50', 
                             'lower_20', 
                             'upper_20', 
                             'upper_50', 
                             'upper_90',
                             'upper_95'], 
                value_name="value")

    #Spalten mit forecast löschen
    df_t = df_t.drop(df_t[df_t.type == 'forecast'].index)
    #Spalt mit allen Werten ungeleich Deutschland löschen
    df_t.replace({'Germany': 'DE'}, inplace=True)
    df_t.replace({'Austria': 'AT'}, inplace=True)
    df_t.replace({'Switzerland': 'CH'}, inplace=True)


    #Spalte type anpassen
    df_t.loc[df_t.variable=='median','type']='point'
    df_t.loc[df_t.variable=='lower_95','type']='quantile'
    df_t.loc[df_t.variable=='lower_90','type']='quantile'
    df_t.loc[df_t.variable=='lower_50','type']='quantile'
    df_t.loc[df_t.variable=='lower_20','type']='quantile'
    df_t.loc[df_t.variable=='upper_20','type']='quantile'
    df_t.loc[df_t.variable=='upper_50','type']='quantile'
    df_t.loc[df_t.variable=='upper_90','type']='quantile'
    df_t.loc[df_t.variable=='upper_95','type']='quantile'

    #Spalte Quantile einfügen und mit Werten befüllen
    df_t.insert(5, 'quantile', '', True)
    df_t.loc[df_t.variable=='median','quantile']='NA'
    df_t.loc[df_t.variable=='lower_95','quantile']='0.025'
    df_t.loc[df_t.variable=='lower_90','quantile']='0.05'
    df_t.loc[df_t.variable=='lower_50','quantile']='0.25'
    df_t.loc[df_t.variable=='lower_20','quantile']='0.4'
    df_t.loc[df_t.variable=='upper_20','quantile']='0.6'
    df_t.loc[df_t.variable=='upper_50','quantile']='0.75'
    df_t.loc[df_t.variable=='upper_90','quantile']='0.95'
    df_t.loc[df_t.variable=='upper_95','quantile']='0.975'

    #Spalte variable entfernen
    df_t.drop('variable', axis=1, inplace=True)

    columnsTitles=['data_version', 'target', 'date', 'location', 'type', 'quantile', 'value']
    df_t=df_t.reindex(columns=columnsTitles)

    #Datei exportieren
    df_t.to_csv('./data-processed/epiforecasts/'+datum[0]+'-epiforecasts.csv', index=False)
