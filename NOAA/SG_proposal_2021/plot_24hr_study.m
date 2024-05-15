%plot Totten 24 hr study
clear;
filepath = '~/MATLAB/NWFSC/TottenInlet/'; 
addpath(genpath('~/MATLAB/bloom-baby-bloom/'));
addpath(genpath(filepath));

opts = spreadsheetImportOptions("NumVariables", 16);
opts.Sheet = "TOTTEN";
opts.DataRange = "A2:P148";
opts.VariableNames = ["DateTime", "Var2", "Var3", "TempC", "Salppt", "Var6", "pH", "Var8", "Var9", "Chlugl", "Var11", "DOmgl", "Var13", "Var14", "Var15", "Tidem"];
opts.SelectedVariableNames = ["DateTime", "TempC", "Salppt", "pH", "Chlugl", "DOmgl", "Tidem"];
opts.VariableTypes = ["datetime", "char", "char", "double", "double", "char", "double", "char", "char", "double", "char", "double", "char", "char", "char", "double"];
opts = setvaropts(opts, ["Var2", "Var3", "Var6", "Var8", "Var9", "Var11", "Var13", "Var14", "Var15"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var2", "Var3", "Var6", "Var8", "Var9", "Var11", "Var13", "Var14", "Var15"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DateTime", "InputFormat", "");
T = readtable("/Users/afischer/Documents/Proposals/NOAA-OAR-SG-2021/PrelimData/2011Totten_YSI.xls", opts, "UseExcel", false);
clear opts


%%

data(1).X = T.DateTime;
data(1).Y = T.Tidem; data(1).YLabel = 'Tide (m)';
data(2).Y = smooth(T.DOmgl); data(2).YLabel = 'Dissolved Oxygen (mg/L)';
data(3).Y = smooth(T.pH); data(3).YLabel = 'pH';
data(4).Y = smooth(T.Chlugl); data(4).YLabel = 'Chlorophyll (ug/L)';

col=brewermap(4,'Set1'); 
data(1).Color='k';
data(2).Color=col(2,:);
data(3).Color=col(1,:);
data(4).Color=col(3,:);

figure;
[hax,hlines,data] = plotyn(data); hold on
set(hax,'fontsize',12);
set(hlines,'linewidth',1.5)

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'Figs/Totten_24hr.tif']);
hold off

