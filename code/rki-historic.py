import pandas as pd
import os
from tqdm import tqdm

path = "../data-raw/rki-historic/"
files = os.listdir(path)

for file in tqdm(files):
    data = pd.read_csv(path + file)
    output_7_day_r = pd.DataFrame()
    output_4_day_r = pd.DataFrame()

    for i in range(0, len(data)):
        output_7_day_r = output_7_day_r.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["7 day R", "7 day R", "7 day R"], 'date': [data['Datum'][i], data['Datum'][i], data['Datum'][i]], 'location': ["DE", "DE", "DE"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [data['PS_7_Tage_R_Wert'][i], data['UG_PI_7_Tage_R_Wert'][i], data['OG_PI_7_Tage_R_Wert'][i]]}))
    output_7_day_r.to_csv("../data-processed/RKI_7day/" + file[0:10] + "-RKI_7day.csv", index_label=False, index=False)

    # 4-day-R since 2021-07-17 no longer repoorted
    try:
        for i in range(0, len(data)):
            output_4_day_r = output_4_day_r.append(pd.DataFrame({'data_version': [file[0:10], file[0:10], file[0:10]], 'target': ["4 day R", "4 day R", "4 day R"], 'date': [data['Datum'][i], data['Datum'][i], data['Datum'][i]], 'location': ["DE", "DE", "DE"], 'type': ["point", "quantile", "quantile"], 'quantile': ["NA", "0.025", "0.975"], 'value': [data['PS_4_Tage_R_Wert'][i], data['UG_PI_4_Tage_R_Wert'][i], data['OG_PI_4_Tage_R_Wert'][i]]}))
        output_4_day_r.to_csv("../data-processed/RKI_4day/" + file[0:10] + "-RKI_4day.csv", index_label=False, index=False)
    except:
        pass

    