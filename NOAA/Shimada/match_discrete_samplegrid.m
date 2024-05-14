%% match up discrete samples in 2019 and 2021, so same grid
%needs mapping toolbox

clear; 
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%% load in discrete data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
HA((HA.lat<40),:)=[]; %remove CA stations
HA(isnan(HA.lon),:)=[];
i19=HA.dt<datetime('01-Jan-2020'); H19=HA(i19,:); H21=HA(~i19,:);

%%%% find index of 2019 data closest to 2021
gap=NaN*H21.lat; %preallocate
idx=NaN*H21.lat; %preallocate
for i=1:length(idx)
    [val,idx(i)] = min(distance(H21.lat(i),H21.lon(i),H19.lat,H19.lon)); %find location the minimum distance
    gap(i) = deg2km(val); %convert to km
end

H19.match=0*H19.lat;
H21.match=ones(size(idx));
for i=1:length(idx)
    H19.match(idx(i))=1;
end

H21.match(H21.lat<42)=0;
HA=[H19;H21];
HA.match=logical(HA.match);

save([filepath 'NOAA/Shimada/Data/matched_discrete_samples_2019_2021.mat'],'HA');
