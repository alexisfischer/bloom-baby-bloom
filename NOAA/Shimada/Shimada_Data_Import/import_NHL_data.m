%% Import NHL nitrate and chl data
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

file="/Users/alexis.fischer/Documents/Shimada2019/NHL_nuts_chla_4Alexis.xlsx";

opts = spreadsheetImportOptions("NumVariables", 10);
opts.Sheet = "NHL_nuts_2019and2021";
opts.DataRange = "A2:J510";
opts.VariableNames = ["Var1", "SampleDate", "Station", "Var4", "Var5", "no3", "no3no2", "Latitude", "Longitude", "Depth"];
opts.SelectedVariableNames = ["SampleDate", "Station", "no3", "no3no2", "Latitude", "Longitude", "Depth"];
opts.VariableTypes = ["char", "datetime", "categorical", "char", "char", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var1", "Var4", "Var5"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Station", "Var4", "Var5"], "EmptyFieldRule", "auto");
N = readtable(file, opts, "UseExcel", false);
N = renamevars(N,'SampleDate','dt');
N = renamevars(N,'Station','station');

opts = spreadsheetImportOptions("NumVariables", 6);
opts.Sheet = "NHL_chla_2019and2021";
opts.DataRange = "A2:F538";
opts.VariableNames = ["Var1", "date", "station", "Depth", "Fraction", "ChlorophyllAConcentration"];
opts.SelectedVariableNames = ["date", "station", "Depth", "Fraction", "ChlorophyllAConcentration"];
opts.VariableTypes = ["char", "datetime", "categorical", "double", "categorical", "double"];
opts = setvaropts(opts, "Var1", "WhitespaceRule", "preserve");
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

clear opts file C N C2 C10 T


i19=(TT.dt<datetime('01-Jan-2020'));

fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 4 3]); 
plot(TT.dt(i19),TT.no3(i19),'r*',TT.dt(~i19)-2*365,TT.no3(~i19),'bo')
set(gca,'xlim',[datetime('05-Jul-2019') datetime('10-Sep-2019')])
legend('2019','2021','Location','Northoutside')
ylabel('Nitrate (uM)')

exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/Nitrate_NHL.png'],'Resolution',100)    
