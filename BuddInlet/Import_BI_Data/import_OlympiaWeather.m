%% Import data from OLYMPIA AIRPORT, WA US
%https://www.ncdc.noaa.gov/cdo-web/datasets/GHCND/stations/GHCND:USW00024227/detail
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/Data/';

opts = delimitedTextImportOptions("NumVariables", 20);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "DATE", "AWND", "Var5", "PRCP", "Var7", "Var8", "TAVG", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20"];
opts.SelectedVariableNames = ["DATE", "AWND", "PRCP", "TAVG"];
opts.VariableTypes = ["char", "char", "datetime", "double", "char", "double", "char", "char", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Var5", "Var7", "Var8", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var5", "Var7", "Var8", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DATE", "InputFormat", "yyyy-MM-dd");
W = readtable("/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/BuddInlet/Data/OlmpiaAirport_precipitation.csv", opts);
clear opts

W.DATE=datetime(W.DATE,'Format','yyyy-MM-dd HH:mm:ss');
W=table2timetable(W);


save([filepath 'OlympiaWeather'],'W');