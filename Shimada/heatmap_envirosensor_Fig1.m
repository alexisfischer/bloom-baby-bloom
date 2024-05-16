%% heatmap of environmental sensor data along CCS
% data options: temperature, salinity, pCO2, and fluorescence
% option to plot scatter plot or heatmap (and change resolution)
% option to include or remove sites of interest
% Shimada 2019 and 2021
% Fig. 1 in Fischer et al. 2024, L&O
% A.D. Fischer, May 2024
%
clear;

%%%%USER
yr = 2021; % 2019; 2021
option = 2; % 1 = Plot the individual data points; 2 = Grid the data
res = 0.15; % heatmap resolution: Coarser = 0.2; Finer = 0.1 % Set grid resolution (degrees)
leftsubplot=0; % 1 = larger plot sites of interest; 0 = basic version
filepath = '~/Documents/MATLAB/bloom-baby-bloom/Shimada/';

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/environ_Shimada' num2str(yr) ''],'DT','LON','LAT','FL','TEMP','SAL','PCO2');
load([filepath 'Data/coast_CCS'],'coast'); %map
states=load([filepath 'Data/USwestcoast_pol']); %map

%%%%USER enter data of interest
data=TEMP; cax=[10 20];  ticks=10:5:20; label={'SST (^oC)'}; name='SST'; col=brewermap(256,'BuPu');
%data=SAL; cax=[30 35]; ticks=[30,32,35]; label={'SSS (psu)'}; name='SAL'; col=parula;
%data=PCO2; cax=[200 800]; ticks=200:600:800; label={'pCO_2 (ppm)'}; name='PCO2'; col=brewermap(256,'RdPu');
%data=FL; cax=[0 8]; ticks=0:4:8; label={'Chl Fl (RFU)'}; name='FL'; col=brewermap(256,'BuGn');

% remove Nans
    idx=isnan(data); data(idx)=[]; LAT(idx)=[]; LON(idx)=[]; lon=LON; lat=LAT;
% remove data from the Strait
    idx=find(lat>47.5 & lon>-124.7); lat(idx)=[]; lon(idx)=[]; data(idx)=[];
    idx=find(lat<40); lat(idx)=[]; lon(idx)=[]; data(idx)=[];

%%%% plot
if leftsubplot == 1
    figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 4.7]); 
else
    figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 4.7]); 
end

if option==1
    scatter3(lon,lat,data,10,data,'filled'); 
    view(2); hold on
else
    % Create grid
    lon_grid = min(lon):res:max(lon)+.5;
    lat_grid = min(lat):res:max(lat)+.5;
    nx = length(lon_grid);
    ny = length(lat_grid);
    
    % Average data on grid
    data_grid = nan(nx,ny);
    for ii = 1:nx
        for jj = 1:ny
            data_grid(ii,jj) = mean(data(lon>=lon_grid(ii)-res/2 & lon<lon_grid(ii)+res/2 & lat>=lat_grid(jj)-res/2 & lat<lat_grid(jj)+res/2),'omitnan');
        end
    end
    
    [lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);
    pcolor(lon_plot-res/2,lat_plot-res/2,data_grid) % have to shift lat/lon for pcolor with flat shading
    shading flat; hold on;
    clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res
end

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
   text(-123.85,43.75,{'Heceta';'Bank'},'fontsize',9); hold on
   text(-123.95,41.65,{'Trinidad';' Head'},'fontsize',9); hold on
end
xtickangle(0); hold on;    

if fprint==1
    exportgraphics(gca,[filepath 'Figs/' name '_sensor_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 