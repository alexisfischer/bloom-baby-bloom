%% Import precipitation data
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/Data/';
filename=[filepath '4083060.csv'];

opts = delimitedTextImportOptions("NumVariables", 4);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "DATE", "PRCP"];
opts.SelectedVariableNames = ["DATE", "PRCP"];
opts.VariableTypes = ["char", "char", "datetime", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DATE", "InputFormat", "yyyy-MM-dd");
opts = setvaropts(opts, "PRCP", "ThousandsSeparator", ",");

P = readtable(filename, opts);
P = renamevars(P,"DATE","dt");
clear opts

save([filepath 'BI_Precipitation'],'P');
