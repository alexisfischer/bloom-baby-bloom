%% heatmap of matched discrete samples (2019 and 2021) along CCS
% data options: chlA, nitrate, phosphate, silicate
% option to include or remove sites of interest
% requires input from match_discrete_samplegrid
% Shimada 2019 and 2021
% A.D. Fischer, May 2024
%
clear;

%%%%USER
fprint = 0; % 1 = print; 0 = don't
yr = 2019; % 2019; 2021
unit = 0.06; % amount to subtract from latitude so does not overlap with map
leftsubplot=0; % 1 = larger plot sites of interest; 0 = basic version
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/';

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/coast_CCS.mat'],'coast'); %map
states=load([filepath 'Data/USwestcoast_pol.mat']); %map

load([filepath 'Data/matched_discrete_samples_2019_2021'],'HA');

% %or run the function if have mapping toolbox
% load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
% [HA] = match_discrete_samples_2019_2021(HA);

HA((HA.lat<40),:)=[]; %remove CA stations
HA(~(HA.dt.Year==yr),:)=[]; %select year of data

%%%%USER enter data of interest
data=HA.chlA_ugL; cax=[0 20]; ticks=[0,10,20]; label={'Chl a (ug/L)'}; name='CHL'; col=brewermap(256,'PuBu'); col(1:50,:)=[]; lim=.1;
%data=HA.Nitrate_uM; cax=[0 48]; ticks=[0,24,48]; label={'NO_3^- + NO_2^- (μM)'}; name='NIT'; col=brewermap(256,'YlGn'); lim=0.6;
%data=HA.Phosphate_uM; cax=[0 3]; ticks=[0,1.5,3]; label={'PO_4^{3−} (μM)'}; name='PHS';col=brewermap(256,'YlGn'); lim=0.6;
%data=HA.Silicate_uM; cax=[0 48]; ticks=[0,24,48]; label={'Si[OH]_4 (μM)'}; name='SIL';col=brewermap(256,'YlGn'); lim=1.1;

% remove Nans and add lon gap
lat = HA.lat; lon = HA.lon; match=HA.match;
idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[]; match(idx)=[]; 
lon=lon-unit;

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
colorTitleHandle = get(h,'Title');
set(colorTitleHandle,'String',label,'fontsize',11);

% Plot map
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

if fprint==1
    exportgraphics(gca,[filepath 'Figs/' name '_discrete_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 