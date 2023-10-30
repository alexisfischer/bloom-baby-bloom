filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));


%% find distance between each data point
T.kmi=NaN*T.Silicate_uM;
wgs84 = wgs84Ellipsoid; 

for i=1:length(idx)
    T.kmi(i)=distance(T.LAT(i),T.LON(i),T.LAT(i+1),T.LON(i+1),wgs84);
end