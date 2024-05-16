%% import fluorometer and timestamps from 2021 Shimada cruise data
% process these data like a .csv file
% Alexis D. Fischer, NWFSC, May 2022
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; %USER
indir= '~/Documents/Shimada2021/Seawater System - Fluorometer/'; %USER
outpath=[filepath 'Shimada/Data/']; %USER

addpath(genpath(outpath)); 
addpath(genpath([filepath 'Misc-Functions/'])); 
Tdir=dir([indir '*_Fluorometer-6993RTD-Message.RAW.log']);

dt=[];
fl=[];
for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);
    date=datetime(name(1:8),'InputFormat','yyyyMMdd');

    if date < datetime(2021,09,03)
        opts = delimitedTextImportOptions("NumVariables", 13, "Encoding", "UTF-8");
        opts.DataLines = [2, Inf];
        opts.Delimiter = [" ", ",", "Z"];
        opts.VariableNames = ["ACQ", "Timestamp", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "For", "Var11", "Var12", "Var13"];
        opts.SelectedVariableNames = ["ACQ", "Timestamp", "For"];
        opts.VariableTypes = ["datetime", "datetime", "char", "char", "char", "char", "char", "char", "char", "double", "char", "char", "char"];
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule = "read";
        opts.ConsecutiveDelimitersRule = "join";
        opts = setvaropts(opts, ["Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, "ACQ", "InputFormat", "yyyy-MM-dd");
        opts = setvaropts(opts, "Timestamp", "InputFormat", "HH:mm:ss");
        tbl = readtable(filename, opts);      
        d = tbl.ACQ; d.Format='yyyy-MM-dd HH:mm:ss';        
        h = tbl.Timestamp; dur=duration(string(h),'InputFormat','hh:mm:ss');
        dti=d+dur; 
        fli = tbl.For;

    else
        opts = delimitedTextImportOptions("NumVariables", 13, "Encoding", "UTF-8");
        opts.DataLines = [2, Inf];
        opts.Delimiter = [" ", "Z"];
        opts.VariableNames = ["ACQ", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "For", "Var11", "Var12", "Var13"];
        opts.SelectedVariableNames = ["ACQ", "For"];
        opts.VariableTypes = ["datetime", "char", "char", "char", "char", "char", "char", "char", "char", "double", "char", "char", "char"];
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule = "read";
        opts.ConsecutiveDelimitersRule = "join";
        opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var11", "Var12", "Var13"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, "ACQ", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss.SSS");
        tbl = readtable(filename, opts);

        dti = tbl.ACQ; dti.Format='yyyy-MM-dd HH:mm:ss';           
        fli = tbl.For;

    end
    dti.Format='yyyy-MM-dd HH:mm:ss';       
    dt=[dt;dti];
    fl=[fl;fli];
    clearvars opts tbl dti fli h dur

end

dt = dateshift(dt,'start','second');
idx=isnan(fl);
fl(idx)=[];
dt(idx)=[];   

%% remove outliers
idx=isoutlier(fl,'percentiles',[.5 99.5]);
%figure; plot(dt(~idx),fl(~idx));
dt(idx)=[]; fl(idx)=[];
figure; plot(dt,fl);

%%
save([outpath 'fluorescence_Shimada2021'],'dt','fl');
