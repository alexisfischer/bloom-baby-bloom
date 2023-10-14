%% map underway environmental data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2019; % 2019; 2021
option=2; % 1=Plot the individual data points; 2=Grid the data
fprint=0;

%%%% load in underway data
load([filepath 'NOAA/Shimada/Data/environ_Shimada' num2str(yr) ''],'DT','LON','LAT','TEMP','SAL','FL','PCO2');
data=TEMP; cax=[10 20]; label={'SST';'(^oC)'}; name='SST'; col=brewermap(256,'BuPu');xloc=-123.6;yloc=43.8;
%data=SAL; cax=[30 35]; label={'Salinity';'  (psu)'}; name='SAL'; col=parula;xloc=-124.2;yloc=43.5;
%data=PCO2; cax=[200 800]; label={'pCO_2';'(ppm)'}; name='PCO2'; col=brewermap(256,'RdPu');xloc=-123.9;yloc=43.8;

% remove Nans
idx=isnan(data); data(idx)=[]; LAT(idx)=[]; LON(idx)=[]; lon=LON; lat=LAT;

% remove data from the Strait
idx=find(lat>47.5 & lon>-124.7); lat(idx)=[]; lon(idx)=[]; data(idx)=[];

idx=find(lat<40); lat(idx)=[]; lon(idx)=[]; data(idx)=[];
%mean(data)
%std(data)

%col(1:30,:)=[];
%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 2.5 4]); 
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
    
    % % find difference between cells in the direction of longitude
    % front_grid=NaN*data_grid;
    % for i=1:size(data_grid,1)
    %     front_grid(i,2:end)=diff(data_grid(i,:));
    % end
    [lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);
    pcolor(lon_plot-res/2,lat_plot-res/2,data_grid) % have to shift lat/lon for pcolor with flat shading
    shading flat; hold on;
    clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res
end

    colormap(col); caxis(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);

    h=colorbar('south'); hp=get(h,'pos');     
    hp=[2.1*hp(1) hp(2) .3*hp(3) .6*hp(4)]; % [left, bottom, width, height].

%    h=colorbar('west'); hp=get(h,'pos');     
%    hp=[2.1*hp(1) hp(2) .6*hp(3) .32*hp(4)]; % [left, bottom, width, height].

    %h=colorbar('east'); hp=get(h,'pos');     
    %hp=[0.85*hp(1) 1*hp(2) .6*hp(3) .32*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','right','fontsize',9);
    hold on     

colorTitleHandle = get(h,'Title');
set(colorTitleHandle ,'String',label,'fontsize',10);

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-127.5 -123.],'xtick',-127:2:-122,'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
%set(gca,'ylim',[39.9 49],'xlim',[-126.6 -122.3],'xtick',-126:2:-121,'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);
text(-124,47.5,'WA','fontsize',11,'fontweight','bold'); hold on
text(-124,44,'OR','fontsize',11,'fontweight','bold'); hold on
text(-124,40.5,'CA','fontsize',11,'fontweight','bold'); hold on

if fprint==1
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_sensor_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 