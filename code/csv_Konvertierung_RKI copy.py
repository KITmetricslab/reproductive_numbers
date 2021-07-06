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

path = "/Users/annaklesen/Documents/GitHub/reproductive_numbers/data-raw/Neuer Ordner/"
rki= os.listdir(path)
rki.remove('.DS_Store')
rki.sort()

print(rki)

for file in rki:
    df_rki= pd.read_excel(path+'/'+file, sheet_name='Nowcast_R')                 

    help1 = file.split("_", )
    help2=help1[2]
    datum=help2.split('.',1)

    df_rki.insert(0, 'data_version', datum[0], True)

    df_rki.rename(columns= {'Datum des Erkrankungsbeginns': 'date'}, inplace=True)
    
    df_rki.columns

    df_rki.drop('Punktschätzer der Anzahl Neuerkrankungen (ohne Glättung)', axis=1, inplace=True)

    df_rki.drop('Untere Grenze des 95%-Prädiktionsintervalls der Anzahl Neuerkrankungen (ohne Glättung)', axis=1, inplace=True)
    
    df_rki.drop('Obere Grenze des 95%-Prädiktionsintervalls der Anzahl Neuerkrankungen (ohne Glätttung)', axis=1, inplace=True)
   

    df_rki.drop('Punktschätzer der Anzahl Neuerkrankungen', axis=1, inplace=True)
    df_rki.drop('Untere Grenze des 95%-Prädiktionsintervalls der Anzahl Neuerkrankungen', axis=1, inplace=True)
    df_rki.drop('Obere Grenze des 95%-Prädiktionsintervalls der Anzahl Neuerkrankungen', axis=1, inplace=True)

    i=0
    for row in df_rki.date:
        new_date = datetime.datetime.strptime(str(row), '%d.%m.%Y').strftime('%Y-%m-%d')
        df_rki.date[i]=new_date
        i=i+1

    four_day_r = df_rki.iloc[:,[0,1,2,3,4]]
    seven_day_r= df_rki.iloc[:,[0,1,5,6,7]]

    four_day_r.insert(0, 'target', '4 day R', True)
    
    four_day_r.columns

    four_day_r_tr=four_day_r.melt(id_vars= ["data_version","target","date"],
                value_vars= ['Punktschätzer der 4-Tages R-Wert', 
                             'Untere Grenze des 95%-Prädiktionsintervalls der 4-Tages R-Wert',
                             'Obere Grenze des 95%-Prädiktionsintervalls der 4-Tages R-Wert'], 
                value_name="value")

    four_day_r_tr.insert(3, 'quantile', '', True)
    four_day_r_tr.loc[four_day_r_tr.variable=='Punktschätzer der 4-Tages R-Wert','quantile']='NA'
    four_day_r_tr.loc[four_day_r_tr.variable=='Untere Grenze des 95%-Prädiktionsintervalls der 4-Tages R-Wert','quantile']='0.025'
    four_day_r_tr.loc[four_day_r_tr.variable=='Obere Grenze des 95%-Prädiktionsintervalls der 4-Tages R-Wert','quantile']='0.975'

    four_day_r_tr.rename(columns= {'variable': 'type'}, inplace=True)
    four_day_r_tr['type'].replace({'Punktschätzer der 4-Tages R-Wert':'point'}, inplace=True)
    four_day_r_tr['type'].replace({'Untere Grenze des 95%-Prädiktionsintervalls der 4-Tages R-Wert':'quantile'}, inplace=True)
    four_day_r_tr['type'].replace({'Obere Grenze des 95%-Prädiktionsintervalls der 4-Tages R-Wert':'quantile'}, inplace=True)

    four_day_r_tr.insert(2, 'location', 'DE', True)

    four_day_r_tr.drop(four_day_r_tr[four_day_r_tr['value'] == '.'].index, inplace = True)
    four_day_r_tr.dropna(inplace = True)

    columnsTitles=['data_version', 'target', 'date', 'location', 'type', 'quantile', 'value']
    four_day_r_tr=four_day_r_tr.reindex(columns=columnsTitles)

    four_day_r_tr.to_csv('/Users/annaklesen/Documents/GitHub/reproductive_numbers/data-raw/Neuer Ordner/'+datum[0]+'-RKI_4day.csv', index=False)


    seven_day_r.insert(0, 'target', '7 day R', True)    


    seven_day_r_tr=seven_day_r.melt(id_vars= ["data_version","target","date"],
                value_vars= ['Punktschätzer des 7-Tage-R Wertes', 
                             'Untere Grenze des 95%-Prädiktionsintervalls des 7-Tage-R Wertes',
                             'Obere Grenze des 95%-Prädiktionsintervalls des 7-Tage-R Wertes'], 
                value_name="value")

    seven_day_r_tr.insert(3, 'quantile', '', True)
    seven_day_r_tr.loc[seven_day_r_tr.variable=='Punktschätzer des 7-Tage-R Wertes','quantile']='NA'
    seven_day_r_tr.loc[seven_day_r_tr.variable=='Untere Grenze des 95%-Prädiktionsintervalls des 7-Tage-R Wertes','quantile']='0.025'
    seven_day_r_tr.loc[seven_day_r_tr.variable=='Obere Grenze des 95%-Prädiktionsintervalls des 7-Tage-R Wertes','quantile']='0.975'

    seven_day_r_tr.rename(columns= {'variable': 'type'}, inplace=True)
    seven_day_r_tr['type'].replace({'Punktschätzer des 7-Tage-R Wertes':'point'}, inplace=True)
    seven_day_r_tr['type'].replace({'Untere Grenze des 95%-Prädiktionsintervalls des 7-Tage-R Wertes':'quantile'}, inplace=True)
    seven_day_r_tr['type'].replace({'Obere Grenze des 95%-Prädiktionsintervalls des 7-Tage-R Wertes': 'quantile'}, inplace=True)


    seven_day_r_tr.insert(2, 'location', 'DE', True)

    seven_day_r_tr.drop(seven_day_r_tr[seven_day_r_tr['value'] == '.'].index, inplace = True)
    seven_day_r_tr.dropna(inplace = True)

    columnsTitles=['data_version', 'target', 'date', 'location', 'type', 'quantile', 'value']
    seven_day_r_tr=seven_day_r_tr.reindex(columns=columnsTitles)

    seven_day_r_tr.to_csv('/Users/annaklesen/Documents/GitHub/reproductive_numbers/data-raw/Neuer Ordner/'+datum[0]+'-RKI_7day.csv', index=False)
