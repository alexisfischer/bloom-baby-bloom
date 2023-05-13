%% map pcolor PN data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
classidxpath = [filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1;
yr=2021; % 2019; 2021
option=2; % 1=Plot the individual data points; 2=Grid the data
res = 0.15; % Coarser=0.2; Finer=0.1 % Set grid resolution (degrees)

%load([filepath 'NOAA/Shimada/Data/samplingboundary_Shimada'],'bndry19','bndry21');
load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
lat=P.LAT; lon=P.LON; dt=P.DT;
data=P.Pseudonitzschia; label={'   log';'PN/mL'}; cax=[0 2]; 

col=brewermap(256,'OrRd'); col(1:30,:)=[];
if yr==2019
    idx=find(dt<datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx);  
    %bndry=bndry19;
elseif yr==2021
    idx=find(dt>datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx); 
    %bndry=bndry21;    
end

logdata=log10(data);
%%%% plot
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 2.5 4]); 

if option==1
    scatter3(lon,lat,logdata,10,logdata,'filled'); view(2); hold on

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
            data_grid(ii,jj) = mean(logdata(lon>=lon_grid(ii)-res/2 & lon<lon_grid(ii)+res/2 & lat>=lat_grid(jj)-res/2 & lat<lat_grid(jj)+res/2),'omitnan');
        end
    end    
    [lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);
    h=pcolor(lon_plot-res/2,lat_plot-res/2,data_grid); % have to shift lat/lon for pcolor with flat shading     
    shading flat; hold on;
  %  set(h,'EdgeColor',[.3 .3 .3],'linewidth',.5)
    clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res
end 

   % plot(bndry.lon,bndry.lat,'color',col(end,:));   hold on;     
    colormap(col); caxis(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('east');             
    hp=get(h,'pos');     
    hp=[0.83*hp(1) 1*hp(2) .6*hp(3) .32*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','left','fontsize',9);
    hold on    

    % Plot map
    states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
    load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
    fillseg(coast); dasp(42); hold on;
    plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-126.6 -122.3],'xtick',-126:2:-121,'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',11);
text(-124,43.7,label,'fontsize',11); hold on

if fprint
    exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/Psuedo-nitzschia_Shimada' num2str(yr) '.png'],'Resolution',100)    
end
hold off 
