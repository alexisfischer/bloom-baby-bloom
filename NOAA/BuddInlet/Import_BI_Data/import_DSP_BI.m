%% import Dinophysis mussel toxicity data
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/';
filename=[filepath 'DSP_BuddInlet_2012-2023.xlsx'];
opts = spreadsheetImportOptions("NumVariables", 3);
opts.Sheet = "2012-2023";
opts.DataRange = "A2:C304";
opts.VariableNames = ["CollectDate", "Var2", "DSPResult"];
opts.SelectedVariableNames = ["CollectDate", "DSPResult"];
opts.VariableTypes = ["datetime", "char", "double"];
opts = setvaropts(opts, "Var2", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var2", "EmptyFieldRule", "auto");
D = readtable(filename, opts, "UseExcel", false);
clear opts

D = renamevars(D,'CollectDate','dt');
D = renamevars(D,'DSPResult','DST'); %ug100g

D(isnan(D.DST),:)=[];
D.dt=datetime(D.dt,'Format','dd-MMM-yyyy HH:mm:ss')+hours(18); %assume samples were collected at 10am PDT,+8hrs to convert to UTC
D=table2timetable(D);

save([filepath 'DSP_BI'],'D');