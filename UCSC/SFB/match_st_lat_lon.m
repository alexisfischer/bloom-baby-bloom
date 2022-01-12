function [Latitude,Longitude,D19] = match_st_lat_lon(stdata)
%inputs random SFB station data (stdata) and attaches lat long coordinates

filepath='~/MATLAB/bloom-baby-bloom/SFB/Data/';
addpath(genpath(filepath)); % add new data to search path

load([filepath 'st_lat_lon_distance'],'d19','st','lat','lon');

Latitude=NaN*stdata;
Longitude=NaN*stdata;
D19=NaN*stdata;

for i=1:length(stdata)
    for j=1:length(st)
        if stdata(i) == st(j)
            Latitude(i) = lat(j);
            Longitude(i) = lon(j);   
            D19(i) = d19(j);   
        else
        end
    end
end

end

