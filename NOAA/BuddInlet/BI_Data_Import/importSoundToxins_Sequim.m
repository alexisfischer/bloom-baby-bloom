%% import Soundtoxins
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

opts = spreadsheetImportOptions("NumVariables", 8);
opts.Sheet = "My Observations";
opts.DataRange = "A2:H1251";
opts.VariableNames = ["Var1", "Site", "Date", "Var4", "Genus", "Species", "Abundance", "CellPerLiter"];
opts.SelectedVariableNames = ["Site", "Date", "Genus", "Species", "Abundance", "CellPerLiter"];
opts.VariableTypes = ["char", "categorical", "datetime", "char", "categorical", "categorical", "categorical", "double"];
opts = setvaropts(opts, ["Var1", "Var4"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Site", "Var4", "Genus", "Species", "Abundance"], "EmptyFieldRule", "auto");
T = readtable([filepath 'SQ dinophysis all.xlsx'], opts, "UseExcel", false);
clear opts

T(contains(cellstr(T.Abundance),'undefined'),:)=[]; %remove blanks
T(~contains(cellstr(T.Species),'sp'),:)=[]; %only look at bulk Dinophysis

T.month=T.Date.Month; Month=(1:1:12)';
Absent=NaN*ones(12,1);
Present=Absent;
Common=Absent;
Bloom=Absent;
n=Absent;
for i=1:length(Month)
    Absent(i)=sum(T.month==i & contains(cellstr(T.Abundance),'Absent'));
    Present(i)=sum(T.month==i & contains(cellstr(T.Abundance),'Present'));
    Common(i)=sum(T.month==i & contains(cellstr(T.Abundance),'Common'));
    Bloom(i)=sum(T.month==i & contains(cellstr(T.Abundance),'Bloom'));
    n(i)=sum(T.month==i);
end
SB=table(Month,n,Bloom,Common,Present,Absent);
SB(:,3:end)=SB(:,3:end)./SB.n;

T=table2array(SB(:,3:end));
clearvars Month n Absent Present Common Bloom i

save([filepath 'SequimBay_Dinophysiscells.mat'],'T','SB');
