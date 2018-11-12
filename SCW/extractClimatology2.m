function [C] = extractClimatology2(var,dn,filepath,varname)
% Extracts Climatology for generic variables
%  Alexis D. Fischer, University of California - Santa Cruz, July 2018

%% fine for weekly data without mega gaps
i = ~isnan(var); t = var(i); dn = dn(i); %remove NaNs
t(t==-Inf)=0; %replace all -Inf with 0
DN=[dn(1):1:dn(end)]';
T = interp1(dn,t,DN);

%figure; plot(dn,t,'-k')
% %% for data with mega gaps
% t=var;
% %t(t<=0)=NaN;
% [ DN, T, ~, ~ ] = filltimeseriesgaps( dn, t );
% 
% %interpolate data unless gaps >___
% 
% index    = isnan(T);
% T(index) = interp1(find(~index), T(~index), find(index), 'linear');
% [b, n]     = RunLength(index);
% longRun    = RunLength(b & (n > 8), n);
% T(longRun) = NaN;

%% (1) Create a mean annual cycle by binning the time series into 14 day 
%bins spread over a calendar year and averaging each bin's contents 
[mdate_mat,y_mat,~,~] = timeseries2ydmat(DN,T);
Tmean = nanmean(y_mat,2); %average same day for all years

n = 7; % average every n values
t7d = arrayfun(@(i) nanmean(Tmean(i:i+n-1)),1:n:length(Tmean)-n+1)'; % the averaged vector
t7d = repmat(t7d,1,size(mdate_mat,2));
t7d = t7d(:);

dn7d = mdate_mat((1:n:end),:);
dn7d(27,:)=[];
dn7d = dn7d(:);

% ensure start and end of dates agrees with end of data
iEnd= find(dn7d >= DN(end),1);
dn7d=dn7d(1:iEnd); 
t7d=smooth(t7d(1:iEnd),10);

idx=find(dn7d >= DN(1),1);
dn7d=dn7d(idx:end);
t7d=t7d(idx:end);

%TT=interp1(dn7d,t7d,DN);

%figure; plot(DN,TT)

%% (2) Grid the time series at weekly intervals using Stineman (1980) interpolation

ti=stineman(DN,T,dn7d); ti=ti';
ti(end)=NaN;
i0=find(isnan(ti)); %find NaNs

%figure; plot(dn7d,t7d,'-b',dn7d,ti,'-r');

%% (3) Smooth the gridded series with a moving average 
ti37 =smooth(ti,37); ti37(i0) = NaN;
ti9 =smooth(ti,9); ti9(i0) = NaN;
ti3 =smooth(ti,3); ti3(i0) = NaN;

%% (4) Difference the gridded and smoothed bin values from the 
% corresponding mean annual cycle, thus creating an anomaly time series
tAnom = ti9-t7d;

%% Save the output file
C.dn=dn;
C.t=t;
C.dn7d=dn7d;
C.t7d=t7d;
C.ti3=ti3;
C.ti9=ti9;
C.ti37=ti37;
C.tAnom=tAnom;

save([filepath 'Data/Climatology_' varname],'C');

end