%% import google spreadsheet data from Brian
clear
filename="/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/OYC Phyto-Enviro-Sample Data.xlsx";
opts = spreadsheetImportOptions("NumVariables", 25);
opts.Sheet = "BuddInlet";
opts.DataRange = "A2:Y52";
opts.VariableNames = ["SampleDate", "Var2", "Var3", "LocationDepthm", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "SampleDepths", "DinophysisConcentrationcellsL", "OriginalVolumeConcentratedmL", "ConcentratedVolumemL", "RAWDinophysisCount", "VolumeOfConcentrateCountedmL", "Var18", "Var19", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva"];
opts.SelectedVariableNames = ["SampleDate", "LocationDepthm", "SampleDepths", "DinophysisConcentrationcellsL", "OriginalVolumeConcentratedmL", "ConcentratedVolumemL", "RAWDinophysisCount", "VolumeOfConcentrateCountedmL", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva"];
opts.VariableTypes = ["datetime", "char", "char", "double", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "char", "char", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var2", "Var3", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var18", "Var19"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var18", "Var19"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "SampleDate", "InputFormat", "");
T = readtable(filename, opts, "UseExcel", false);
clearvars opts

T(2,:)=[]; %remove duplicate data point on 12 April

save('/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/DinophysisMicroscopy','T');