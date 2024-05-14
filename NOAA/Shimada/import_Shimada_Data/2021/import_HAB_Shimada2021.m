%% Import 2021 Shimada HAB samples
clear;
filepath='/Users/alexis.fischer/Documents/Shimada2021/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/'));
addpath(genpath(filepath));

opts = spreadsheetImportOptions("NumVariables", 5);
opts.Sheet = "Field sample log";
opts.DataRange = "A2:E93";
opts.VariableNames = ["DayGMT", "TimeGMT", "Latitude", "Longitude", "StationID"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double"];
opts = setvaropts(opts, "DayGMT", "InputFormat", "");
HA21 = readtable([filepath 'Shimada 2021 HAB Data.xlsx'], opts, "UseExcel", false);
HA21.StationID((isnan(HA21.StationID)))=999; %replace nan from 43A with 999

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
Tp = readtable([filepath 'Shimada 2021 HAB Data.xlsx'], opts, "UseExcel", false);
Tp.StationID((isnan(Tp.StationID)))=999; %replace nan from 43A with 999
clear opts

opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "Chl a Data";
opts.DataRange = "A2:H94";
opts.VariableNames = ["Var1", "StationID", "Var3", "Var4", "Var5", "Var6", "Var7", "FinalChlAgL"];
opts.SelectedVariableNames = ["StationID", "FinalChlAgL"];
opts.VariableTypes = ["char", "double", "char", "char", "char", "char", "char", "double"];
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6", "Var7"], "EmptyFieldRule", "auto");
Tc = readtable([filepath 'Shimada 2021 HAB Data.xlsx'], opts, "UseExcel", false);
Tc.StationID((isnan(Tc.StationID)))=999; %replace nan from 43A with 999
clear opts

opts = spreadsheetImportOptions("NumVariables", 7);
opts.Sheet = "Nutrient Data";
opts.DataRange = "A2:G94";
opts.VariableNames = ["StationID", "NO3AveConcM", "NO3StdDev", "PO4AveConcM", "PO4StdDev", "SiAveConcM", "SiStdDev"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];
Tn = readtable([filepath 'Shimada 2021 HAB Data.xlsx'], opts, "UseExcel", false);
Tn.StationID((isnan(Tn.StationID)))=999; %replace nan from 43A with 999
clear opts

%% match up station number with time
[~,ia,ib]=intersect(Tp.StationID,HA21.StationID);
val=Tp.pDAngL(ia); HA21.pDA_ngL(ib)=val;

[~,ia,ib]=intersect(Tc.StationID,HA21.StationID);
val=Tc.FinalChlAgL(ia); HA21.chlA_ugL(ib)=val;

[~,ia,ib]=intersect(Tn.StationID,HA21.StationID);
val=Tn.NO3AveConcM(ia); HA21.NO3AveConcM(ib)=val;
val=Tn.NO3StdDev(ia); HA21.NO3StdDev(ib)=val;
val=Tn.PO4AveConcM(ia); HA21.PO4AveConcM(ib)=val;
val=Tn.PO4StdDev(ia); HA21.PO4StdDev(ib)=val;
val=Tn.SiAveConcM(ia); HA21.SiAveConcM(ib)=val;
val=Tn.SiStdDev(ia); HA21.SiStdDev(ib)=val;

HA21.Longitude=-HA21.Longitude;

%% import SEM data
opts = spreadsheetImportOptions("NumVariables", 23);
opts.Sheet = "Shimada_2021_Hake";
opts.DataRange = "A2:W09";
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "StationID", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "SEMDelicatissima", "SEMPseudodelicatissima", "SEMHeimii", "SEMPungens", "SEMMultiseries", "SEMFraudulenta", "SEMAustralis"];
opts.SelectedVariableNames = ["StationID", "SEMDelicatissima", "SEMPseudodelicatissima", "SEMHeimii", "SEMPungens", "SEMMultiseries", "SEMFraudulenta", "SEMAustralis"];
opts.VariableTypes = ["char", "char", "char", "char", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16"], "EmptyFieldRule", "auto");
T = readtable("/Users/alexis.fischer/Documents/Shimada2021/HAB_SEM_Shimada2021.xlsx", opts, "UseExcel", false);

[~,ia,ib]=intersect(HA21.StationID,T.StationID);

HA21.fx_deli=NaN*ones(size(HA21.SiAveConcM));
HA21.fx_pseu=HA21.fx_deli;
HA21.fx_heim=HA21.fx_deli;
HA21.fx_pung=HA21.fx_deli;
HA21.fx_mult=HA21.fx_deli;
HA21.fx_frau=HA21.fx_deli;
HA21.fx_aust=HA21.fx_deli;

HA21.fx_deli(ia)=T.SEMDelicatissima(ib);
HA21.fx_pseu(ia)=T.SEMPseudodelicatissima(ib);
HA21.fx_heim(ia)=T.SEMHeimii(ib);
HA21.fx_pung(ia)=T.SEMPungens(ib);
HA21.fx_mult(ia)=T.SEMMultiseries(ib);
HA21.fx_frau(ia)=T.SEMFraudulenta(ib);
HA21.fx_aust(ia)=T.SEMAustralis(ib);

%%

save('~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/Data/Shimada_HAB_2021','HA21');