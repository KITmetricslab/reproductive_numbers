import pandas as pd
import os, fnmatch
from os.path import exists


path = "../data-raw/ETHZ DEU"
files = fnmatch.filter(os.listdir(path), "*.csv") # filter to exclude LICENSE.txt

for file in files:
    input_cc = pd.read_csv("../data-raw/ETHZ DEU/" + file)
    input_deaths = input_cc[input_cc['data_type'] == 'Deaths']
    input_cc = input_cc[input_cc['data_type'] == 'Confirmed cases']

    df1 = input_cc[input_cc['estimate_type'] == 'Cori_slidingWindow']
    df2 = input_cc[input_cc['estimate_type'] == 'Cori_step']
    df3 = input_deaths[input_deaths['estimate_type'] == 'Cori_slidingWindow']
    df4 = input_deaths[input_deaths['estimate_type'] == 'Cori_step']

    output_dataframe1 = pd.DataFrame()
    output_dataframe2 = pd.DataFrame()
    output_dataframe3 = pd.DataFrame()
    output_dataframe4 = pd.DataFrame()

    for i in range(0, len(df1)):
        output_dataframe1 = output_dataframe1.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df1.iloc[i, 5], df1.iloc[i, 5], df1.iloc[i, 5]], 'location': ["DE", "DE", "DE"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df1.iloc[i, 6], df1.iloc[i, 8], df1.iloc[i, 7]]}))

    for i in range(0, len(df2)):
        output_dataframe2 = output_dataframe2.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df2.iloc[i, 5], df2.iloc[i, 5], df2.iloc[i, 5]], 'location': ["DE", "DE", "DE"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df2.iloc[i, 6], df2.iloc[i, 8], df2.iloc[i, 7]]}))

    for i in range(0, len(df3)):
        output_dataframe3 = output_dataframe3.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df3.iloc[i, 5], df3.iloc[i, 5], df3.iloc[i, 5]], 'location': ["DE", "DE", "DE"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df3.iloc[i, 6], df3.iloc[i, 8], df3.iloc[i, 7]]}))

    for i in range(0, len(df4)):
        output_dataframe4 = output_dataframe4.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df4.iloc[i, 5], df4.iloc[i, 5], df4.iloc[i, 5]], 'location': ["DE", "DE", "DE"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df4.iloc[i, 6], df4.iloc[i, 8], df4.iloc[i, 7]]}))

    # if corresponding file from Austria exists, append it:
    if exists("../data_raw/ETHZ AUT/" + file[0:10] + "_ethz_aut_raw.csv"):
        input_cc = pd.read_csv("../data-raw/ETHZ AUT/" + file)
        input_deaths = input_cc[input_cc['data_type'] == 'Deaths']
        input_cc = input_cc[input_cc['data_type'] == 'Confirmed cases']

        df1 = input_cc[input_cc['estimate_type'] == 'Cori_slidingWindow']
        df2 = input_cc[input_cc['estimate_type'] == 'Cori_step']
        df3 = input_deaths[input_deaths['estimate_type'] == 'Cori_slidingWindow']
        df4 = input_deaths[input_deaths['estimate_type'] == 'Cori_step']

        for i in range(0, len(df1)):
            output_dataframe1 = output_dataframe1.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df1.iloc[i, 5], df1.iloc[i, 5], df1.iloc[i, 5]], 'location': ["AT", "AT", "AT"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df1.iloc[i, 6], df1.iloc[i, 8], df1.iloc[i, 7]]}))

        for i in range(0, len(df2)):
            output_dataframe2 = output_dataframe2.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df2.iloc[i, 5], df2.iloc[i, 5], df2.iloc[i, 5]], 'location': ["AT", "AT", "AT"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df2.iloc[i, 6], df2.iloc[i, 8], df2.iloc[i, 7]]}))

        for i in range(0, len(df3)):
            output_dataframe3 = output_dataframe3.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df3.iloc[i, 5], df3.iloc[i, 5], df3.iloc[i, 5]], 'location': ["AT", "AT", "AT"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df3.iloc[i, 6], df3.iloc[i, 8], df3.iloc[i, 7]]}))

        for i in range(0, len(df4)):
            output_dataframe4 = output_dataframe4.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df4.iloc[i, 5], df4.iloc[i, 5], df4.iloc[i, 5]], 'location': ["AT", "AT", "AT"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df4.iloc[i, 6], df4.iloc[i, 8], df4.iloc[i, 7]]}))

    # if corresponding file from Switzerland exists, append it:
    if exists("../data_raw/ETHZ CHE/" + file[0:10] + "_ethz_che_raw.csv"):
        input_cc = pd.read_csv("../data-raw/ETHZ CHE/" + file)
        input_deaths = input_cc[input_cc['data_type'] == 'Deaths']
        input_cc = input_cc[input_cc['data_type'] == 'Confirmed cases']

        df1 = input_cc[input_cc['estimate_type'] == 'Cori_slidingWindow']
        df2 = input_cc[input_cc['estimate_type'] == 'Cori_step']
        df3 = input_deaths[input_deaths['estimate_type'] == 'Cori_slidingWindow']
        df4 = input_deaths[input_deaths['estimate_type'] == 'Cori_step']

        for i in range(0, len(df1)):
            output_dataframe1 = output_dataframe1.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df1.iloc[i, 5], df1.iloc[i, 5], df1.iloc[i, 5]], 'location': ["CH", "CH", "CH"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df1.iloc[i, 6], df1.iloc[i, 8], df1.iloc[i, 7]]}))

        for i in range(0, len(df2)):
            output_dataframe2 = output_dataframe2.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df2.iloc[i, 5], df2.iloc[i, 5], df2.iloc[i, 5]], 'location': ["CH", "CH", "CH"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df2.iloc[i, 6], df2.iloc[i, 8], df2.iloc[i, 7]]}))

        for i in range(0, len(df3)):
            output_dataframe3 = output_dataframe3.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df3.iloc[i, 5], df3.iloc[i, 5], df3.iloc[i, 5]], 'location': ["CH", "CH", "CH"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df3.iloc[i, 6], df3.iloc[i, 8], df3.iloc[i, 7]]}))

        for i in range(0, len(df4)):
            output_dataframe4 = output_dataframe4.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["3 day R", "3 day R", "3 day R"], 'date': [df4.iloc[i, 5], df4.iloc[i, 5], df4.iloc[i, 5]], 'location': ["CHT", "CH", "CH"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [df4.iloc[i, 6], df4.iloc[i, 8], df4.iloc[i, 7]]}))

    output_dataframe1.to_csv("../data-processed/ETHZ_sliding_window/" + file[0:10] + "-ETHZ_sliding_window.csv", index=False, index_label=False)
    output_dataframe2.to_csv("../data-processed/ETHZ_step/" + file[0:10] + "-ETHZ_step.csv", index=False, index_label=False)
    output_dataframe3.to_csv("../data-processed/ETHZ_sliding_window_deaths/" + file[0:10] + "-ETHZ_sliding_window_deaths.csv", index=False, index_label=False)
    output_dataframe4.to_csv("../data-processed/ETHZ_step_deaths/" + file[0:10] + "-ETHZ_step_deaths.csv", index=False, index_label=False)