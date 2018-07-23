function [dn,t,dn14d,t14d,ti3,ti9,tAnom] = extractClimatology(var,SC)
% Extracts Climatology for generic variables
%  Alexis D. Fischer, University of California - Santa Cruz, July 2018

% temperature, chlorophyll, fxDino, or fx diat
i = ~isnan(var); t = smooth(var(i),2); dn = SC.dn(i); %remove NaNs
t(t==-Inf)=0; %replace all -Inf with 0
DN=[dn(1):1:dn(end)]';
T = interp1(dn,t,DN);

%% (1) Create a mean annual cycle by binning the time series into 14 day 
%bins spread over a calendar year and averaging each bin's contents 
[mdate_mat,y_mat,~,~] = timeseries2ydmat(DN,T);
Tmean = nanmean(y_mat,2); %average same day for all years

n = 14; % average every n values
t14d = arrayfun(@(i) nanmean(Tmean(i:i+n-1)),1:n:length(Tmean)-n+1)'; % the averaged vector
t14d = repmat(t14d,1,size(mdate_mat,2));
t14d = t14d(:);

dn14d = mdate_mat((1:14:end),:);
dn14d(27,:)=[];
dn14d = dn14d(:);

% ensure end of dates agrees with end of data
iEnd= find(dn14d >= DN(end),1);
dn14d=dn14d(1:iEnd); 
t14d=t14d(1:iEnd);

%% (2) Grid the time series at 14day intervals using Stineman (1980) interpolation
ti=stineman(DN,T,dn14d); ti=ti';
ti(ti==0)=NaN;
i0=find(isnan(ti)); %find zeros elements

%% (3) Smooth the gridded series with a 9 point (126 day) moving average 
ti9 =smooth(ti,9); ti9(i0) = NaN;
ti3 =smooth(ti,3); ti3(i0) = NaN;

%% (4) Difference the gridded and smoothed bin values from the 
% corresponding mean annual cycle, thus creating an anomaly time series
tAnom = ti9-t14d;

end