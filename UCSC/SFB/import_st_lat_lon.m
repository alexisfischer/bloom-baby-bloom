% assign lat lon coordinates to stations and distance from Angel Island
outdir='~/MATLAB/bloom-baby-bloom/SFB/';

opts = spreadsheetImportOptions("NumVariables", 7);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:G39";
opts.VariableNames = ["st", "d36", "d18", "Lat_deg", "Lat_min", "Lon_deg", "Lon_min"];
opts.SelectedVariableNames = ["st", "d36", "d18", "Lat_deg", "Lat_min", "Lon_deg", "Lon_min"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
T = readtable("/Users/afischer/Documents/UCSC_research/SanFranciscoBay/Data/st_lat_lon_coordinates.xlsx", opts, "UseExcel", false);

lat=dm2degrees([T.Lat_deg,T.Lat_min]);
lon=dm2degrees([T.Lon_deg,T.Lon_min]);
st=T.st;
d18=T.d18;
d36=T.d36;

clearvars opts T

save([outdir 'Data/st_lat_lon_d18'],'st','lat','lon','d18','d36');
