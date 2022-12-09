%% import Dinophysis mussel toxicity data
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/';
filename=[filepath 'Budd Inlet Biotoxins 2012_110822.xlsx'];

opts = spreadsheetImportOptions("NumVariables", 2);
opts.Sheet = "Biotoxin_Results - removed<";
opts.DataRange = "Z2:AA268";
opts.VariableNames = ["DSPResult", "DSPDate"];
opts.VariableTypes = ["double", "datetime"];
opts = setvaropts(opts, "DSPDate", "InputFormat", "");
DSP = readtable(filename, opts, "UseExcel", false);
clear opts

DSP = renamevars(DSP,'DSPDate','dt');
DSP = renamevars(DSP,'DSPResult','ug100g');
%%
save([filepath 'BI_DSP'],'DSP');