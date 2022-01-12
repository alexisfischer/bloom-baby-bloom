%% Import IFCB filename to Lat Lon coordinates for 2019
clear;
opts = spreadsheetImportOptions("NumVariables", 3);
opts.Sheet = "HAKE2019_IFCB_Lat_Lon";
opts.DataRange = "E2:G1612";
opts.VariableNames = ["headerfile", "Lat_dd", "Lon_dd"];
opts.VariableTypes = ["string", "double", "double"];
opts = setvaropts(opts, "headerfile", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "headerfile", "EmptyFieldRule", "auto");
L = readtable("/Users/afischer/Documents/NOAA_research/Shimada/HAKE2019_IFCB_Lat_Lon-FINAL.xlsx", opts, "UseExcel", false);

B = cellfun(@(x) x(1:end-4), cellstr(L.headerfile), 'un', 0);
L.headerfile=B;

save('~/MATLAB/NOAA/Shimada/Data/IFCB_Lat_Lon_coordinates_2019','L');
