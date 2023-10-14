%% plot 2023 Shimada transects
clear; %close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%% load in data
opts = spreadsheetImportOptions("NumVariables", 4);
opts.Sheet = "WPs to 1500 m for GIS";
opts.DataRange = "A2:D245";
opts.VariableNames = ["ETID", "Var2", "Lat", "Long"];
opts.SelectedVariableNames = ["ETID", "Lat", "Long"];
opts.VariableTypes = ["double", "char", "double", "double"];
opts = setvaropts(opts, "Var2", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var2", "EmptyFieldRule", "auto");
T = readtable("/Users/alexis.fischer/Documents/Shimada2023/2023 Hake Survey transect waypoints - to Alexis.xlsx", opts, "UseExcel", false);
clear opts

% remove latitudes <39N and above 47N
idx=(T.Lat>39 & T.Lat<47);
T(~idx,:)=[];

% select every other transect
iseven = rem(T.ETID, 2) == 0;
T(iseven,:)=[];

% remove the western end of the transect
%T(1:2:end,:)=[];

% add a slightly offshore sampling point
T.Long(1:2:end)=T.Long(2:2:end)-.2;

% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 4]); 
% 2021 pDA data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
data=(HA.pDA_ngL); cax=[0 300]; label={' pDA';'(ng/L)'}; name='PDA';xloc=-123.8;yloc=43.8; col=brewermap(256,'OrRd'); col(1:20,:)=[];%col=flipud(brewermap(256,'PiYG')); data(data<2)=0; col(1:50,:)=[]; col(65:85,:)=[];
idx=find(HA.dt>datetime('01-Jan-2020'));
data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx);  
idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[];
scatter(lon,lat,20,'r','o','filled'); hold on

% 2023 proposed sites
scatter(T.Long,T.Lat,20,'k','o'); hold on

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[38.5 48],'xlim',[-126.6 -122.3],'xtick',-126:2:-121,'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');

writetable(T,[filepath 'NOAA/Shimada/Data/HAB_Leg2-3_Shimada2023.csv'])

