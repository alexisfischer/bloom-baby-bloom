function coastline_SFB(varargin)
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SFB/';

load([filepath 'Data/SFB_bathymetry.mat'], 'lon', 'lat', 'bathy')
[C,h] = contour(lon, lat, bathy, [0,0], varargin{:});


% bmask = ones(size(bathy));
% bmask(bathy>=10) = nan;
% pcolor(lon, lat, bmask);
% colormap(gray)
% shading flat


