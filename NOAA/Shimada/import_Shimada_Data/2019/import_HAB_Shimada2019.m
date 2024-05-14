%% Import 2019 Shimada HAB samples
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

%%% Nutrients
opts = spreadsheetImportOptions("NumVariables", 10);
opts.Sheet = "edited";
opts.DataRange = "A2:J337";
opts.VariableNames = ["GMTdate_forDB", "GMTTime", "StationID", "Var4", "Var5", "Lat_dd", "Lon_dd", "NitrateM", "PhosphateM", "SilicateM"];
opts.SelectedVariableNames = ["GMTdate_forDB", "GMTTime", "StationID", "Lat_dd", "Lon_dd", "NitrateM", "PhosphateM", "SilicateM"];
opts.VariableTypes = ["datetime", "double", "double", "char", "char", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var4", "Var5"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var4", "Var5"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "GMTdate_forDB", "InputFormat", "");
N = readtable("/Users/alexis.fischer/Documents/Shimada2019/HAKE2019_Nuts.xlsx", opts, "UseExcel", false);

N.GMTdate_forDB=datetime(datenum(N.GMTdate_forDB)+N.GMTTime,'ConvertFrom','datenum');
N.NitrateM(N.NitrateM==-9999)=NaN;
N.PhosphateM(N.PhosphateM==-9999)=NaN;
N.SilicateM(N.SilicateM==-9999)=NaN;
clear opts

%% Other discrete samples
opts = spreadsheetImportOptions("NumVariables", 25);
opts.Sheet = "2019_SummerHake_Shimada";
opts.DataRange = "A2:Y340";
opts.VariableNames = ["Var1", "Var2", "GMTdate_forDB", "GMTTime", "StationID", "Var6", "Var7", "StationDepthm", "WaterTempC", "S", "SamplingDepthm", "Fluorometer", "PseudonitzschiaSpprelativeAbundance", "AlexandriumSpprelativeAbundance", "DinophysisSpprelativeAbundance", "Var16", "Var17", "Lat_dd", "Lon_dd", "Var20", "Total_PNcellsL", "LargeCellsInCount", "pDAngL", "Chl_agL", "SEMSpeciesInfo"];
opts.SelectedVariableNames = ["GMTdate_forDB", "GMTTime", "StationID", "StationDepthm", "WaterTempC", "S", "SamplingDepthm", "Fluorometer", "PseudonitzschiaSpprelativeAbundance", "AlexandriumSpprelativeAbundance", "DinophysisSpprelativeAbundance", "Lat_dd", "Lon_dd", "Total_PNcellsL", "LargeCellsInCount", "pDAngL", "Chl_agL", "SEMSpeciesInfo"];
opts.VariableTypes = ["char", "char", "datetime", "double", "double", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "double", "double", "char", "double", "double", "double", "double", "char"];
opts = setvaropts(opts, ["Var1", "Var2", "Var6", "Var7", "Var16", "Var17", "Var20", "SEMSpeciesInfo"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var6", "Var7", "Var16", "Var17", "Var20", "SEMSpeciesInfo"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "GMTdate_forDB", "InputFormat", "");
HA19 = readtable("/Users/alexis.fischer/Documents/Shimada2019/50_SH_2019_SummerHake_DataLog_corrected.xlsx", opts, "UseExcel", false);

HA19.GMTdate_forDB=datetime(datenum(HA19.GMTdate_forDB)+HA19.GMTTime,'ConvertFrom','datenum');
HA19 = renamevars(HA19,'GMTdate_forDB','dt');
HA19 = removevars(HA19,'GMTTime');
clear opts

HA19.Total_PNcellsL(HA19.Total_PNcellsL==-9999)=NaN;
HA19.LargeCellsInCount(HA19.LargeCellsInCount==-9999)=NaN;
HA19.pDAngL(HA19.pDAngL==-9999)=NaN;
HA19.pDAngL(HA19.pDAngL<0)=0;
HA19.Chl_agL(HA19.Chl_agL==-9999)=NaN;

%% merge data
[~,ia,ib]=intersect(HA19.StationID,N.StationID);
HA19.NitrateM=NaN*HA19.StationID;
HA19.PhosphateM=HA19.NitrateM;
HA19.SilicateM=HA19.NitrateM;

HA19.NitrateM(ia)=N.NitrateM(ib);
HA19.PhosphateM(ia)=N.PhosphateM(ib);
HA19.SilicateM(ia)=N.SilicateM(ib);

%% Import and Add SEM species data
opts = spreadsheetImportOptions("NumVariables", 36);
opts.Sheet = "2019 Shimada PHATS HAB data";
opts.DataRange = "A2:AJ15";
opts.VariableNames = ["Var1", "Var2", "Var3", "StationID", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29", "SEMDelicatissima", "SEMPseudodelicatissima", "SEMHeimii", "SEMPungens", "SEMMultiseries", "SEMFraudulenta", "SEMAustralis"];
opts.SelectedVariableNames = ["StationID", "SEMDelicatissima", "SEMPseudodelicatissima", "SEMHeimii", "SEMPungens", "SEMMultiseries", "SEMFraudulenta", "SEMAustralis"];
opts.VariableTypes = ["char", "char", "char", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "Var25", "Var26", "Var27", "Var28", "Var29"], "EmptyFieldRule", "auto");
T = readtable("/Users/alexis.fischer/Documents/Shimada2019/HAB_SEM_Shimada2019.xlsx", opts, "UseExcel", false);

clear opts

[c,ia,ib]=intersect(HA19.StationID,T.StationID);

HA19.fx_deli=NaN*ones(size(HA19.SilicateM));
HA19.fx_pseu=HA19.fx_deli;
HA19.fx_heim=HA19.fx_deli;
HA19.fx_pung=HA19.fx_deli;
HA19.fx_mult=HA19.fx_deli;
HA19.fx_frau=HA19.fx_deli;
HA19.fx_aust=HA19.fx_deli;

HA19.fx_deli(ia)=T.SEMDelicatissima(ib);
HA19.fx_pseu(ia)=T.SEMPseudodelicatissima(ib);
HA19.fx_heim(ia)=T.SEMHeimii(ib);
HA19.fx_pung(ia)=T.SEMPungens(ib);
HA19.fx_mult(ia)=T.SEMMultiseries(ib);
HA19.fx_frau(ia)=T.SEMFraudulenta(ib);
HA19.fx_aust(ia)=T.SEMAustralis(ib);

%% sanity check plot
%figure; plot(N.GMTdate_forDB,N.SilicateM,'^',HA19.dt,HA19.SilicateM,'o')
%%
save('~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/Data/Shimada_HAB_2019','HA19');