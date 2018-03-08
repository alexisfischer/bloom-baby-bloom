data = importdata('mhhw1k.asc',' ',7);
d = data.data;
%d(d==-9999) = -1;

x = (0:788)*100 + 531320.83645285;
y = (881:-1:0)*100 + 4142047.4765937;

x_grid = ones(882,1)*x;
y_grid = y'*ones(1,789);

lat = nan(size(x_grid));
lon = nan(size(x_grid));
[lat(:),lon(:)] = utm2deg(x_grid(:), y_grid(:), char(ones(numel(x_grid),1)*'10 N'));

figure
contour(lon, lat, d, [0,0])
bathy = d;
save('Data/SFB_bathymetry.mat', 'lon', 'lat', 'bathy')

%%
% ncols         789
% nrows         882
% xllcorner     531320.83645285
% yllcorner     4142047.4765937
% cellsize      100
% cellvalue     0.01
% NODATA_value  -9999

