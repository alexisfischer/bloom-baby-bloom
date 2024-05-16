%% import Deschutes River at E ST Bridge at Tumwater, WA - 12080010
%https://waterdata.usgs.gov/monitoring-location/12080010/#parameterCode=00060&showMedian=true&startDT=2021-08-01&endDT=2023-12-18
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/Data/';
filename=[filepath 'DeschutesR_2021-2023.txt'];

opts = delimitedTextImportOptions("NumVariables", 6);
opts.DataLines = [40, Inf];
opts.Delimiter = "\t";
opts.VariableNames = ["Var1", "Var2", "datetime", "Var4", "VarName5", "Var6"];
opts.SelectedVariableNames = ["datetime", "VarName5"];
opts.VariableTypes = ["char", "char", "datetime", "char", "double", "char"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Var4", "Var6"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var4", "Var6"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "datetime", "InputFormat", "yyyy-MM-dd HH:mm");
T = readtable(filename, opts);

DeschutesCfs=T.VarName5; %cubic feet per second
dt=datetime(T.datetime,'Format','yyyy-MM-dd HH:mm:ss')+hours(8); %input was PDT, convert to UTC
DR=timetable(dt,DeschutesCfs);

DR=retime(DR,'minutely');
DR.DeschutesCfs = fillmissing(DR.DeschutesCfs,'linear','SamplePoints',DR.dt,'MaxGap',minutes(30));

% %test plot
% figure; plot(dt,DeschutesCfs,'k-',DR.dt,DR.DeschutesCfs,'r-');

clear opts

save([filepath 'DeschutesR_discharge'],'DR');