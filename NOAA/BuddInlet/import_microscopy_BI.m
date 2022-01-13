%plot dinophysis
clear
opts = spreadsheetImportOptions("NumVariables", 20);
opts.Sheet = "Data";
opts.DataRange = "A2:T28";
opts.VariableNames = ["SampleDate", "Var2", "Var3", "Var4", "ChlMaxDepthm", "Var6", "Var7", "Var8", "Var9", "DinophysisConcentrationcellsL", "Var11", "Var12", "Var13", "Var14", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva"];
opts.SelectedVariableNames = ["SampleDate", "ChlMaxDepthm", "DinophysisConcentrationcellsL", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva"];
opts.VariableTypes = ["datetime", "char", "char", "char", "categorical", "char", "char", "char", "char", "double", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13", "Var14"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var4", "ChlMaxDepthm", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13", "Var14"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "SampleDate", "InputFormat", "");
T = readtable("/Users/afischer/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/Phyto-Enviro Data.xlsx", opts, "UseExcel", false);
T(1:3,:)=[];

clearvars opts

save('/Users/afischer/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/DinophysisMicroscopy','T');