import pandas as pd 
import os
from pathlib import Path

path = "./data-processed/epiforecasts/"
epiforecasts= os.listdir(path)
print(epiforecasts)

for file in epiforecasts:
    help= file.split('_',2)
    print(help)
    os.rename(file,help[0]+'_'+help[1]+'s'+'.csv')
