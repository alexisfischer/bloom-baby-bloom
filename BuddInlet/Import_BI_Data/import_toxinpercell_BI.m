%% Import data from spreadsheet
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/Data/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

opts = spreadsheetImportOptions("NumVariables", 19);
opts.Sheet = " Sequim Bay_Budd Inlet";
opts.DataRange = "A34:S100";
opts.VariableNames = ["Var1", "Location", "Date", "Var4", "Var5", "VolumeSievedliter", "CellLSeawater", "TotalCells", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "OABHNg", "DTX1BHNg", "DTX2BHNg", "dihydroDTX1BHNg", "PTX2Ng"];
opts.SelectedVariableNames = ["Location", "Date", "VolumeSievedliter", "CellLSeawater", "TotalCells", "OABHNg", "DTX1BHNg", "DTX2BHNg", "dihydroDTX1BHNg", "PTX2Ng"];
opts.VariableTypes = ["char", "categorical", "datetime", "char", "char", "double", "double", "double", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var1", "Var4", "Var5", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Location", "Var4", "Var5", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14"], "EmptyFieldRule", "auto");
T = readtable([filepath 'DinoXToxinData.xlsx'], opts, "UseExcel", false);
clear opts

% deal with data gaps
T(isnan(T.OABHNg),:)=[];
T(isnan(T.CellLSeawater),:)=[];

idx=find(T.Date==datetime('04-Aug-2021')); T.VolumeSievedliter(idx)=5;
    T.TotalCells(idx)=T.VolumeSievedliter(idx)*T.CellLSeawater(idx);

idx=find(T.Date==datetime('12-Aug-2021')); T.VolumeSievedliter(idx)=5;
    T.TotalCells(idx)=T.VolumeSievedliter(idx)*T.CellLSeawater(idx);

% calculate toxin quotas
T.DSTng=sum([T.OABHNg,T.DTX1BHNg,T.DTX2BHNg,T.dihydroDTX1BHNg],2);
T.DST_pgcell=1000*T.DSTng./T.TotalCells;
T.PTX2_pgcell=1000*T.PTX2Ng./T.TotalCells;

idx=find(T.TotalCells==0);
T.DST_pgcell(idx)=0;
T.PTX2_pgcell(idx)=0;

% remove useless variables
if sum(T.DTX2BHNg,1)==0
    T=removevars(T,'DTX2BHNg');
end
if sum(T.dihydroDTX1BHNg,1)==0
    T=removevars(T,'dihydroDTX1BHNg');
end
T=removevars(T,{'Location','VolumeSievedliter','CellLSeawater','TotalCells'});

Q=T;
save([filepath 'ToxinCellQuota_BI.mat'],'Q');
