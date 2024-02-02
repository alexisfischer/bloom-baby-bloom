%% Import DSP data from all of Puget Sound
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

opts = spreadsheetImportOptions("NumVariables", 27);
opts.Sheet = "DSP";
opts.DataRange = "A2:AA25841";
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "SiteName", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "DSPTissue", "DSPResult", "DSPDate"];
opts.SelectedVariableNames = ["SiteName", "DSPTissue", "DSPResult", "DSPDate"];
opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "char", "char", "categorical", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "categorical", "double", "datetime"];
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "SiteName", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "DSPTissue"], "EmptyFieldRule", "auto");
D = readtable("/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/DSP_2012_2023.xlsx", opts, "UseExcel", false);
clear opts

D(isnan(D.DSPResult),:)=[]; %remove nans
D=table2timetable(D);