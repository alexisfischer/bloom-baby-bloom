function [HA] = match_discrete_samples_2019_2021(HA)
%matches discrete samples between 2019 and 2021 Shimada data
%   requires mapping toolbox
%   input: HA, the discrete sample table
%   output: HA, with the variable "match", indicating a match (1) or not (0)

i19=HA.dt.Year==2019; H19=HA(i19,:); H21=HA(~i19,:);

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

save([filepath 'Shimada/Data/matched_discrete_samples_2019_2021.mat'],'HA');

end