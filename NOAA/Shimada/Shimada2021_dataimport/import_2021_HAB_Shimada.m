%% Import 2019 Shimada HAB samples
clear;
filename="/Users/alexis.fischer/Documents/Shimada2021/Shimada 2021 HAB Data.xlsx";

opts = spreadsheetImportOptions("NumVariables", 5);
opts.Sheet = "Field sample log";
opts.DataRange = "A2:E93";
opts.VariableNames = ["DayGMT", "TimeGMT", "Latitude", "Longitude", "StationID"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double"];
opts = setvaropts(opts, "DayGMT", "InputFormat", "");
HA21 = readtable(filename, opts, "UseExcel", false);

%add time
d = HA21.DayGMT; d.Format='yyyy-MM-dd HH:mm';
for i=1:length(d)
    val=sprintf('%04.0f',HA21.TimeGMT(i));
    h(i)=datetime(datenum(val,'HHMM'),'ConvertFrom','datenum');
end    
h=h'; h.Format='HH:mm';
dur=duration(string(h),'InputFormat','hh:mm');
dti=d+dur;
HA21 = removevars(HA21, 'TimeGMT');
HA21 = removevars(HA21, 'DayGMT');
HA21.dt=dti;
clear opts

opts = spreadsheetImportOptions("NumVariables", 7);
opts.Sheet = "ELISA DA Data";
opts.DataRange = "A2:G94";
opts.VariableNames = ["Var1", "StationID", "Var3", "Var4", "Var5", "Var6", "pDAngL"];
opts.SelectedVariableNames = ["StationID", "pDAngL"];
opts.VariableTypes = ["char", "double", "char", "char", "char", "char", "double"];
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6"], "EmptyFieldRule", "auto");
Tp = readtable(filename, opts, "UseExcel", false);
clear opts

opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Chl a Data";
opts.DataRange = "A2:H94";
opts.VariableNames = ["Var1", "StationID", "Var3", "Var4", "Var5", "Var6", "Var7", "FinalChlAgL"];
opts.SelectedVariableNames = ["StationID", "FinalChlAgL"];
opts.VariableTypes = ["char", "double", "char", "char", "char", "char", "char", "double"];
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6", "Var7"], "EmptyFieldRule", "auto");
Tc = readtable(filename, opts, "UseExcel", false);
clear opts

%% match up station number with time

[~,ia,ib]=intersect(Tp.StationID,HA21.StationID);
val=Tp.pDAngL(ia); HA21.pDA_ngL(ib)=val;

[~,ia,ib]=intersect(Tc.StationID,HA21.StationID);
val=Tc.FinalChlAgL(ia); HA21.chlA_ugL(ib)=val;


save('~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/Data/Shimada_HAB_2021','HA21');