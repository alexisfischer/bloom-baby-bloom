%% map underway environmental data along CCS
clear; %close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2021; % 2019; 2021
fprint=1;
unit=0.06;

%%%% load in discrete data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
%data=HA.chlA_ugL; cax=[1 20]; label={'Extracted';'Chl a (ug/L)'};%name='CHL'; xloc=-124;yloc=43.5; col=brewermap(256,'BuGn'); col(1:50,:)=[];
data=(HA.pDA_ngL); cax=[0 300]; label={' pDA';'(ng/L)'}; name='PDA';xloc=-123.8;yloc=43.8; col=brewermap(256,'OrRd'); col(1:20,:)=[];%col=flipud(brewermap(256,'PiYG')); data(data<2)=0; col(1:50,:)=[]; col(65:85,:)=[];
%data=HA.PNcellsmL; cax=[0 20]; label={'PN/mL'}; name='PNcellsmL';xloc=-123.9;yloc=43.8;col=brewermap(256,'BuGn'); col(1:50,:)=[];
%data=HA.NitrateM; cax=[0 20]; label={'Nitrate';'  (M)'}; name='NIT';xloc=-124;yloc=43.5;col=brewermap(256,'BuGn'); col(1:50,:)=[];
%data=HA.PhosphateM; cax=[0 3]; label={'Phosphate';'    (M)'}; name='PHS';xloc=-124;yloc=43.5;col=brewermap(256,'BuGn'); col(1:50,:)=[];
%data=HA.SilicateM; cax=[0 100]; label={'Silicate';'   (M)'}; name='SIL';xloc=-124.1;yloc=43.8;col=brewermap(256,'BuGn'); col(1:50,:)=[];

if yr==2019
    idx=find(HA.dt<datetime('01-Jan-2020'));
    data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx);  
elseif yr==2021
    idx=find(HA.dt>datetime('01-Jan-2020'));
    data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx);  
end

idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[];
lon=lon-unit;

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 4]); 
ind=(data<=0); 
scatter(lon(ind),lat(ind),2,[.3 .3 .3],'o','filled'); hold on
scatter(lon(~ind),lat(~ind),20,data(~ind),'filled'); hold on
    colormap(col); caxis(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('east');             
    hp=get(h,'pos');     
    hp=[0.9*hp(1) 1*hp(2) .6*hp(3) .32*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','left','fontsize',9);
    hold on    

load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA'); 
HA.lon=HA.lon-unit;
sem=NaN*ones(size(HA.st));
HA=addvars(HA,sem,'after','dt');
HA((HA.lat<40),:)=[]; %remove CA stations
HA=HA(~isnan(HA.fx_frau),:); %remove non SEM samples

if yr==2019
    idx=find(HA.dt<datetime('01-Jan-2020')); HA=HA(idx,:);    
    H=flipud(HA); H.st2(:)=(1:1:length(H.st)); %order them so 1:6, top to bottom
    scatter([H.lon],[H.lat],20,'o','k','MarkerFaceColor','none'); hold on
    text([H.lon]-0.6,[H.lat],num2str([H.st2]),'fontsize',8)

    [~,idx]=intersect(HA.st,[205;262;338]);
    scatter(HA.lon(idx),HA.lat(idx),20,'o','r','MarkerFaceColor','none','linewidth',1); hold on    

else
    idx=find(HA.dt>datetime('01-Jan-2020'));HA=HA(idx,:); 
    H=flipud(HA); H.st2(:)=(1:1:length(H.st)); %order them so 1:6, top to bottom
    scatter([H.lon],[H.lat],20,'o','k','MarkerFaceColor','none'); hold on
    text([H.lon]-0.9,[H.lat],num2str([H.st2]+9),'fontsize',8)

    %[~,idx]=intersect(H.st,[48;50;54;67;73;90;97;99;100]);
    %scatter(H.lon(idx),H.lat(idx),20,'o','r','MarkerFaceColor','none','linewidth',1); hold on    
end

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