#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May  1 14:25:52 2021

@author: annaklesen
"""

#notwendige Importe tätigen 
import pandas as pd
import datetime

#CSV-Datei mit den neuen Daten einlesen
path= './data-raw/RKI/Nowcast_R_2021-05-31.csv'
df_rki= pd.read_csv(path, delimiter= ',')

#Datum extrahieren aus dem pfad
help1 = path.split("_", )
help2=help1[2]
datum=help2.split('.',1)

#for column in df_rki: print(column)

#Spalte data_version
#Datum hier entsprechend anpassen!
df_rki.insert(0, 'data_version', datum[0], True)

#Spalte Datum umbenennen
df_rki.rename(columns= {'Datum': 'date'}, inplace=True)

df_rki.dropna(inplace=True)

#Nicht benötigte Spalten entfernen
df_rki.drop('PS_COVID_Faelle', axis=1, inplace=True)
df_rki.drop('UG_PI_COVID_Faelle', axis=1, inplace=True)
df_rki.drop('OG_PI_COVID_Faelle', axis=1, inplace=True)
df_rki.drop('PS_COVID_Faelle_ma4', axis=1, inplace=True)
df_rki.drop('UG_PI_COVID_Faelle_ma4', axis=1, inplace=True)
df_rki.drop('OG_PI_COVID_Faelle_ma4', axis=1, inplace=True)


#Dataframe spliten
four_day_r = df_rki.iloc[:,[0,1,2,3,4]]
seven_day_r= df_rki.iloc[:,[0,1,5,6,7]]


#Daten für den 4-Tage-Schätzer transformieren
#Neue Spalte target einfügen 
four_day_r.insert(0, 'target', '4 day R', True)

#Spalten in Zeilen transformieren 
four_day_r_tr=four_day_r.melt(id_vars= ["data_version","target","date"],
                value_vars= ['PS_4_Tage_R_Wert', 
                             'UG_PI_4_Tage_R_Wert',
                             'OG_PI_4_Tage_R_Wert'], 
                value_name="value")

#Spalte quantil einfügen
four_day_r_tr.insert(3, 'quantile', '', True)
four_day_r_tr.loc[four_day_r_tr.variable=='PS_4_Tage_R_Wert','quantile']='NA'
four_day_r_tr.loc[four_day_r_tr.variable=='UG_PI_4_Tage_R_Wert','quantile']='0.025'
four_day_r_tr.loc[four_day_r_tr.variable=='OG_PI_4_Tage_R_Wert','quantile']='0.975'

#Spalte type 
four_day_r_tr.rename(columns= {'variable': 'type'}, inplace=True)
four_day_r_tr['type'].replace({'PS_4_Tage_R_Wert':'point'}, inplace=True)
four_day_r_tr['type'].replace({'UG_PI_4_Tage_R_Wert':'quantile'}, inplace=True)
four_day_r_tr['type'].replace({'OG_PI_4_Tage_R_Wert':'quantile'}, inplace=True)

#Spalte location einfügen
four_day_r_tr.insert(2, 'location', 'DE', True)


#Daten für den 7-Tage-Schätzer transformieren
#Neue Spalte target einfügen 
seven_day_r.insert(0, 'target', '7 day R', True)    

#Spalten in Zeilen transformieren 
seven_day_r_tr=seven_day_r.melt(id_vars= ["data_version","target","date"],
                value_vars= ['PS_7_Tage_R_Wert', 
                             'UG_PI_7_Tage_R_Wert',
                             'OG_PI_7_Tage_R_Wert'], 
                value_name="value")

#Spalte quantil einfügen
seven_day_r_tr.insert(3, 'quantile', '', True)
seven_day_r_tr.loc[seven_day_r_tr.variable=='PS_7_Tage_R_Wert','quantile']='NA'
seven_day_r_tr.loc[seven_day_r_tr.variable=='UG_PI_7_Tage_R_Wert','quantile']='0.025'
seven_day_r_tr.loc[seven_day_r_tr.variable=='OG_PI_7_Tage_R_Wert','quantile']='0.975'

#Spalte type 
seven_day_r_tr.rename(columns= {'variable': 'type'}, inplace=True)
seven_day_r_tr['type'].replace({'PS_7_Tage_R_Wert':'point'}, inplace=True)
seven_day_r_tr['type'].replace({'UG_PI_7_Tage_R_Wert':'quantile'}, inplace=True)
seven_day_r_tr['type'].replace({'OG_PI_7_Tage_R_Wert': 'quantile'}, inplace=True)

#Spalte location einfügen
seven_day_r_tr.insert(3, 'location', 'DE', True)

#beide Tabellen untereinanderfügen
df_rki_merged= pd.concat([four_day_r_tr,seven_day_r_tr], axis=0)

#alle Zeilen ohne Werte entfernen
df_rki_merged.drop(df_rki_merged[df_rki_merged['value'] == '.'].index, inplace = True)
df_rki_merged.dropna(inplace = True)


#Spalten in die richtige Reihenfolge bringen
columnsTitles=['data_version', 'target', 'date', 'location', 'type', 'quantile', 'value']
df_rki_merged=df_rki_merged.reindex(columns=columnsTitles)


#neue Datei abspeichern
#Datum im Namen anpassen!
df_rki_merged.to_csv('./data-processed/RKI/'+datum[0]+'-RKI.csv', index=False)

