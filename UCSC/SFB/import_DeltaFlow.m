function[]=import_DeltaFlow(filepath,filename)
%% import DeltaFlow
% Example inputs
% filepath='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
% filename = '/Users/afischer/Documents/UCSC_research/SanFranciscoBay/Data/Dayflow1955-2019.csv';

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 27);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Date", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "OUT", "Var23", "Var24", "Var25", "Var26", "X2"];
opts.SelectedVariableNames = ["Date", "OUT", "X2"];
opts.VariableTypes = ["datetime", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "double"];
opts = setvaropts(opts, 1, "InputFormat", "yyyy-MM-dd");
opts = setvaropts(opts, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 26], "WhitespaceRule", "preserve");
opts = setvaropts(opts, 27, "TrimNonNumeric", true);
opts = setvaropts(opts, 27, "ThousandsSeparator", ",");
opts = setvaropts(opts, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 24, 25, 26], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

T = readtable(filename, opts);

%% select only 1990-present
id=find(T.Date>=datetime('01-Jan-1990'),1);
OUT=T.OUT(id:end);
X2=T.X2(id:end);
DN=datenum(T.Date(id:end));

clearvars opts T

save([filepath 'Data/NetDeltaFlow'],'DN','X2','OUT');