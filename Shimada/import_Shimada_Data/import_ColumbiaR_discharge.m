%% import USGS 14246900 COLUMBIA RIVER AT PORT WESTWARD, NEAR QUINCY, OR
% https://waterdata.usgs.gov/nwis/dv?referred_module=sw&site_no=14246900
% 1990-2022
% Discharge, cubic feet per second 
% Suspended sediment load, water, unfiltered, computed, the product of regression-computed suspended sediment concentration and streamflow, short tons per day 

clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

opts = delimitedTextImportOptions("NumVariables", 19);
opts.DataLines = [48, Inf];
opts.Delimiter = "\t";
opts.VariableNames = ["Var1", "Var2", "dt", "discharge", "Var5", "Var6", "Var7", "Var8", "Var9", "ssl", "Var11", "Var12", "Var13", "turbidity_mean", "Var15", "turbidity_min", "Var17", "turbidity_max", "Var19"];
opts.SelectedVariableNames = ["dt", "discharge", "ssl", "turbidity_mean", "turbidity_min", "turbidity_max"];
opts.VariableTypes = ["char", "char", "datetime", "double", "char", "char", "char", "char", "char", "double", "char", "char", "char", "double", "char", "double", "char", "double", "char"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Var5", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13", "Var15", "Var17", "Var19"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var5", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13", "Var15", "Var17", "Var19"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "dt", "InputFormat", "yyyy-MM-dd");
opts = setvaropts(opts, ["ssl", "turbidity_mean", "turbidity_min", "turbidity_max"], "TrimNonNumeric", true);
opts = setvaropts(opts, ["ssl", "turbidity_mean", "turbidity_min", "turbidity_max"], "ThousandsSeparator", ",");
CR = readtable("/Users/alexis.fischer/Documents/ColumbiaR_1990-2022.txt", opts);

save([filepath 'Shimada/Data/ColumbiaRiverDischarge'],'CR');
