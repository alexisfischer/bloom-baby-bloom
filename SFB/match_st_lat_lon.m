function [Latitude,Longitude] = match_st_lat_lon(stdata)
%inputs random SFB station data (stdata) and attaches lat long coordinates

load ('st_lat_lon.mat','st','lat','lon');

Latitude=zeros*stdata;
Longitude=zeros*stdata;

for i=1:length(stdata)
    for j=1:length(st)
        if stdata(i) == st(j)
            Latitude(i) = lat(j);
            Longitude(i) = lon(j);    
        else
        end
    end
end

end

