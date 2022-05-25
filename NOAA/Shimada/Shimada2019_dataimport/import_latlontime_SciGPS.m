%% import lat lon and timestamps from 2019 Shimada cruise GPS data
% The ship records GPS data every second and writes it to a text file for each day. 
% process these data like a .csv file
% Alexis D. Fischer, NWFSC, May 2022

clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; %USER
indir= '~/Documents/Shimada2019/GPS_GPGGA/'; %USER
outpath=[filepath 'NOAA/Shimada/Data/']; %USER

addpath(genpath(outpath)); 
addpath(genpath([filepath 'Misc-Functions/'])); 
Tdir=dir([indir 'SciGPS-GPGGA_*']);

DT=[];
LAT=[];
LON=[];
for i=1:length(Tdir)
    name=Tdir(i).name;
    filename = [indir name];    
    disp(name);
  %  date=datetime(name(14:21),'InputFormat','yyyyMMdd');

    opts = delimitedTextImportOptions("NumVariables", 17);
    opts.DataLines = [1, Inf];
    opts.Delimiter = ",";
    opts.VariableNames = ["VarName1", "VarName2", "Var3", "Var4", "VarName5", "Var6", "VarName7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17"];
    opts.SelectedVariableNames = ["VarName1", "VarName2", "VarName5", "VarName7"];
    opts.VariableTypes = ["datetime", "datetime", "char", "char", "double", "char", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, ["Var3", "Var4", "Var6", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var3", "Var4", "Var6", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "VarName1", "InputFormat", "MM/dd/yyyy");
    opts = setvaropts(opts, "VarName2", "InputFormat", "HH:mm:ss.SSS");

    tbl = readtable(filename, opts);

    d = tbl.VarName1; d.Format='yyyy-MM-dd HH:mm:ss';      
    h = duration(string(tbl.VarName2));
    dti=d+h; 
    lati = tbl.VarName5;
    loni = tbl.VarName7;

    DT=[DT;dti];
    LAT=[LAT;lati];
    LON=[LON;loni];    

    clearvars opts tbl lati loni dti filename date name d h

end

DT = dateshift(DT, 'start', 'second');

%% find and remove outliers
idx=isoutlier(LON,'percentiles',[1 99]);
%figure; plot(DT(~idx),LON(~idx));
DT(idx)=[]; LON(idx)=[]; LAT(idx)=[];
figure; plot(DT,LAT);

%%
save([outpath 'lat_lon_time_Shimada2019'],'DT','LON','LAT');
