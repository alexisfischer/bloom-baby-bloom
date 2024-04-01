%% import Budd Inlet nutrient data
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

opts = spreadsheetImportOptions("NumVariables", 10);
opts.Sheet = "NA_alexis";
opts.DataRange = "A4:J69";
opts.VariableNames = ["VarName1", "Var2", "Var3", "Var4", "uM", "VarName6", "Var7", "Var8", "uM1", "VarName10"];
opts.SelectedVariableNames = ["VarName1", "uM", "VarName6", "uM1", "VarName10"];
opts.VariableTypes = ["datetime", "char", "char", "char", "double", "double", "char", "char", "double", "double"];
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var7", "Var8"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var7", "Var8"], "EmptyFieldRule", "auto");
T1 = readtable([filepath 'Nutrients_BI.xlsx'], opts, "UseExcel", false);
clear opts
T1=renamevars(T1,{'VarName1' 'uM' 'VarName6' 'uM1' 'VarName10'},{'dt' 'NO3_avg' 'NO3_std' 'NH3_avg' 'NH3_std'});
T1=table2timetable(T1);

opts = spreadsheetImportOptions("NumVariables", 10);
opts.Sheet = "urea_alexis";
opts.DataRange = "A3:J128";
opts.VariableNames = ["Urea", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "VarName9", "VarName10"];
opts.SelectedVariableNames = ["Urea", "VarName9", "VarName10"];
opts.VariableTypes = ["datetime", "char", "char", "char", "char", "char", "char", "char", "double", "double"];
opts.ImportErrorRule = "omitrow";
opts.MissingRule = "omitrow";
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, ["VarName9", "VarName10"], "TreatAsMissing", '');
T2 = readtable([filepath 'Nutrients_BI.xlsx'], opts, "UseExcel", false);
clear opts
T2=renamevars(T2,{'Urea' 'VarName9' 'VarName10'},{'dt' 'Urea_avg' 'Urea_std'});
T2=table2timetable(T2);
N=synchronize(T1,T2);

save([filepath 'Data_nutrients_BI'],'N');