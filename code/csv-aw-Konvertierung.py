#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 23 12:02:36 2021

@author: annaklesen
"""

import pandas as pd

path= './data-raw/Andreas Wenzel/Empirie_R_Sch_tzungen-2.csv'
df= pd.read_csv(path, delimiter= ',')

#Spalte data_version
df.rename(columns= {'Datenstand RKI': 'data_version'}, inplace=True)

#Spalte date
df.rename(columns= {'Erkrankungsbeginn 7d R (Shift -1d)': 'date'}, inplace=True)

#df.columns

#nicht benötigte Spalten entfernen
df.drop('Erkrankungsbeginn bei tgl. Sicht', axis=1, inplace=True)
df.drop('Fälle Erkrankungsbeginn_bekannt', axis=1, inplace=True)
df.drop('Fälle Erkrankungsbeginn_Mapping', axis=1, inplace=True)
df.drop('Fälle Nowcast', axis=1, inplace=True)
df.drop('Fälle Erkrankungsbeginn bekannt 7d gl.', axis=1, inplace=True)
df.drop('Fälle Erkrankungsbeginn Mapping 7d gl.', axis=1, inplace=True)
df.drop('Fälle Nowcast 7d gl.', axis=1, inplace=True)
df.drop('Fälle Nowcast 7d gl. (PI lower)', axis=1, inplace=True)
df.drop('Fälle Nowcast 7d gl. (PI upper)', axis=1, inplace=True)
df.drop('Fälle gesamt 7d gl.', axis=1, inplace=True)
df.drop('Fälle gesamt 7d gl. (PI lower)', axis=1, inplace=True)
df.drop('Fälle gesamt 7d gl. (PI upper)', axis=1, inplace=True)


#7 Tage R
seven_day_r = df.iloc[:,[0,1,2,3,4,]]

seven_day_r.insert(1, 'target', '7 day R', True)

seven_day_r_tr=seven_day_r.melt(id_vars= ["data_version","target","date"],
                value_vars= ['R(t) 7d', 
                             'R(t) 7d (PI lower)',
                             'R(t) 7d (PI upper)'], 
                value_name="value")

seven_day_r_tr.insert(3, 'quantile', '', True)
seven_day_r_tr.loc[seven_day_r_tr.variable=='R(t) 7d','quantile']='NA'
seven_day_r_tr.loc[seven_day_r_tr.variable=='R(t) 7d (PI lower)','quantile']='0.025'
seven_day_r_tr.loc[seven_day_r_tr.variable=='R(t) 7d (PI upper)','quantile']='0.975'

seven_day_r_tr.rename(columns= {'variable': 'type'}, inplace=True)
seven_day_r_tr['type'].replace({'R(t) 7d':'point'}, inplace=True)
seven_day_r_tr['type'].replace({'R(t) 7d (PI lower)':'quantile'}, inplace=True)
seven_day_r_tr['type'].replace({'R(t) 7d (PI upper)':'quantile'}, inplace=True)

seven_day_r_tr.insert(2, 'location', 'DE', True)

#seven_day_r_tr.to_csv('./data-processed/2021-06-23-AW_7day.csv', index=False)

groups = seven_day_r_tr.groupby(seven_day_r_tr.data_version)
unique_version = df["data_version"].unique()

#for i in unique_version:
 #   df = groups.get_group(i)
 #   df.to_csv('./data-processed/Andreas Wenzel/'+i+'-AW_7day.csv', index=False)

#Woche/Vorwoche R
wv_r= df.iloc[:,[0,1,5,6,7]]

wv_r.insert(1, 'target', 'WV R', True)

wv_r_tr=wv_r.melt(id_vars= ["data_version","target","date"],
                value_vars= ['Rt_WV', 
                             'R(t) WV (PI lower)',
                             'R(t) WV (PI upper)'], 
                value_name="value")

wv_r_tr.insert(3, 'quantile', '', True)
wv_r_tr.loc[wv_r_tr.variable=='Rt_WV','quantile']='NA'
wv_r_tr.loc[wv_r_tr.variable=='R(t) WV (PI lower)','quantile']='0.025'
wv_r_tr.loc[wv_r_tr.variable=='R(t) WV (PI upper)','quantile']='0.975'

wv_r_tr.rename(columns= {'variable': 'type'}, inplace=True)
wv_r_tr['type'].replace({'Rt_WV':'point'}, inplace=True)
wv_r_tr['type'].replace({'R(t) WV (PI lower)':'quantile'}, inplace=True)
wv_r_tr['type'].replace({'R(t) WV (PI upper)':'quantile'}, inplace=True)

wv_r_tr.insert(2, 'location', 'DE', True)

#wv_r_tr.to_csv('./data-processed/2021-06-23-AW_WVday.csv', index=False)
groups2 = wv_r_tr.groupby(wv_r_tr.data_version)
unique_version2 = wv_r_tr["data_version"].unique()

for i in unique_version2:
    df = groups2.get_group(i)
    df.to_csv('./data-processed/Andreas Wenzel/'+i+'-AW_WVday.csv', index=False)