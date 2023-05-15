%% plot station map of hake, NCC, and Newport lines
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/class/summary_PN_allTB_CCS_NOAA-OSU_v7.mat'],'mdateTB','filelistTB');
dt=datetime(mdateTB,'ConvertFrom','datenum');

%%%% match data with lat lon
[lat,lon,ia,filelistTB] = match_IFCBdata_w_Shimada_lat_lon(filepath,filelistTB); dt=dt(ia); 

%%% use 2021 data
idx=dt>datetime('01-Jan-2020'); dt=dt(idx); lat=lat(idx); lon=lon(idx); 

%%%% remove data south of 40 N and the Strait so ~equivalent between 2019 and 2021
idx=find(lat<40); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; 
idx=find(lat>47.5 & lon>-124.7); dt(idx)=[]; lat(idx)=[]; lon(idx)=[]; 

clearvars idx ia mdateTB filelistTB dt

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 4.5]); 
c=brewermap(3,'PuBuGn');
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol']);
load([filepath 'NOAA/Shimada/Data/coast_CCS'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-128.5 -122.3],'xtick',-129:2:-121,'fontsize',10,'tickdir','out','box','on','xaxisloc','bottom');
hake=scatter(lon,lat,10,c(2,:),'filled'); hold on

% set figure parameters%
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/stationmap_Hake.png'],'Resolution',300)    

