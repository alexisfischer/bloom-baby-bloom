%% Import SoundToxins
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

opts = delimitedTextImportOptions("NumVariables", 14);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "Site", "Date", "Var5", "Var6", "Species", "Abundance", "CellPerLiter", "WaterSource", "Var11", "Var12", "Var13", "Var14"];
opts.SelectedVariableNames = ["Site", "Date", "Species", "Abundance", "CellPerLiter", "WaterSource"];
opts.VariableTypes = ["char", "char", "categorical", "datetime", "char", "char", "categorical", "categorical", "double", "categorical", "char", "char", "char", "char"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Var5", "Var6", "Var11", "Var12", "Var13", "Var14"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Site", "Var5", "Var6", "Species", "Abundance", "WaterSource", "Var11", "Var12", "Var13", "Var14"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Date", "InputFormat", "MM/dd/yy HH:mm");
opts = setvaropts(opts, "CellPerLiter", "TrimNonNumeric", true);
opts = setvaropts(opts, "CellPerLiter", "ThousandsSeparator", ",");
T = readtable([filepath 'Data/Soundtoxins_dinophysis_allsites.csv'], opts);

T(isundefined(T.Abundance),:)=[]; %remove blanks
T(~contains(cellstr(T.Species),'sp'),:)=[]; %only look at bulk Dinophysis
T(T.Date<datetime('01-Jan-2014'),:)=[]; %remove data before 2014

% separate sites
[site,ib,ic]=unique(T.Site,'stable');
for i=1:length(site)
    S(i).site=cellstr(site(i));
    S(i).Date=T.Date(ic==ib(i));  
    S(i).Month=S(i).Date.Month; 
    S(i).Abundance=T.Abundance(ic==ib(i));
    S(i).CellPerLiter=T.CellPerLiter(ic==ib(i));    
    S(i).WaterSource=T.WaterSource(ic==ib(i));    
end
clearvars opts ib ic site i T

%%%% calculate fx Present, common, etc for each site
Month=(1:1:12)';
for j=1:length(S)
    Absent=NaN*ones(12,1); Present=Absent; Common=Absent; Bloom=Absent;n=Absent;
    for i=1:length(Month)
        Absent(i)=sum(S(j).Month==i & contains(cellstr(S(j).Abundance),'Absent'));
        Present(i)=sum(S(j).Month==i & contains(cellstr(S(j).Abundance),'Present'));        
        Common(i)=sum(S(j).Month==i & contains(cellstr(S(j).Abundance),'Common'));
        Bloom(i)=sum(S(j).Month==i & contains(cellstr(S(j).Abundance),'Bloom'));
        n(i)=sum(S(j).Month==i);
    end
    B=table(Month,n,Bloom,Common,Present,Absent);
    B(:,3:end)=B(:,3:end)./B.n;
    S(j).table=B;   
end
clearvars Month n Absent Present Common Bloom i j B

QH=S(1).table; BI=S(2).table; LB=S(3).table; SB=S(4).table; MB=S(5).table;  DB=S(6).table;

save([filepath 'Data/SoundToxins_Dinophysis.mat'],'QH','BI','LB','SB','MB','DB','S');