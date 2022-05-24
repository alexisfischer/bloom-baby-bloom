
% Load data
filepath = '~/Desktop/Fischer/';
load([filepath 'testdata.mat'],'data','lat','lon');

% OPTION 1: Plot the individual data points
figure,set(gcf,'color','w','position',[100 100 400 500])
scatter3(lon,lat,data,10,data,'filled')
view(2)
caxis([0 70])
colorbar
axis([min(lon) max(lon) min(lat) max(lat)])

% OPTION 2: Grid the data
% Set grid resolution (degrees)
% Coarser resolution (e.g., res = 0.2) will give fewer gaps
res = 0.2;

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

% Plot
figure,set(gcf,'color','w','position',[100 100 400 500])
[lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);
pcolor(lon_plot-res/2,lat_plot-res/2,data_grid) % have to shift lat/lon for pcolor with flat shading
shading flat
caxis([0 70])
colorbar
axis([min(lon) max(lon) min(lat) max(lat)])
    
