%% import temperature lat lon and timestamps from 2021 Shimada cruise GPS data
% process these data like a .csv file
% Alexis D. Fischer, NWFSC, May 2022
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; %USER
indir= '~/Documents/Seawater System - TSG/'; %USER
outpath=[filepath 'NOAA/Shimada/Data/']; %USER

addpath(genpath(outpath)); 
addpath(genpath([filepath 'Misc-Functions/'])); 
Tdir=dir([indir '*_TSG21-SBE38-Temp-F-Message.RAW.log']);

dt=[];
temp=[];

for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);
    date=datetime(name(1:8),'InputFormat','yyyyMMdd');
    
    if date < datetime(2021,09,03)
        opts = delimitedTextImportOptions("NumVariables", 5, "Encoding", "UTF-8");
        opts.DataLines = [2, Inf];
        opts.Delimiter = [",", "Z"];
        opts.VariableNames = ["ACQTimestampServerTimeInUTC", "Var2", "Var3", "Var4", "VarName5"];
        opts.SelectedVariableNames = ["ACQTimestampServerTimeInUTC", "VarName5"];
        opts.VariableTypes = ["datetime", "char", "char", "char", "double"];
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule = "read";
        opts.ConsecutiveDelimitersRule = "join";
        opts = setvaropts(opts, ["Var2", "Var3", "Var4"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Var2", "Var3", "Var4"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, "ACQTimestampServerTimeInUTC", "InputFormat", "yyyy-MM-dd HH:mm:ss");
        tbl = readtable(filename, opts);
        
        dti = tbl.ACQTimestampServerTimeInUTC;
        tempi = tbl.VarName5;

    else
        opts = delimitedTextImportOptions("NumVariables", 6, "Encoding", "UTF-8");
        opts.DataLines = [2, Inf];
        opts.Delimiter = [",", "Z"];
        opts.VariableNames = ["ACQTimestampServerTimeInUTC", "Var2", "Var3", "Var4", "Var5", "VarName6"];
        opts.SelectedVariableNames = ["ACQTimestampServerTimeInUTC", "VarName6"];
        opts.VariableTypes = ["datetime", "char", "char", "char", "char", "double"];
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule = "read";
        opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, "ACQTimestampServerTimeInUTC", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss.SSS");
        tbl = readtable(filename, opts);
        
        dti = tbl.ACQTimestampServerTimeInUTC;
        tempi = tbl.VarName6;
    end

    dti.Format='yyyy-MM-dd HH:mm:ss';        
    dt=[dt;dti];
    temp=[temp;tempi];
    clearvars opts tbl dti tempi

end

idx=isnan(temp);
temp(idx)=[];
dt(idx)=[];

dt = dateshift(dt,'start','second');

%% remove outliers
idx=isoutlier(temp,'percentiles',[1 99]);
%figure; plot(dt(~idx),temp(~idx));
dt(idx)=[]; temp(idx)=[];
figure; plot(dt,temp);

%%
save([outpath 'temperature_Shimada2021'],'dt','temp');
