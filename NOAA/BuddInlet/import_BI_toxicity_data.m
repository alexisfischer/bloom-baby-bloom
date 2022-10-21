%% import Dinophysis mussel toxicity data
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/';
filename=[filepath 'BuddInlet_DSP_2022.xlsx'];

opts = spreadsheetImportOptions("NumVariables", 2);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:B8";
opts.VariableNames = ["date", "DSPug100g"];
opts.VariableTypes = ["datetime", "double"];
opts = setvaropts(opts, "date", "InputFormat", "");
DSP = readtable(filename, opts, "UseExcel", false);
clear opts

save([filepath 'BI_DSP'],'DSP');