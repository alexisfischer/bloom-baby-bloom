%% import processed pCO2 data from 2021 Shimada
clear
filepath= '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/Data/'; 
addpath(genpath(filepath)); 

% Leg 1
opts = delimitedTextImportOptions("NumVariables", 21);
opts.DataLines = [6, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "SST_C", "SAL_permil", "fCO2_SWSST_uatm", "Var18", "Var19", "Var20", "Var21"];
opts.SelectedVariableNames = ["DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "SST_C", "SAL_permil", "fCO2_SWSST_uatm"];
opts.VariableTypes = ["char", "char", "char", "char", "datetime", "datetime", "double", "double", "char", "char", "char", "char", "char", "char", "double", "double", "double", "char", "char", "char", "char"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DATE_UTC__ddmmyyyy", "InputFormat", "ddMMyyyy");
opts = setvaropts(opts, "TIME_UTC_hhmmss", "InputFormat", "HH:mm:ss");
L1 = readtable("/Users/alexis.fischer/Documents/Shimada2021/pCO2_2021_processed/Hake21_cruise1/Hake2022_cruise1_Final.csv", opts);
clear opts

% Leg 2
opts = delimitedTextImportOptions("NumVariables", 21);
opts.DataLines = [6, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "SST_C", "SAL_permil", "fCO2_SWSST_uatm", "Var18", "Var19", "Var20", "Var21"];
opts.SelectedVariableNames = ["DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "SST_C", "SAL_permil", "fCO2_SWSST_uatm"];
opts.VariableTypes = ["char", "char", "char", "char", "datetime", "datetime", "double", "double", "char", "char", "char", "char", "char", "char", "double", "double", "double", "char", "char", "char", "char"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DATE_UTC__ddmmyyyy", "InputFormat", "ddMMyyyy");
opts = setvaropts(opts, "TIME_UTC_hhmmss", "InputFormat", "HH:mm:ss");
L2 = readtable("/Users/alexis.fischer/Documents/Shimada2021/pCO2_2021_processed/Hake21_cruise2/Hake2022_cruise2_Final.csv", opts);
clear opts

% Leg 3
opts = delimitedTextImportOptions("NumVariables", 21);
opts.DataLines = [6, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "SST_C", "SAL_permil", "fCO2_SWSST_uatm", "Var18", "Var19", "Var20", "Var21"];
opts.SelectedVariableNames = ["DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "SST_C", "SAL_permil", "fCO2_SWSST_uatm"];
opts.VariableTypes = ["char", "char", "char", "char", "datetime", "datetime", "double", "double", "char", "char", "char", "char", "char", "char", "double", "double", "double", "char", "char", "char", "char"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DATE_UTC__ddmmyyyy", "InputFormat", "ddMMyyyy");
opts = setvaropts(opts, "TIME_UTC_hhmmss", "InputFormat", "HH:mm:ss");
L3 = readtable("/Users/alexis.fischer/Documents/Shimada2021/pCO2_2021_processed/Hake21_cruise3/Hake2021_cruise3_Final.csv", opts);
clear opts

% date time format
dti=[L1.DATE_UTC__ddmmyyyy;L2.DATE_UTC__ddmmyyyy;L3.DATE_UTC__ddmmyyyy];
hi=[L1.TIME_UTC_hhmmss;L2.TIME_UTC_hhmmss;L3.TIME_UTC_hhmmss];
dti.Format='yyyy-MM-dd HH:mm:ss'; d=timeofday(hi);
dt=dti+d;

lat=[L1.LAT_dec_degree;L2.LAT_dec_degree;L3.LAT_dec_degree];
lon=[L1.LONG_dec_degree;L2.LONG_dec_degree;L3.LONG_dec_degree];
sst=[L1.SST_C;L2.SST_C;L3.SST_C];
sal=[L1.SAL_permil;L2.SAL_permil;L3.SAL_permil];
fco2=[L1.fCO2_SWSST_uatm;L2.fCO2_SWSST_uatm;L3.fCO2_SWSST_uatm];

save([filepath 'pCO2_Shimada2021'],'dt','lon','lat','sst','sal','fco2');
