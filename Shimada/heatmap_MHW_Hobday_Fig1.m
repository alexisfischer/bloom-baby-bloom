%% heatmap of SST anomaly and MHW outlined using Hobday et al. 2016
% Shimada 2019 and 2021
% Fig. 1 in Fischer et al. 2024, L&O
% A.D. Fischer, May 2024
clear;

%%%%USER
fprint = 0; % 1 = print; 0 = don't
yr = 2019; % 2019; 2021
res = 0.25; % heatmap resolution: Coarser = 0.2; Finer = 0.1 % Set grid resolution (degrees)
filepath = '~/Documents/MATLAB/bloom-baby-bloom/Shimada/';

% load in data
addpath(genpath('~/Documents/MATLAB/m_mhw1.0/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/coast_CCS'],'coast'); %map
states=load([filepath 'Data/USwestcoast_pol']); %map
load([filepath 'Data/MHW_' num2str(yr) ''],'lat','lon','sst','clm','mhw','m90');

%%%%USER enter data of interest
data=double(sst)-double(clm); data(isnan(data))=0; cax=[-3 3]; ticks=-3:3:3; label={'SST anomaly (^oC)'}; name='SSTa'; col=flipud(brewermap(256,'RdBu'));
%data=mhw; data(isnan(data))=-1; cax=[0 3]; ticks=0:1:3; label={'MHW (^oC)'}; name='MHW'; col=(brewermap(256,'OrRd')); %data(isnan(data))=0; 
%data=sst; cax=[10 20]; ticks=10:5:20; label={'SST (^oC)'}; name='SST'; col=brewermap(256,'BuPu');

%%%% plot
[lon_plot,lat_plot] = meshgrid(lon,lat);
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 4.7]); 

pcolor(lon_plot-res/2,lat_plot-res/2,data); % have to shift lat/lon for pcolor with flat shading     
shading flat; hold on;

% Draw contour lines around values exceeding the threshold
mhw(isnan(mhw))=-1;
contour(lon_plot,lat_plot,mhw,[0 0], 'LineColor', 'k', 'LineWidth', 1);

colormap(col); clim(cax);
axis([min(lon) max(lon) min(lat) max(lat)]);
h=colorbar('northoutside'); hp=get(h,'pos');    
set(h,'pos',hp,'xaxisloc','top','fontsize',9,'tickdir','out');
xtickangle(0); hold on;    
colorTitleHandle = get(h,'Title');
set(colorTitleHandle,'String',label,'fontsize',11);

% Plot map
fillseg(coast); 
dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-127 -122.3],'xtick',-127:2:-122,...
    'xticklabel',{'127 W','125 W','123 W'},'yticklabel',...
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},...
    'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom'); 
text(-124.25,47.75,{'JF';'Eddy'},'fontsize',9); hold on
text(-123.85,46.2,{'Colum.';'River'},'fontsize',9); hold on
text(-124,44,{'Heceta';'Bank'},'fontsize',9); hold on
text(-124,41.65,{'Trinidad';' Head'},'fontsize',9); hold on
xtickangle(0); hold on;    

if fprint==1
    exportgraphics(gca,[filepath 'Figs/MHW_Hobday_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 