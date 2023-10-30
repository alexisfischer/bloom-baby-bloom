%% find ratios between nutrients
clear; %close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2021; % 2019; 2021
fprint=1;
unit=0.06;
val='S'; %'S' %'P'

%%%% load in discrete data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
HA((HA.lat<40),:)=[]; %remove CA stations

% %exlude non-detects
% HA.Nitrate_uM(HA.Nitrate_uM<=0.6)=0;
% HA.Phosphate_uM(HA.Phosphate_uM<=0.6)=0;
% HA.Silicate_uM(HA.Silicate_uM<=1.1)=0;
% HA.N2P_n=log10(HA.Phosphate_uM./(HA.Nitrate_uM./16)); 
% HA.N2S_n=log10(HA.Silicate_uM./15./(HA.Nitrate_uM./16)); 
% HA=movevars(HA,'N2P_n','After','N2P');
% HA=movevars(HA,'N2S_n','After','N2S');
% 
% % convert Inf into values
% HA.N2P_n(HA.N2P_n==-Inf)=-1;
% HA.N2S_n(HA.N2S_n==-Inf)=-1;
% HA.N2P_n(HA.N2P_n==Inf)=1;
% HA.N2S_n(HA.N2S_n==Inf)=1;

if yr==2019    
    HA((HA.dt>datetime('01-Jan-2020')),:)=[];
    HA((HA.lat<41.5),:)=[];
elseif yr==2021
    HA((HA.dt<datetime('01-Jan-2020')),:)=[];
end

if strcmp(val,'P') % Nitrate:Phosphate
    lat=HA.lat; lon=HA.lon; label='     N:Ph'; name='Pstar'; lim=0.01; 
    data=HA.N2P;
    %Nitrate replete relative to Phosphate: 2019 17%, 2021 11%
else % Silicate:Nitrate
    lat=HA.lat; lon=HA.lon; label='     N:Si'; name='Sstar'; lim=0.01; 
    data=HA.N2S;    
    %Nitrate replete relative to Silicate: 2019 0%, 2021 8%
end

idx=find(data>0); fxNitratereplete=length(idx)/length(data)

%%%% scatterplot
%figure; plot(lat,data,'ko'); title(yr); hold on; hline(0);

%%%% plot map location
cax=[-1 1]; ticks=[-1 0 1]; col=flipud(brewermap(256,'RdBu'));

idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[]; 
lon=lon-unit;

figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 4]); 
%ind=(data<=lim); 
scatter(lon,lat,20,data,'filled'); hold on
%scatter(lon(ind),lat(ind),2,[.3 .3 .3],'o','filled'); hold on
%scatter(lon(~ind),lat(~ind),20,data(~ind),'filled'); hold on
    colormap(col); clim(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('east','XTick',ticks);             
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

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-126.6 -122.3],'xtick',-126:2:-121,'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);
text(-124.3,43.8,label,'fontsize',10); hold on

if fprint==1
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_discrete_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 