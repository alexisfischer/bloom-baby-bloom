%% import Dinophysis microscopy excel spreadsheet data from Brian
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/';
filename=[filepath 'OYC Phyto-Enviro-Sample Data.xlsx'];

opts = spreadsheetImportOptions("NumVariables", 30);
opts.Sheet = "BuddInlet";
opts.DataRange = "A2:AD52";
opts.VariableNames = ["SampleDate", "SampleTime", "SampleLocation", "LocationDepthm", "IFCBSampleDepthm", "ChlMaxLower1", "ChlMaxUpper1", "ChlMaxLower2", "ChlMaxUpper2", "ChlMaxDepthm", "chlPeakIntensity", "chlScattered", "chlScatteredRangem", "Wind", "Wave", "Weather", "SampleDepths", "DinophysisConcentrationcellsL", "OriginalVolumeConcentratedmL", "ConcentratedVolumemL", "RAWDinophysisCount", "VolumeOfConcentrateCountedmL", "ColumsOfSRCounted", "MesodiniumcellsL", "DAcuminata", "DFortii", "DNorvegica", "DOdiosa", "DRotundata", "DParva"];
opts.VariableTypes = ["datetime", "double", "categorical", "double", "double", "double", "double", "double", "double", "double", "categorical", "categorical", "categorical", "categorical", "categorical", "categorical", "double", "double", "double", "double", "double", "double", "categorical", "categorical", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["SampleLocation", "chlPeakIntensity", "chlScattered", "chlScatteredRangem", "Wind", "Wave", "Weather", "ColumsOfSRCounted", "MesodiniumcellsL"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "SampleDate", "InputFormat", "");
T = readtable(filename, opts, "UseExcel", false);
clearvars opts

T(2,:)=[]; %remove duplicate data point on 12 April

save([filepath 'DinophysisMicroscopy'],'T');