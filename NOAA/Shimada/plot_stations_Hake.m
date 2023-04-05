%% plot station map of hake, NCC, and Newport lines
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/';
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'Shimada/Data/IFCB_NOAA_UCSC_lat_lon_dt'],'NOAA');
d=length(NOAA.dt)-length(NOAA.filelist); NOAA.dt(end-d+1:end)=[];
iN=find(NOAA.dt>=datetime('01-Jan-2021'));

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 5]); 
c=brewermap(3,'PuBuGn');

states=load([filepath 'Shimada/Data/USwestcoast_pol']);
load([filepath 'Shimada/Data/coast_CCS'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states(:,1),states(:,2),'k'); hold on;
set(gca,'ylim',[34 49],'xlim',[-127 -120],'fontsize',11,'tickdir','out','box','on','xaxisloc','bottom');

hake=scatter(NOAA.lon(iN),NOAA.lat(iN),10,c(2,:),'filled'); hold on

% set figure parameters%
    exportgraphics(gca,[filepath 'Shimada/Figs/stationmap_Hake.png'],'Resolution',100)    

