function[phys]=import_USGS_cruisedata(filename,out_dir)
% import USGS cruise data for 2013-present
%Example inputs
%filename="/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/sfb_raw_2013-present.xlsx";
%out_dir='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/';

opts = spreadsheetImportOptions("NumVariables", 16);
opts.Sheet = "new";
opts.DataRange = "A3:P3500";
opts.VariableNames = ["Date", "IFCB", "StationNumber", "Distancefrom36", "CalculatedChlorophyll", "ChlorophyllaaPHA", "CalculatedOxygen", "OpticalBackscatter", "CalculatedSPM", "MeasuredExtinctionCoefficient", "Salinity", "Temperature", "Nitrite", "NitrateNitrite", "Ammonium", "Phosphate"];
opts.SelectedVariableNames = ["Date", "IFCB", "StationNumber", "Distancefrom36", "CalculatedChlorophyll", "ChlorophyllaaPHA", "CalculatedOxygen", "OpticalBackscatter", "CalculatedSPM", "MeasuredExtinctionCoefficient", "Salinity", "Temperature", "Nitrite", "NitrateNitrite", "Ammonium", "Phosphate"];
opts.VariableTypes = ["datetime", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, 1, "InputFormat", "");
opts = setvaropts(opts, 2, "WhitespaceRule", "preserve");
opts = setvaropts(opts, 2, "EmptyFieldRule", "auto");
tbl = readtable(filename, opts, "UseExcel", false);

%% Convert to output type
Date = tbl.Date;
IFCB = tbl.IFCB;
StationNumber = tbl.StationNumber;
Distancefrom36 = tbl.Distancefrom36;
CalculatedChlorophyll = tbl.CalculatedChlorophyll;
ChlPHA = tbl.ChlorophyllaaPHA;
CalculatedOxygen = tbl.CalculatedOxygen;
OpticalBackscatter = tbl.OpticalBackscatter;
CalculatedSPM = tbl.CalculatedSPM;
Salinity = tbl.Salinity;
Temperature = tbl.Temperature;
Nitrite = tbl.Nitrite;
NitrateNitrite = tbl.NitrateNitrite;
Ammonium = tbl.Ammonium;
Phosphate = tbl.Phosphate;
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
    phys(i).chlpha=ChlPHA(i);
    phys(i).o2=CalculatedOxygen(i);    
    phys(i).temp=Temperature(i);
    phys(i).obs=OpticalBackscatter(i);
    phys(i).spm=CalculatedSPM(i);
    phys(i).ni=Nitrite(i);
    phys(i).nina=NitrateNitrite(i);
    phys(i).amm=Ammonium(i);
    phys(i).phos=Phosphate(i);
end

save([out_dir 'parameters'],'phys');

end