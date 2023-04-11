%% Import 2019 pCO2
clear
filepath='~/Documents/Shimada2019/2019_pco2data/';
outpath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/Data/';

addpath(outpath);
%addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
%addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

filedir = dir([filepath '*.csv']);

for i=1:length(filedir)
    disp(filedir(i).name);   
    
    opts = delimitedTextImportOptions("NumVariables", 21);
    opts.DataLines = [6, Inf];
    opts.Delimiter = ",";
    opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "SST_C", "SAL_PSU", "fCO2_SWSST_uatm", "Var18", "Var19", "Var20", "Var21"];
    opts.SelectedVariableNames = ["DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "SST_C", "SAL_PSU", "fCO2_SWSST_uatm"];
    opts.VariableTypes = ["string", "string", "string", "string", "datetime", "datetime", "double", "double", "string", "string", "string", "string", "string", "string", "double", "double", "double", "string", "string", "string", "string"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var18", "Var19", "Var20", "Var21"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "DATE_UTC__ddmmyyyy", "InputFormat", "ddMMyyyy");
    opts = setvaropts(opts, "TIME_UTC_hhmmss", "InputFormat", "HH:mm:ss");

    T = readtable([filepath filedir(i).name], opts); 
    T.DATE_UTC__ddmmyyyy.Format = 'dd-MMM-uuuu HH:mm:ss';
    T.TIME_UTC_hhmmss.Format = 'dd-MMM-uuuu HH:mm:ss';
    
    p(i).dt = T.DATE_UTC__ddmmyyyy + timeofday(T.TIME_UTC_hhmmss);
    p(i).lat=T.LAT_dec_degree;
    p(i).lon=T.LONG_dec_degree;
    p(i).sst=T.SST_C;
    p(i).sal=T.SAL_PSU;
    p(i).fco2=T.fCO2_SWSST_uatm;
  
end

% create merged table
dt=vertcat(p.dt);
lat=vertcat(p.lat); 
lon=vertcat(p.lon);
sst=vertcat(p.sst); sst(sst==-999)=NaN;
sal=vertcat(p.sal); sal(sal==-999)=NaN;
fco2=vertcat(p.fco2); fco2(fco2==-999)=NaN;

save([outpath 'pCO2_Shimada2019'],'dt','lat','lon','sst','sal','fco2');

%%

