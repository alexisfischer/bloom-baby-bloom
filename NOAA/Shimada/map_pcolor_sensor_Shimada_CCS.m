%% map underway environmental data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2021; % 2019; 2021
option=2; % 1=Plot the individual data points; 2=Grid the data
leftsubplot=0; %special formatting for the leftmost subplot
fprint=0;

%%%% load in underway data
load([filepath 'NOAA/Shimada/Data/environ_Shimada' num2str(yr) ''],'DT','LON','LAT','TEMP','SAL','FL','PCO2');
data=TEMP; cax=[10 20];  ticks=10:5:20; label={'SST (^oC)'}; name='SST'; col=brewermap(256,'BuPu');
%data=SAL; cax=[30 35]; ticks=[30,32,35]; label={'SSS (psu)'}; name='SAL'; col=parula;
%data=PCO2; cax=[200 800]; ticks=200:600:800; label={'pCO_2 (ppm)'}; name='PCO2'; col=brewermap(256,'RdPu');

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
    % Set grid resolution (degrees)
    res = 0.15; % Coarser=0.2; Finer=0.1
    
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

    colormap(col); caxis(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('northoutside','xtick',ticks); hp=get(h,'pos');    
    set(h,'pos',hp,'xaxisloc','top','fontsize',9,'tickdir','out');
    xtickangle(0); hold on;    
    hold on     

colorTitleHandle = get(h,'Title');
set(colorTitleHandle,'String',label,'fontsize',11);

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); 
dasp(42); hold on;
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
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_sensor_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 