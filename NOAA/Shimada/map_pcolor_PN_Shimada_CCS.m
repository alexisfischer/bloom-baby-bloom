%% map pcolor PN data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
classidxpath = [filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1;
yr=2021; % 2019; 2021
option=1; % 1=Plot the individual data points; 2=Grid the data
load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],...
    'dt','lat','lon','class2useTB','cellsmL');
target='Pseudonitzschia'; dataformat='cells'; label={'Pseudo-nitzschia';'(cells ml^{-1})'}; cax=[0 50];
data=cellsmL(:,strcmp(target,class2useTB));

if yr==2019
    idx=find(dt<datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx);  
elseif yr==2021
    idx=find(dt>datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx);  
end

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 5]); 
if option==1
    scatter3(lon,lat,data,10,data,'filled'); 
    view(2); hold on
else
    % Set grid resolution (degrees)
    res = 0.2; % Coarser=0.2; Finer=0.1
    
    % Create grid
    lon_grid = min(lon):res:max(lon);
    lat_grid = min(lat):res:max(lat);
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
    colormap(parula); caxis(cax);
    axis([min(lon) max(lon) min(lat) max(lat)]);
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 12;               
    hp=get(h,'pos'); 
    hp=[1.9*hp(1) .9*hp(2) .4*hp(3) .6*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); 
    hold on    

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol.mat']);
load([filepath 'NOAA/Shimada/Data/coast_CCS.mat'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[34 49],'xlim',[-127 -120],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);
   
if fprint
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' target '_IFCB_Shimada' num2str(yr) '.png'],'Resolution',100)    
end
hold off 