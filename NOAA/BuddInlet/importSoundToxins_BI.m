%% import SoundToxins BuddInlet data
clear;
filename="/Users/afischer/Documents/NOAA_research/BuddInlet/Data/PSI_BuddData_2013-2021.xlsx";

opts = spreadsheetImportOptions("NumVariables", 20);
opts.Sheet = "PSI Data";
opts.DataRange = "A2:T198";
opts.VariableNames = ["Date", "Location", "TempS", "Temp15m", "Temp3m", "SalS", "Sal15m", "Sal3m", "DOS", "DO15m", "DO3m", "pHS", "pH15m", "pH3m", "Secchi", "DinocellsL", "Acum", "Fortii", "Norvegica", "Other"];
opts.VariableTypes = ["datetime", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "Location", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Date", "InputFormat", "");
S = readtable(filename, opts, "UseExcel", false);

save('~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/SoundToxins_DSP_BI','S');
