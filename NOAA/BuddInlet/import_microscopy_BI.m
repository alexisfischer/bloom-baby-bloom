%% import google spreadsheet data from Brian
clear
filename="/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/OYC Phyto-Enviro-Sample Data.xlsx";
opts = spreadsheetImportOptions("NumVariables", 30);
opts.Sheet = "BuddInlet";
opts.DataRange = "A2:AD52";
opts.VariableNames = ["SampleDate", "Var2", "Var3", "LocationDepthm", "IFCBSampleDepthm", "ChlMaxLower1", "ChlMaxUpper1", "ChlMaxLower2", "ChlMaxUpper2", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "SampleDepths", "DinophysisConcentrationcellsL", "Var19", "Var20", "RAWDinophysisCount", "VolumeOfConcentrateCountedmL", "ColumsOfSRCounted", "Var24", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva"];
opts.SelectedVariableNames = ["SampleDate", "LocationDepthm", "IFCBSampleDepthm", "ChlMaxLower1", "ChlMaxUpper1", "ChlMaxLower2", "ChlMaxUpper2", "SampleDepths", "DinophysisConcentrationcellsL", "RAWDinophysisCount", "VolumeOfConcentrateCountedmL", "ColumsOfSRCounted", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva"];
opts.VariableTypes = ["datetime", "char", "char", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "double", "double", "char", "char", "double", "double", "categorical", "char", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var2", "Var3", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var19", "Var20", "Var24"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var19", "Var20", "ColumsOfSRCounted", "Var24"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "SampleDate", "InputFormat", "");
T = readtable(filename, opts, "UseExcel", false);
clearvars opts

T(2,:)=[]; %remove duplicate data point on 12 April


save('/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/DinophysisMicroscopy','T');