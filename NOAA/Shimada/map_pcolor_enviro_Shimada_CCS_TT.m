%% plot matched up underway environmental data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2019; % 2019; 2021
option=2; % 1=Plot the individual data points; 2=Grid the data
fprint=0;

%%%% load in underway data
load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'TT');
lat=TT.LAT; lon=TT.LON; dt=TT.DT;

%data=TEMP; cax=[10 20]; label='SST (^oC)'; name='SST';
%data=TT.SAL; cax=[30 35]; label='Sal (psu)'; name='SAL';
%data=TT.PCO2; cax=[0 800]; label={'PCO2 (ppm)'}; name='PCO2';

% remove Nans
%idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[]; 

if yr==2019
    idx=find(dt<datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx);  
    %bndry=bndry19;
elseif yr==2021
    idx=find(dt>datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx); 
    %bndry=bndry21;    
end

col=brewermap(256,'BuPu'); col(1:30,:)=[];
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
    
    [lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);
    pcolor(lon_plot-res/2,lat_plot-res/2,data_grid) % have to shift lat/lon for pcolor with flat shading
    shading flat; hold on;
    clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res

end
    colormap(col); caxis(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('east'); h.Label.String = label;              
    hp=get(h,'pos');     
    hp=[0.93*hp(1) 2.4*hp(2) .6*hp(3) .32*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','left','fontsize',9); h.Label.FontSize = 11;  
    hold on     

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-127 -121.5],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);

if fprint==1
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_sensor_Shimada' num2str(yr) '.png'],'Resolution',100)    
end
hold off 