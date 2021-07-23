import pandas as pd
import datetime 
import os

path = "./data-processed/RKI_7day/"
rki= os.listdir(path)
#rki.remove('.DS_Store')
rki.sort()

print(rki)

for file in rki:
    df_rki= pd.read_csv(path+'/'+file, delimiter=",")   

    #df_rki['value']=df_rki['value'].apply(lambda x: str(x).replace(',','.'))


    df_rki.to_csv(path+'/'+file, index=False)