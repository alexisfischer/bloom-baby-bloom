function [C] = extractClimatology_v1(var,dn,filepath,varname,n,gap)
%% Extracts Climatology for generic variables
%  Alexis D. Fischer, University of California - Santa Cruz, July 2018
% 
idx = strmatch(varname,'Dinoflagellate Chl'); %classifier index
if idx == 1
    var(var<0)=NaN; 
    i0=find(dn>=datenum('01-Jan-2004'),1); 
    dn=dn(i0:end); var=var(i0:end); 
else
end

i0=find(~isnan(var),1);
dn=dn(i0:end); var=var(i0:end); 

[t] = interp1babygap(var,gap);

%figure; plot(dn,t,'-r'); datetick;

%% (1) Create a mean annual cycle by binning the time series into 14 day 
%bins spread over a calendar year and averaging each bin's contents 
[mdate_mat,y_mat,~,~] = timeseries2ydmat(dn,t);
Tmean = nanmean(y_mat,2); %average same day for all years

t14d = arrayfun(@(i) nanmean(Tmean(i:i+n-1)),1:n:length(Tmean)-n+1)'; % the averaged vector
t14d = repmat(t14d,1,size(mdate_mat,2));
t14d = t14d(:);
t14d=smooth(t14d,8);

dn14d = mdate_mat((1:n:end),:);
dn14d(27,:)=[];
dn14d = dn14d(:);

if dn(1) > dn14d(1)
    id=find(dn14d>=dn(1),1);
    dn14d=dn14d(id:end);
    t14d=t14d(id:end);
else
end

%figure; plot(dn14d,t14d,'-b'); datetick;

%% (2) Grid the time series at 14day intervals using Stineman (1980) interpolation
ti=stineman(dn,t,dn14d); ti=ti';
i0=find(isnan(ti)); %find NaNs

%figure; plot(dn14d,t14d,'-b',dn14d,ti,'-r'); datetick;

%% (3) Smooth the gridded series with a moving average 
ti37 =smooth(ti,37); 
ti9 =smooth(ti,9);
ti3 =smooth(ti,3); 

%% (4) Difference the gridded and smoothed bin values from the 
% corresponding mean annual cycle, thus creating an anomaly time series
tA =ti9-t14d;

tA(i0) = NaN;
ti37(i0) = NaN; % put the NaNs back
ti9(i0) = NaN;
ti3(i0) = NaN;

tAnom=normalize(tA);

%figure; plot(dn14d,ti9); datetick;

%% Save the output file
C.dn=dn;
C.t=t;
C.dn14d=dn14d;
C.t14d=t14d;
C.ti3=ti3;
C.ti9=ti9;
C.ti37=ti37;
C.tAnom=tAnom;

save([filepath 'Data/Climatology_' varname],'C');

end