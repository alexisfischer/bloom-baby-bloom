%% import air temperature and timestamps from 2019 Shimada cruise data
% process these data like a .csv file
% Alexis D. Fischer, NWFSC, June 2023
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; %USER
indir= '~/Documents/Shimada2019/2019_airtemp_pressure/'; %USER
outpath=[filepath 'Shimada/Data/']; %USER

addpath(genpath(outpath)); 
addpath(genpath([filepath 'Misc-Functions/'])); 
Tdir=dir([indir 'SAMOS-AirTemp_*']);

dt=[];
airtemp=[];
for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);
    date=datetime(name(15:22),'InputFormat','yyyyMMdd');

    opts = delimitedTextImportOptions("NumVariables", 7);
    opts.DataLines = [1, Inf];
    opts.Delimiter = ",";
    opts.VariableNames = ["VarName1", "VarName2", "Var3", "VarName4", "VarName5", "Var6", "Var7"];
    opts.SelectedVariableNames = ["VarName1", "VarName2", "VarName4", "VarName5"];
    opts.VariableTypes = ["datetime", "datetime", "char", "double", "double", "char", "char"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, ["Var3", "Var6", "Var7"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Var3", "Var6", "Var7"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "VarName1", "InputFormat", "MM/dd/yyyy");
    opts = setvaropts(opts, "VarName2", "InputFormat", "HH:mm:ss.SSS");
    tbl = readtable(filename, opts);

    % Convert to output type
    d = tbl.VarName1; d.Format='yyyy-MM-dd HH:mm:ss';      
    h = duration(string(tbl.VarName2));
    dti=d+h; 

    airtempi = mean([tbl.VarName4 tbl.VarName5],2); %sbe38 (t2) which is mounted before the pump to the sea water system. external temperature

    dt=[dt;dti];
    airtemp=[airtemp;airtempi];        

end

idx=isnan(airtemp);
airtemp(idx)=[];
dt(idx)=[];
dt=dateshift(dt,'start','second');

%% remove outliers
idx=isoutlier(airtemp,'percentiles',[1 99]);
figure; plot(dt(~idx),airtemp(~idx));

dt(idx)=[]; airtemp(idx)=[];
figure; plot(dt,airtemp);

%%
save([outpath 'airtemperature_Shimada2019'],'dt','airtemp');
