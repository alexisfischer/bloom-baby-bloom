%% import google spreadsheet data from Brian
clear
filename="/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/OYC Phyto-Enviro-Sample Data.xlsx";

%% 2021 data
opts = spreadsheetImportOptions("NumVariables", 21);
opts.Sheet = "2021";
opts.DataRange = "A2:U28";
opts.VariableNames = ["SampleDate", "SampleTime", "Var3", "LocationDepthm", "Var5", "Var6", "Var7", "Var8", "SampleDepths", "DinophysisConcentrationcellsL", "OriginalVolumeConcentratedmL", "ConcentratedVolumemL", "RAWDinophysisCount", "VolumeCountedmL", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva", "SIEVETOXLFrozen20C"];
opts.SelectedVariableNames = ["SampleDate", "SampleTime", "LocationDepthm", "SampleDepths", "DinophysisConcentrationcellsL", "OriginalVolumeConcentratedmL", "ConcentratedVolumemL", "RAWDinophysisCount", "VolumeCountedmL", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva", "SIEVETOXLFrozen20C"];
opts.VariableTypes = ["datetime", "double", "char", "double", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "char"];
opts = setvaropts(opts, ["Var3", "Var5", "Var6", "Var7", "Var8", "SIEVETOXLFrozen20C"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var3", "Var5", "Var6", "Var7", "Var8", "SIEVETOXLFrozen20C"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "SampleDate", "InputFormat", "");
E21 = readtable(filename, opts, "UseExcel", false);
clearvars opts

%% 2022 data
opts = spreadsheetImportOptions("NumVariables", 26);
opts.Sheet = "2022";
opts.DataRange = "A2:Z24";
opts.VariableNames = ["SampleDate", "SampleTime", "Var3", "LocationDepthm", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "SampleDepths", "DinophysisConcentrationcellsL", "OriginalVolumeConcentratedmL", "ConcentratedVolumemL", "RAWDinophysisCount", "VolumeOfConcentrateCountedmL", "ColumsOfSRCounted", "MesodiniumcellsL", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva", "SIEVETOXLFrozen20C"];
opts.SelectedVariableNames = ["SampleDate", "SampleTime", "LocationDepthm", "SampleDepths", "DinophysisConcentrationcellsL", "OriginalVolumeConcentratedmL", "ConcentratedVolumemL", "RAWDinophysisCount", "VolumeOfConcentrateCountedmL", "ColumsOfSRCounted", "MesodiniumcellsL", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva", "SIEVETOXLFrozen20C"];
opts.VariableTypes = ["datetime", "double", "char", "double", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "categorical", "double", "double", "categorical", "categorical", "categorical", "categorical", "double"];
opts = setvaropts(opts, ["Var3", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var3", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "MesodiniumcellsL", "DNorvegica", "DOdiosa", "DRotundata", "DParva"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "SampleDate", "InputFormat", "");
E22 = readtable(filename, opts, "UseExcel", false);
clearvars opts

%% merge
T.SampleDate=[E21.SampleDate;E22.SampleDate];
T.SampleDate=[E21.SampleDate;E22.SampleDate];
T.DinophysisConcentrationcellsL=[E21.DinophysisConcentrationcellsL;E22.DinophysisConcentrationcellsL];

save('/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/DinophysisMicroscopy','T');