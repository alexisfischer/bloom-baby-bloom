%% map underway environmental data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2021; % 2019; 2021
fprint=1;

%%%% load in discrete data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
%data=HA.chlA_ugL; cax=[1 20]; label={'Extracted';'Chl a (ug/L)'}; name='CHL';
%data=HA.pDA_ngL; cax=[0 200]; label='pDA (ng/L)'; name='PDA';
%data=HA.PNcellsmL; cax=[0 20]; label={'Pseudo-nitzschia';'(cells/mL)'}; name='PNcellsmL';
%data=HA.NitrateM; cax=[0 20]; label='Nitrate (M)'; name='NIT';
%data=HA.PhosphateM; cax=[0 3]; label='Phosphate (M)'; name='PHS';
data=HA.SilicateM; cax=[0 100]; label='Silicate (M)'; name='SIL';

    if yr==2019
        idx=find(HA.dt<datetime('01-Jan-2020'));
        data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx);  
    elseif yr==2021
        idx=find(HA.dt>datetime('01-Jan-2020'));
        data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx);  
    end

idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[];

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 4]); 
ind=find(data<1); data(ind)=NaN;
scatter(lon(ind),lat(ind),ones(size(ind)),[.3 .3 .3],'o','filled'); hold on
bubblechart(lon,lat,data,'r','MarkerFaceAlpha',0,'linewidth',1.5); hold on;

bubblelim(cax); bubblesize([1 10]);
h=bubblelegend(label,'Location','east','Box','off');
   hp=get(h,'pos'); 
   hp=[0.9*hp(1) 0.85*hp(2) hp(3) hp(4)]; % [left, bottom, width, height].
   set(h,'pos',hp); 
   hold on
axis([min(lon) max(lon) min(lat) max(lat)]);

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.8 49],'xlim',[-127 -120],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);
   
if fprint
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_discrete_Shimada' num2str(yr) '.png'],'Resolution',100)    
end
hold off 