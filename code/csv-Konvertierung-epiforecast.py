#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 19 12:16:18 2021

@author: annaklesen
"""

import pandas as pd

#Excel-Datei einlesen
path= './data-raw/Epiforecast/2020-12-31_epiforecast_raw.csv'
df= pd.read_csv(path, delimiter= ',')

#Datum extrahieren aus dem pfad
help1 = path.split("/", )
help2=help1[3]
datum=help2.split('_',1)

#Spalte data_version
df.insert(0, 'data_version', datum[0], True)

#Spalte target
df.insert(1, 'target', '14 day R', True)

#Spalte date und country tauschen
def swap_columns(df, c1, c2):
    df['temp'] = df[c1]
    df[c1] = df[c2]
    df[c2] = df['temp']
    df.drop(columns=['temp'], inplace=True)

swap_columns(df, 'country', 'date')

col_list = list(df)
col_list[2], col_list[3] = col_list[3], col_list[2]
df.columns = col_list

#Spalte country umbenennen
df.rename(columns= {'country': 'location'}, inplace=True)

#Spalte strat entfernen
df.drop('strat', axis=1, inplace=True)

#Spalte median und sd entfernen
df.drop('mean', axis=1, inplace=True)
df.drop('sd', axis=1, inplace=True)

#for column in df: print(column)

#Spalten in Zeilen umtransformieren 
df_t=df.melt(id_vars= ["data_version","target","date", 'location', 'type'],
                value_vars= ['median', 
                             'lower_90',
                             'lower_50', 
                             'lower_20', 
                             'upper_20', 
                             'upper_50', 
                             'upper_90'], 
                value_name="value")

#Spalten mit forecast löschen
df_t = df_t.drop(df_t[df_t.type == 'forecast'].index)
#Spalt mit allen Werten ungeleich Deutschland löschen
df_t = df_t.drop(df_t[df_t.location != 'Germany'].index)
df_t.loc[df_t.location=='Germany','location']='DE'

#Spalte type anpassen
df_t.loc[df_t.variable=='median','type']='point'
df_t.loc[df_t.variable=='lower_90','type']='quantile'
df_t.loc[df_t.variable=='lower_50','type']='quantile'
df_t.loc[df_t.variable=='lower_20','type']='quantile'
df_t.loc[df_t.variable=='upper_20','type']='quantile'
df_t.loc[df_t.variable=='upper_50','type']='quantile'
df_t.loc[df_t.variable=='upper_90','type']='quantile'

#Spalte Quantile einfügen und mit Werten befüllen
df_t.insert(5, 'quantile', '', True)
df_t.loc[df_t.variable=='median','quantile']='NA'
df_t.loc[df_t.variable=='lower_90','quantile']='0.05'
df_t.loc[df_t.variable=='lower_50','quantile']='0.25'
df_t.loc[df_t.variable=='lower_20','quantile']='0.4'
df_t.loc[df_t.variable=='upper_20','quantile']='0.6'
df_t.loc[df_t.variable=='upper_50','quantile']='0.75'
df_t.loc[df_t.variable=='upper_90','quantile']='0.95'


#Spalte variable entfernen
df_t.drop('variable', axis=1, inplace=True)

#Datei exportieren
df_t.to_csv('./data-processed/Epiforecast/'+datum[0]+'_epiforecast_processed.csv', index=False)
