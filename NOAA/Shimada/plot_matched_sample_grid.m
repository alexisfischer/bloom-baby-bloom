%% plot matched sampling grid
% requires input from match_discrete_samplegrid
clear; %close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2019; % 2019; 2021
fprint=1;
leftsubplot=0; %special formatting for the leftmost subplot
unit=0.06;

%%%% load in discrete data
%load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
load([filepath 'NOAA/Shimada/Data/matched_discrete_samples_2019_2021'],'HA');
HA((HA.lat<40),:)=[]; %remove CA stations

HA=HA(HA.lat>=45 & HA.lat<=48,:); % only look at 45-47ºN

%data=HA.chlA_ugL; cax=[0 20]; ticks=[0,10,20]; label={'Chl a (ug/L)'}; name='CHL'; col=brewermap(256,'PuBu'); col(1:50,:)=[]; lim=.1;
data=HA.Nitrate_uM; cax=[0 48]; ticks=[0,24,48]; label={'NO_3^- + NO_2^- (μM)'}; name='NIT'; col=brewermap(256,'YlGn'); lim=0.6;
%data=HA.Phosphate_uM; cax=[0 3]; ticks=[0,1.5,3]; label={'PO_4^{3−} (μM)'}; name='PHS';col=brewermap(256,'YlGn'); lim=0.6;
%data=HA.Silicate_uM; cax=[0 48]; ticks=[0,24,48]; label={'Si[OH]_4 (μM)'}; name='SIL';col=brewermap(256,'YlGn'); lim=1.1;

if yr==2019    
    idx=find(HA.dt<datetime('01-Jan-2020') & HA.lat>42);
    data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx); match=HA.match(idx); 
elseif yr==2021
    idx=find(HA.dt>datetime('01-Jan-2020'));
    data=data(idx); lat = HA.lat(idx); lon = HA.lon(idx); match=HA.match(idx); 
end

idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[]; match(idx)=[];
lon=lon-unit;

fx=length(find(data>lim))./length(data)

%%
%%%% plot
if leftsubplot == 1
    figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 4.7]); 
elseif leftsubplot == 0 
    figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 4.7]); 
end

ind=(data<=lim); 
scatter(lon(ind),lat(ind),2,[.3 .3 .3],'o','filled'); hold on
scatter(lon(~ind),lat(~ind),20,data(~ind),'filled'); hold on
scatter(lon(match),lat(match),20,'k','o','linewidth',.2); hold on %match ups

    colormap(col); clim(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('northoutside','xtick',ticks); hp=get(h,'pos');    
    set(h,'pos',hp,'xaxisloc','top','fontsize',9,'tickdir','out');
    xtickangle(0); hold on;    
    hold on     

colorTitleHandle = get(h,'Title');
set(colorTitleHandle,'String',label,'fontsize',11);
    
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA'); 
HA.lon=HA.lon-unit;
sem=NaN*ones(size(HA.st));
HA=addvars(HA,sem,'after','dt');
HA((HA.lat<40),:)=[]; %remove CA stations
HA=HA(~isnan(HA.fx_frau),:); %remove non SEM samples

if strcmp(name,'pDA')
    if yr==2019
        idx=find(HA.dt<datetime('01-Jan-2020')); HA=HA(idx,:);    
        H=flipud(HA); H.st2(:)=(1:1:length(H.st)); %order them so 1:6, top to bottom
        scatter([H.lon],[H.lat],20,'o','k','MarkerFaceColor','none'); hold on
        text([H.lon]-0.4,[H.lat]-.1,num2str([H.st2]),'fontsize',8)    
    else
        idx=find(HA.dt>datetime('01-Jan-2020'));HA=HA(idx,:); 
        H=flipud(HA); H.st2(:)=(1:1:length(H.st)); %order them so 1:6, top to bottom
        scatter([H.lon],[H.lat],20,'o','k','MarkerFaceColor','none'); hold on
        text([H.lon]-0.6,[H.lat]-.15,num2str([H.st2]+9),'fontsize',8)   
    end
end

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-126.6 -123.5],'xtick',-127:2:-124,...
    'xticklabel',{'127 W','125 W'},'yticklabel',...
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},...
    'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');

if leftsubplot == 1
    set(gca,'ylim',[39.9 49],'xlim',[-127.3 -122.3],'xtick',-127:2:-122,...
        'xticklabel',{'127 W','125 W','123 W'},'yticklabel',...    
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');    
   text(-124.25,47.75,{'JF';'Eddy'},'fontsize',9); hold on
   text(-123.85,46.2,{'Colum.';'River'},'fontsize',9); hold on
   text(-124,44,{'Heceta';'Bank'},'fontsize',9); hold on
   text(-124,41.65,{'Trinidad';' Head'},'fontsize',9); hold on
end
    xtickangle(0); hold on;    

if strcmp(name,'SILHi')
    set(gca,'ylim',[43.5 47.5],'ytick',44:1:47,'yticklabel',44:1:47,'xticklabel',{});
end

if fprint==1
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_discrete_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 