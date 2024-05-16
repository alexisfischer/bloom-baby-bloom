%% import pco2, temp, sal, lat, lon, and timestamps from 2021 WCOA cruises
%https://www.ncei.noaa.gov/data/oceans/ncei/ocads/data/0228760/
% Alexis D. Fischer, NWFSC, May 2022
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; %USER
indir= '~/Documents/pCO2_WCOA21/'; %USER
outpath=[filepath 'Shimada/Data/']; %USER

addpath(genpath(outpath)); 
addpath(genpath([filepath 'Misc-Functions/'])); 
Tdir=dir([indir '*csv']);

dt=[]; lat=[]; lon=[]; temp=[]; sal=[]; pco2=[];
for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);

    opts = delimitedTextImportOptions("NumVariables", 19);
    opts.DataLines = [6, Inf];
    opts.Delimiter = ",";
    opts.VariableNames = ["Var1", "Var2", "DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "SST_C", "SAL_permil", "fCO2_SWSST_uatm", "Var16", "Var17", "Var18", "Var19"];
    opts.SelectedVariableNames = ["DATE_UTC__ddmmyyyy", "TIME_UTC_hhmmss", "LAT_dec_degree", "LONG_dec_degree", "SST_C", "SAL_permil", "fCO2_SWSST_uatm"];
    opts.VariableTypes = ["char", "char", "datetime", "datetime", "double", "double", "char", "char", "char", "char", "char", "char", "double", "double", "double", "char", "char", "char", "char"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, ["Var1", "Var2", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var16", "Var17", "Var18", "Var19"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var1", "Var2", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var16", "Var17", "Var18", "Var19"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "DATE_UTC__ddmmyyyy", "InputFormat", "ddMMyyyy");
    opts = setvaropts(opts, "TIME_UTC_hhmmss", "InputFormat", "HH:mm:ss");

    tbl = readtable(filename, opts);
    
    d = tbl.DATE_UTC__ddmmyyyy; d.Format='yyyy-MM-dd HH:mm:ss';  
    h = tbl.TIME_UTC_hhmmss; dur=duration(string(h),'InputFormat','hh:mm:ss');
    dti=d+dur; dti.Format='yyyy-MM-dd HH:mm:ss';

    lati = tbl.LAT_dec_degree;
    loni = tbl.LONG_dec_degree;
    tempi = tbl.SST_C;
    sali = tbl.SAL_permil;
    pco2i = tbl.fCO2_SWSST_uatm;

    dt=[dt;dti];
    lat=[lat;lati];
    lon=[lon;loni];
    temp=[temp;tempi];
    sal=[sal;sali];    
    pco2=[pco2;pco2i];

    clearvars opts tbl dti sali tempi pco2i lati loni h dur d  filename name
end

dt = dateshift(dt,'start','second');

%% remove outliers
idx=(temp==-999);
dt(idx)=[];
lat(idx)=[];
lon(idx)=[];
temp(idx)=[];
sal(idx)=[];
pco2(idx)=[];

%figure; plot(dt,sal);

save([outpath 'pCO2_WCOA2021'],'dt','lat','lon','temp','sal','pco2');
