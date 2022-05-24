%% Import 2019 Shimada HAB samples
clear;

opts = spreadsheetImportOptions("NumVariables", 35);
opts.Sheet = "2019_SummerHake_Shimada";
opts.DataRange = "A2:AI341";
opts.VariableNames = ["Var1", "Var2", "GMTdate_forDB", "GMTTime", "StationID", "Var6", "Var7", "StationDepthm", "WaterTempC", "S", "SamplingDepthm", "Fluorometer", "PseudonitzschiaSpprelativeAbundance", "AlexandriumSpprelativeAbundance", "DinophysisSpprelativeAbundance", "Var16", "Var17", "Lat_dd", "Lon_dd", "Var20", "Total_PNcellsL", "LargeCellsInCount", "pDAngL", "Chl_agL", "Paustralis", "Pmultiseries", "Pfraudulenta", "Pseriata", "Ppseudodelicatissima", "Pheimii", "Pcuspidata", "Ppungens", "NitrateM", "PhosphateM", "SilicateM"];
opts.SelectedVariableNames = ["GMTdate_forDB", "GMTTime", "StationID", "StationDepthm", "WaterTempC", "S", "SamplingDepthm", "Fluorometer", "PseudonitzschiaSpprelativeAbundance", "AlexandriumSpprelativeAbundance", "DinophysisSpprelativeAbundance", "Lat_dd", "Lon_dd", "Total_PNcellsL", "LargeCellsInCount", "pDAngL", "Chl_agL", "Paustralis", "Pmultiseries", "Pfraudulenta", "Pseriata", "Ppseudodelicatissima", "Pheimii", "Pcuspidata", "Ppungens", "NitrateM", "PhosphateM", "SilicateM"];
opts.VariableTypes = ["char", "char", "datetime", "double", "double", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "double", "double", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var1", "Var2", "Var6", "Var7", "Var16", "Var17", "Var20"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var6", "Var7", "Var16", "Var17", "Var20"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "GMTdate_forDB", "InputFormat", "");
HA19 = readtable("/Users/afischer/Documents/NOAA_research/Shimada/50_SH_2019_SummerHake_DataLog_ADF.xlsx", opts, "UseExcel", false);
clear opts

HA19.GMTdate_forDB=datetime(datenum(HA19.GMTdate_forDB)+HA19.GMTTime,'ConvertFrom','datenum');
HA19 = renamevars(HA19,'GMTdate_forDB','dt');
HA19 = removevars(HA19,'GMTTime');


save('~/MATLAB/NOAA/Shimada/Data/Shimada_HAB_2019','HA19');