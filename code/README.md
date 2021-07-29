# Execute code in the following order, if not otherwise mentioned, run it in the "code"-folder:

## for ETHZ, OWID and TU Ilmenau:
### I. (You need more data than the latest file.)

    1. If you need more than the latest data, e.g. because no download scripts were run over the last few weeks, 
    run the "extract_file_history.ipynb" script first. In this script you need to set the correct name of the 
    repository you want to download from. You also need a GitHub token. The GitHub token must be stored in a "config.yml" file 
    in this repo. If set up correctly this will download .csv files from the specified repo into the specified folder in "data-raw".
    If you only want to download the latest data, e.g. because you run the scripts every day, you can skip the steps above. Continue with II.

    2. run the script to process the raw data, e.g. "process_historic_data_eth.r" for ETHZ, "process_historic_data_ilmenau.r" for TU Ilmenau 
    or "process_historic_data_owid.r" for OWID. For OWID make sure no data older than 2020-11-13 is in the data-raw folder before running, 
    because earlier no reproduction_rate was included in the data. However, the step above will also store older data in the folder.

### II. (You only want to retrieve the latest data, i.e. 1 single file.)

    1. Run one of the following scripts: "csv-Konvertierung_eth.r", "csv-Konvertierung_Ilmenau.r", "csv-Konvertierung-owid.r".
    
## for RKI:    
### I. (You need only the latest data file.)

    1. If you want to download the current file directly from the Rki site, use the following script: "csv-Konvertierung-RKI_urLink.py".

### II. (You want to retrieve a whole repository.)

    Attention: The columns often vary, which is why small adjustments to the column names in the code may be necessary
    1. If the data is available as a csv file, then use the following script: "csv-Konvertierung-RKI_csv.py"
    2. If the data is available as a xlsx file, then use the following script: "csv-Konvertierung-RKI_xlsx.py"

## for epiforecast:
    
    1. For old data formats use the following script: "csv-Konvertierung-epiforecasts.py"
    2. For new data formats use the following script: "csv-Konvertierung-epiforecasts-old_data.py"
    
