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

filelistTB=L.headerfile;
latI=L.Lat_dd;
lonI=L.Lon_dd;

dtIFCB=cellfun(@(x) x(2:16),filelistTB,'UniformOutput',false);
dtI=datetime(cell2mat(dtIFCB),"InputFormat","yyyyMMdd'T'HHmmss");
dtI.Format='yyyy-MM-dd HH:mm:ss';

save('~/Documents/MATLAB/bloom-baby-bloom/Shimada/Data/IFCB_underway_Shimada2019','dtI','lonI','latI','filelistTB');
