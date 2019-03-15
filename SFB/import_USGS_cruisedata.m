function[phys]=import_USGS_cruisedata(filename)
% import USGS cruise data for 2013-2018

opts = spreadsheetImportOptions("NumVariables", 16);
opts.Sheet = "Sheet1";
opts.DataRange = "A3:P3285";
opts.VariableNames = ["Date", "IFCB", "StationNumber", "Distancefrom36", "CalculatedChlorophyll", "CalculatedOxygen", "OpticalBackscatter", "CalculatedSPM", "Salinity", "Temperature", "Nitrite", "NitrateNitrite", "Ammonium", "Phosphate", "Silicate", "MeasuredExtinctionCoefficient"];
opts.VariableTypes = ["datetime", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "double"];
opts = setvaropts(opts, [2, 15], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [2, 15], "EmptyFieldRule", "auto");
tbl = readtable("/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SFB/Data/sfb_raw_2013-present.xls", opts, "UseExcel", false);

%% Convert to output type
Date = tbl.Date;
IFCB = tbl.IFCB;
StationNumber = tbl.StationNumber;
Distancefrom36 = tbl.Distancefrom36;
CalculatedChlorophyll = tbl.CalculatedChlorophyll;
CalculatedOxygen = tbl.CalculatedOxygen;
OpticalBackscatter = tbl.OpticalBackscatter;
CalculatedSPM = tbl.CalculatedSPM;
Salinity = tbl.Salinity;
Temperature = tbl.Temperature;
Nitrite = tbl.Nitrite;
NitrateNitrite = tbl.NitrateNitrite;
Ammonium = tbl.Ammonium;
Phosphate = tbl.Phosphate;
Silicate = tbl.Silicate;
Light = tbl.MeasuredExtinctionCoefficient;

Date=datenum(Date);
[Latitude,Longitude] = match_st_lat_lon(StationNumber);

clear opts tbl
%%
for i=1:length(Date)
    phys(i).dn=Date(i);
    phys(i).filename=IFCB(i);
    phys(i).st=StationNumber(i);
    phys(i).lat=Latitude(i);
    phys(i).lon=Longitude(i);
    phys(i).d36=Distancefrom36(i);    
    phys(i).sal=Salinity(i);    
    phys(i).light=Light(i);
    phys(i).chl=CalculatedChlorophyll(i);
    phys(i).o2=CalculatedOxygen(i);    
    phys(i).temp=Temperature(i);
    phys(i).obs=OpticalBackscatter(i);
    phys(i).spm=CalculatedSPM(i);
    phys(i).ni=Nitrite(i);
    phys(i).nina=NitrateNitrite(i);
    phys(i).amm=Ammonium(i);
    phys(i).phos=Phosphate(i);
    phys(i).sil=Silicate(i);
end

save('C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\parameters','phys');

end