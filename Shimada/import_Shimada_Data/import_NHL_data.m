%% Import NHL nitrate and chl data
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

file="/Users/alexis.fischer/Documents/Shimada2019/NHL_nuts_chla_4Alexis.xlsx";

opts = spreadsheetImportOptions("NumVariables", 10);
opts.Sheet = "NHL_nuts_2019and2021";
opts.DataRange = "A2:J510";
opts.VariableNames = ["Var1", "SampleDate", "Station", "pressure", "no2", "no3", "no3no2", "Latitude", "Longitude", "Depth"];
opts.SelectedVariableNames = ["SampleDate", "Station", "pressure", "no2", "no3", "no3no2", "Latitude", "Longitude", "Depth"];
opts.VariableTypes = ["char", "datetime", "char", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var1", "Station"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Station"], "EmptyFieldRule", "auto");
N = readtable(file, opts, "UseExcel", false);
N = renamevars(N,'SampleDate','dt');
N = renamevars(N,'Station','station');

opts = spreadsheetImportOptions("NumVariables", 6);
opts.Sheet = "NHL_chla_2019and2021";
opts.DataRange = "A2:F538";
opts.VariableNames = ["Var1", "date", "station", "Depth", "Fraction", "ChlorophyllAConcentration"];
opts.SelectedVariableNames = ["date", "station", "Depth", "Fraction", "ChlorophyllAConcentration"];
opts.VariableTypes = ["char", "datetime", "char", "double", "categorical", "double"];
opts = setvaropts(opts, ["Var1", "station"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "station", "Fraction"], "EmptyFieldRule", "auto");
C = readtable(file, opts, "UseExcel", false);
C = renamevars(C,'date','dt');
C(C.Fraction=='>5µm',:)=[];
C2=C(C.Depth==2,:);
C10=C(C.Depth==10,:);
C2=removevars(C2,{'Fraction','Depth'});
C10=removevars(C10,{'Fraction','Depth'});
C2 = renamevars(C2,'ChlorophyllAConcentration','chl2');
C10 = renamevars(C10,'ChlorophyllAConcentration','chl10');

% Merge tables based on Date, Station, and Value_N
T = outerjoin(N,C2, 'Keys', {'dt', 'station'}, 'MergeKeys', true);
TT = outerjoin(T,C10, 'Keys', {'dt', 'station'}, 'MergeKeys', true);

% only select July-Sep data for 2019 and 2021
TT(~(TT.dt>datetime('2019-07-08') & TT.dt<datetime('2021-09-10')),:)=[];
TT((TT.dt>datetime('2019-08-10') & TT.dt<datetime('2021-08-01')),:)=[];
%TT(~(TT.dt>datetime('2019-07-01') & TT.dt<datetime('2021-09-30')),:)=[];

TT(isnan(TT.Latitude),:)=[];

% extract numbers from cell to get station #
b=regexp(TT.station,'\d+(\.)?(\d+)?','match');
TT.st=str2double([b{:}])';
TT=removevars(TT,'station');
TT=movevars(TT,'st','After','dt');

clear opts file C N C2 C10 T b


i19=(TT.dt<datetime('01-Jan-2020'));

%TT.no3((TT.no3==0))=.00001;
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 5 2.5]); 

bubblechart(TT.dt(~i19)-2*365,TT.st(~i19),TT.no3(~i19)); hold on;
bubblechart(TT.dt(i19),TT.st(i19),TT.no3(i19)); 
bubblesize([2 20])
bubblelim([0 40]);
set(gca,'ylim',[0 30],'xlim',[datetime('06-Jul-2019') datetime('12-Sep-2019')],'tickdir','out')
ylabel('distance offshore (km)')
%legend('2019','2021','Location','Northoutside')
bubblelegend('Nitrate (uM)','Location','eastoutside')

exportgraphics(fig,[filepath 'Shimada/Figs/Nitrate_NHL.png'],'Resolution',100)   



