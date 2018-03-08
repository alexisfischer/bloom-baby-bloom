function coastline_SFB(varargin)

load('C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\SFB_bathymetry.mat', 'lon', 'lat', 'bathy')
[C,h] = contour(lon, lat, bathy, [0,0], varargin{:});

% bmask = ones(size(bathy));
% bmask(bathy>=0) = nan;
% pcolor(lon, lat, bmask);
% colormap(gray)
% shading flat
