%% workflow for importing and synchronizing Shimada environmental sensor, IFCB, and discrete data
% inputs: raw data from multiple sources
% output: timetable of all data synced to IFCB timestamps
% 2019 and 2021 data

% Step 1: import lat lon coordinates and time from ship's GPS for each year
    import_latlontime_SciGPS2019 %output: lat_lon_time_Shimada2019
    import_latlontime_SciGPS2021 %output: lat_lon_time_Shimada2021

% Step 2: make IFCB summary file for all years  
    summarize_class_cells_biovol_size %output: summary_biovol_allTB

% Step 3: import temperature and salinity sensor data for each year
    import_temperature_salinity_Shimada2019 %output: temperature_salinity_Shimada2019
    import_temperature_Shimada2021 %output: temperature_Shimada2021
    import_salinity_Shimada2021 %output: salinity_Shimada2021

% Step 4: import fluorescence sensor data for each year
    import_fluorescence_Shimada2019 %output: fluorescence_Shimada2019
    import_fluorescence_Shimada2021 %output: fluorescence_Shimada2019

% Step 5: import raw pCO2 sensor data for each year (then give data to Simone Alin for processing)
    import_pCO2_raw_Shimada2019 %output: raw_pCO2_Shimada2019
    import_pCO2_raw_Shimada2021 %output: raw_pCO2_Shimada2021

% Step 6: import processed pCO2 sensor data for each year
    import_pCO2_Shimada2019 %output: pCO2_Shimada2019
    import_pCO2_Shimada2019 %output: pCO2_Shimada2021

% Step 7: merge all environmental sensor data    
    merge_environ_variables_Shimada %output: environ_Shimada2019 or environ_Shimada2021

% Step 8: import discrete data for each year
    import_HAB_Shimada2019 %output: Shimada_HAB_2019
    import_HAB_Shimada2021 %output: Shimada_HAB_2021

% Step 9: merge discrete data 
    merge_Shimada_HAB %output: HAB_merged_Shimada19-21

% Step 10: merge environmental sensor, IFCB, and discrete data
    summarize_all_Hake_data %output: summary_19-21Hake_cells & summary_19-21Hake_biovolume
