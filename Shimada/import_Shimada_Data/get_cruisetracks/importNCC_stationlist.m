%% Import NCC and Newport line corrdinates
opts = spreadsheetImportOptions("NumVariables", 5);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:E75";
opts.VariableNames = ["Transect", "Station", "Depthm", "Lat", "Lon"];
opts.VariableTypes = ["categorical", "categorical", "double", "double", "double"];
opts = setvaropts(opts, ["Transect", "Station"], "EmptyFieldRule", "auto");
N = readtable("/Users/alexis.fischer/Documents/NCC_StationPositions_w_Grays_LaPush.xlsx", opts, "UseExcel", false);
clear opts

save('~/Documents/MATLAB/bloom-baby-bloom/Shimada/Data/NCC_stationlist','N');
