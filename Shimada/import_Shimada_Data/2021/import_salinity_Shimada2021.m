%% import salinity and timestamps from 2021 Shimada cruise data
% process these data like a .csv file
% Alexis D. Fischer, NWFSC, May 2022
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; %USER
indir= '~/Documents/Shimada2021/Seawater System - TSG/'; %USER
outpath=[filepath 'Shimada/Data/']; %USER

addpath(genpath(outpath)); 
addpath(genpath([filepath 'Misc-Functions/'])); 
Tdir=dir([indir '*_TSG-4554924-0289-Message.RAW.log']);

dt=[];
sal=[];
for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);
    date=datetime(name(1:8),'InputFormat','yyyyMMdd');

    if date < datetime(2021,09,03)
        opts = delimitedTextImportOptions("NumVariables", 12, "Encoding", "UTF-8");
        opts.DataLines = [2, Inf];
        opts.Delimiter = [" ", ",", "Z"];
        opts.VariableNames = ["ACQ", "Timestamp", "Var3", "Var4", "in", "Var6", "Var7", "Var8", "Value", "Var10", "Var11", "Var12"];
        opts.SelectedVariableNames = ["ACQ", "Timestamp", "in", "Value"];
        opts.VariableTypes = ["datetime", "datetime", "char", "char", "double", "char", "char", "char", "double", "char", "char", "char"];
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule = "read";
        opts.ConsecutiveDelimitersRule = "join";
        opts = setvaropts(opts, ["Var3", "Var4", "Var6", "Var7", "Var8", "Var10", "Var11", "Var12"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Var3", "Var4", "Var6", "Var7", "Var8", "Var10", "Var11", "Var12"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, "ACQ", "InputFormat", "yyyy-MM-dd");
        opts = setvaropts(opts, "Timestamp", "InputFormat", "HH:mm:ss");
        opts = setvaropts(opts, ["in", "Value"], "ThousandsSeparator", ",");
        tbl = readtable(filename, opts);   
    
        d = tbl.ACQ; d.Format='yyyy-MM-dd HH:mm:ss';        
        h = tbl.Timestamp; dur=duration(string(h),'InputFormat','hh:mm:ss');
        dti=d+dur; 
        sali = tbl.Value;

    else
        opts = delimitedTextImportOptions("NumVariables", 11, "Encoding", "UTF-8");
        opts.DataLines = [2, Inf];
        opts.Delimiter = [" ", ",", "Z"];
        opts.VariableNames = ["ACQ", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Data", "Var9", "Var10", "Var11"];
        opts.SelectedVariableNames = ["ACQ", "Data"];
        opts.VariableTypes = ["datetime", "char", "char", "char", "char", "char", "char", "double", "char", "char", "char"];
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule = "read";
        opts.ConsecutiveDelimitersRule = "join";
        opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var9", "Var10", "Var11"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var9", "Var10", "Var11"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, "ACQ", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss.SSS");
        opts = setvaropts(opts, "Data", "ThousandsSeparator", ",");
        tbl = readtable(filename, opts);
        dti = tbl.ACQ;
        sali = tbl.Data;

    end
    dti.Format='yyyy-MM-dd HH:mm:ss';           
    dt=[dt;dti];
    sal=[sal;sali];
    clearvars opts tbl dti sali h dur d

end

%%
dt = dateshift(dt,'start','second');

idx=isnan(sal);
sal(idx)=[];
dt(idx)=[];

% remove outliers
idx=isoutlier(sal,'percentiles',[1 99]);
%figure; plot(dt(~idx),sal(~idx));
dt(idx)=[]; sal(idx)=[];
figure; plot(dt,sal);

save([outpath 'salinity_Shimada2021'],'dt','sal');