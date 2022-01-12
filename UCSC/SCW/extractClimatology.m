function [C] = extractClimatology(var,dn,filepath,varname,n,gap)
%% Extracts Climatology for generic variables
% following the methods of Pennington et al. 2017 and Fischer et al. 2020

%  Alexis D. Fischer, University of California - Santa Cruz, July 2018 

%Example inputs
% var = SC.NPGO; %variable time series
% dn = dn; %datenum that corresponds to var
% filepath = '~/MATLAB/bloom-baby-bloom/SCW/'; %filepath for output structure to be saved to
% varname = 'NPGO'; %name of variable for output filename
% n = 14; %climatology interval (days)
% gap = 30; %maximum gap size (days) over which data interpolation should occur. Set to 0 if you don't want any interpolation to occur.
%
% gap=10; 
% n=14;
% var= C2.temp; 
% dn=datenum(C2.dt); 
% varname = 'C2';

%% (1) interpolates timeseries gaps of a pre-specified size 

i0=find(~isnan(var),1); dn=dn(i0:end); var=var(i0:end); %i0 = placeholder for existing NaNs
[t] = interp1babygap(var,gap);

%figure; plot(dn,t,'-r'); datetick('x','yy');

%% (2) Create a mean annual cycle by binning the time series into 14 day 
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

% constrain dn14d t14d to the same length as original timeseries
% id0=find(dn14d>=dn(1),1);
% dn14d(1:id0)=[]; t14d(1:id0)=[];
% 
% idend=find(dn14d>=dn(end),1);
% dn14d(idend:end)=[]; t14d(idend:end)=[];

%figure; plot(dn14d,t14d,'-b'); datetick('x','yy');

%% (3) Grid the time series at 14 day intervals using Stineman (1980) interpolation
ti=stineman(dn,t,dn14d); ti=ti';
i0=find(isnan(ti)); %find NaNs

%figure; plot(dn14d,t14d,'-b',dn14d,ti,'-r'); datetick('x','yy');

%% (4) Smooth the gridded series with a moving average

ti37 =smooth(ti,37); %37 pt
ti9 =smooth(ti,9); %9 pt
ti3 =smooth(ti,3); %3 pt

%% (5) Creates anomaly time series by finding the difference between
% the gridded and smoothed bin values from the corresponding mean annual cycle

tA =ti9-t14d;

tA(i0) = NaN; ti37(i0) = NaN; ti9(i0) = NaN; ti3(i0) = NaN; % put the original NaNs back

tAnom=normalize(tA);

%figure; plot(dn14d,tAnom); datetick('x','yy');

%% (6) Save the output file
C.dn=dn; %dates for corresponding raw data
C.t=t; %raw data
C.dn14d=dn14d; %dates for corresponding annual climatology
C.t14d=t14d; %annual climatology
C.ti3=ti3; %3pt gridded smoothed series
C.ti9=ti9; %9pt gridded smoothed series
C.ti37=ti37; %37pt gridded smoothed series
C.tAnom=tAnom; %anomaly time series

save([filepath 'Data/Climatology_' varname],'C');

end