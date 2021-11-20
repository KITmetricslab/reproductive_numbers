#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Aug 19 14:42:18 2021

@author: ElisabethBrockhaus
"""

import pandas as pd
import os
import re

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)
path = "../data-raw/rtlive"
epi = [f for f in os.listdir(path) if re.match(".*all.*.csv", f)]
epi.sort()

for file in epi:
    df = pd.read_csv(path + "/" + file)

    # rename date column
    df.rename({"Unnamed: 0": "date"}, axis=1, inplace=True)

    # extract date from file path
    datum = file.split("_")[1]

    # insert missing columns
    df.insert(loc=0, column="data_version", value=datum, allow_duplicates=True)
    df.insert(1, "target", value="? day R", allow_duplicates=True)
    df.insert(2, "location", value="DE", allow_duplicates=True)

    # reformat: all values in one column, additional column defining value type
    df_t = df.melt(
        id_vars=["data_version", "target", "date", "location"],
        value_vars=["2.5%", "25%", "median", "75%", "97.5%"],
        value_name="value",
    ).rename({"variable": "quantile"}, axis=1)

    # remove columns containing estimates for dates after data_version (probably forecasts)
    df_t = df_t.drop(df_t[df_t.data_version < df_t.date].index)

    # insert column with type of the value
    df_t.insert(loc=5, column="type", value="quantile", allow_duplicates=True)
    df_t.loc[df_t["quantile"] == "median", "type"] = "point"

    # quantile column to numeric
    df_t["quantile"] = df_t["quantile"].map(
        {"2.5%": 0.025, "25%": 0.25, "median": 0.5, "75%": 0.75, "97.5%": 0.975}
    )

    # Datei exportieren
    df_t.to_csv("../data-processed/rtlive/" + datum + "-rtlive.csv", index=False)
