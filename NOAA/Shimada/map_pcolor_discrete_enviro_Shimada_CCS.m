%% map underway environmental data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2019; % 2019; 2021
fprint=1;

%%%% load in discrete data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
%data=HA.chlA_ugL; cax=[1 20]; label={'Extracted';'Chl a (ug/L)'};%name='CHL'; xloc=-124;yloc=43.5; col=brewermap(256,'BuGn');
data=HA.pDA_ngL; cax=[1 100]; label={' pDA';'(ng/L)'}; name='PDA';xloc=-123.8;yloc=43.8;col=brewermap(256,'Blues');
%data=HA.PNcellsmL; cax=[0 20]; label={'PN/mL'}; name='PNcellsmL'; xloc=-123.9;yloc=43.8;col=brewermap(256,'BuGn');
%data=HA.NitrateM; cax=[0 20]; label={'Nitrate';'  (M)'}; name='NIT'; xloc=-124;yloc=43.5;col=brewermap(256,'BuGn');
%data=HA.PhosphateM; cax=[0 3]; label={'Phosphate';'    (M)'}; name='PHS'; xloc=-124;yloc=43.5;col=brewermap(256,'BuGn');
%data=HA.SilicateM; cax=[0 100]; label={'Silicate';'   (M)'}; name='SIL'; xloc=-124.1;yloc=43.8;col=brewermap(256,'BuGn');

    if yr==2019
        idx=find(HA.dt<datetime('01-Jan-2020'));
        data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx);  
    elseif yr==2021
        idx=find(HA.dt>datetime('01-Jan-2020'));
        data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx);  
    end

col(1:50,:)=[];
idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[];
lon=lon-.08;

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 4]); 
ind=(data<1); 
scatter(lon(ind),lat(ind),2,[.3 .3 .3],'o','filled'); hold on
scatter3(lon(~ind),lat(~ind),data(~ind),30,data(~ind),'filled'); view(2); hold on

    colormap(col); caxis(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('east');             
    hp=get(h,'pos');     
    hp=[0.9*hp(1) 1*hp(2) .6*hp(3) .32*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','left','fontsize',9);
    hold on    

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-126.6 -122.3],'xtick',-126:2:-121,'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);
text(xloc,yloc,label,'fontsize',11); hold on

if fprint==1
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_discrete_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 