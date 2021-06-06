#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jun  6 11:51:55 2021

@author: annaklesen
"""

import pandas as pd 
import os
import datetime

#Datum eingeben
datum= '2021-06-05'

#RKI Daten einlesen
path_rki = '/Users/annaklesen/Documents/GitHub/reproductive_numbers/data-processed/RKI/'
list=os.listdir(path_rki)

list1=[]

for i in list:
    if 'csv' in i: 
        list1.append(i)

list2=[]

for f in list1: 
   help = f[:10]
   diff=datetime.datetime.strptime(datum, "%Y-%m-%d")-datetime.datetime.strptime(help, "%Y-%m-%d")
   if  diff.days <= 30 :
       list2.append(f)

combined_csv_rki = pd.concat( [ pd.read_csv(path_rki+f) for f in list2 ] )

for i in combined_csv_rki['date']:
    diff=datetime.datetime.strptime(datum,"%Y-%m-%d")-datetime.datetime.strptime(i,"%Y-%m-%d")
    if diff.days > 30:
        print(diff.days)
        combined_csv_rki.drop(combined_csv_rki[combined_csv_rki['date'] == i].index, inplace = True)


#Model hinzufügen
combined_csv_rki.insert(0, 'model', 'RKI', True)

#4 Tage R entfernen
#Spalte target entfernen
combined_csv_rki.drop(combined_csv_rki[combined_csv_rki['target'] == '4 day R'].index, inplace = True)
combined_csv_rki.drop('target', axis=1, inplace=True)

#Spalte location entfernen
combined_csv_rki.drop('location', axis=1, inplace=True)

combined_csv_rki.loc[combined_csv_rki['quantile']==0.025,'type']='quantile_0.025'
combined_csv_rki.loc[combined_csv_rki['quantile']==0.975,'type']='quantile_0.975'
combined_csv_rki.drop('quantile', axis=1, inplace=True)

csv_rki= combined_csv_rki.pivot(index=['model', 'data_version','date'], columns='type')['value'].reset_index()
