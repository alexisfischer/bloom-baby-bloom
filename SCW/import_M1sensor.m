%% import M1 data for particular years of interest
filepath='~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 

%% M1 1990-2016
in_dir='http://dods.mbari.org:80/opendap/data/OASISdata/netcdf/dailyAveragedM1.nc?';

depth=ncread([in_dir 'DEPTH_TS_HR[0:1:8]'],'DEPTH_TS_HR'); %degrees_north

time=ncread([in_dir 'TIME_DAY[0:1:9871]'],'TIME_DAY'); %units: days since 1901-01-15 00:00:00
dn=double(time) + datenum('1901-01-15 00:00:00');
   
U=ncread([in_dir 'WIND_U_COMPONENT_DAY[0:1:9871][0:1:0][0:1:0][0:1:0]'],'WIND_U_COMPONENT_DAY');
U=double(squeeze(U)); 

V=ncread([in_dir 'WIND_V_COMPONENT_DAY[0:1:9871][0:1:0][0:1:0][0:1:0]'],'WIND_V_COMPONENT_DAY');
V=double(squeeze(V)); 

temp  = ncread([in_dir 'TEMPERATURE_DAY[0:1:9871][0:1:8][0:1:0][0:1:0]'],'TEMPERATURE_DAY');
temp((temp==-9999))=NaN; %convert -9999 to NaNs
temp((temp==0))=NaN; %convert 0 to NaNs
temp=double(squeeze(temp))';  %invert these time series to make it easier to work with

salt  = ncread([in_dir 'SALINITY_DAY[0:1:9871][0:1:8][0:1:0][0:1:0]'],'SALINITY_DAY');
salt((salt==-9999))=NaN; %convert -9999 to NaNs
salt=(squeeze(salt))';

tfilt=NaN*ones(size(temp));
sfilt=NaN*ones(size(salt));
% low pass filter
for i=1:length(depth)
    tfilt(:,i)=pl33tn(temp(:,i)); 
    sfilt(:,i)=pl33tn(salt(:,i)); 
end
ufilt=pl33tn(U); 
vfilt=pl33tn(V); 

% fill gaps with NaNs
for i=1:length(depth)
    [ DN, T(:,i)] = filltimeseriesgaps( dn, tfilt(:,i) );
    [ ~, S(:,i)] = filltimeseriesgaps( dn, sfilt(:,i) );
end
    [ ~, U] = filltimeseriesgaps( dn, ufilt );
    [ ~, V] = filltimeseriesgaps( dn, vfilt );

%interpolate data unless gaps >4
TT=NaN(size(T));
for i=1:length(depth)
    x=T(:,i);
    index    = isnan(x);
    x(index) = interp1(find(~index), x(~index), find(index), 'linear');
    [b, n]     = RunLength(index);
    longRun    = RunLength(b & (n > 4), n);
    x(longRun) = NaN;
    TT(:,i)=x;
end

SS=NaN(size(S));
for i=1:length(depth)
    x=S(:,i);
    index    = isnan(x);
    x(index) = interp1(find(~index), x(~index), find(index), 'linear');
    [b, n]     = RunLength(index);
    longRun    = RunLength(b & (n > 4), n);
    x(longRun) = NaN;
    SS(:,i)=x;
end

index    = isnan(U);
U(index) = interp1(find(~index), U(~index), find(index), 'linear');
[b, n]     = RunLength(index);
longRun    = RunLength(b & (n > 4), n);
U(longRun) = NaN;

index    = isnan(V);
V(index) = interp1(find(~index), V(~index), find(index), 'linear');
[b, n]     = RunLength(index);
longRun    = RunLength(b & (n > 4), n);
V(longRun) = NaN;

% smooth data, avoid nans
TTT=NaN(size(T));
idx=~isnan(TT);
TTT(idx)=smooth(TT(idx),10);

SSS=NaN(size(S));
idx=~isnan(SS);
SSS(idx)=smooth(SS(idx),10);

%put in structure
for i=1:length(DN)
    M1(i).dn=DN(i);    
    M1(i).windU=U(i);
    M1(i).windV=V(i); 
    M1(i).Z=depth;
    M1(i).T=TTT(i,:)';
    M1(i).S=SSS(i,:)'; 
    M1(i).Zi =double((1:1:depth(end)))';            
end

%interpolate (avoiding the NaNs)
for i=1:length(M1)
    if ~isnan(M1(i).T(end)) 
        M1(i).Ti = (spline(M1(i).Z,M1(i).T,M1(i).Zi)); %cubic spline interpolation
    else           
        M1(i).Ti=NaN*ones(size(M1(1).Zi));          
    end

    if ~isnan(M1(i).S(end))
        M1(i).Si = (spline(M1(i).Z,M1(i).S,M1(i).Zi)); %cubic spline interpolation
    else   
        M1(i).Si=NaN*ones(size(M1(1).Zi));                      
    end    
    
end

%% find where dT from the surface exceeds 0.5ºC, aka the MLD

deep=max(M1(1).Zi);

for i=1:length(M1)
    if ~isnan(M1(i).Ti)        
    for j=1:length(M1(i).Ti)
       M1(i).diff(j)=abs(diff([M1(i).Ti(1) M1(i).Ti(j)]));
    end
    end
end


for i=1:length(M1)
    
    if ~isnan(M1(i).Ti)        
    M1(i).dTdz=abs(diff(M1(i).Ti))';   
    M1(i).dTdz=(M1(i).dTdz)';  
    M1(i).diff=M1(i).diff';    
        
    M1(i).mld5=M1(i).Zi(find(M1(i).diff > 0.5,1));
    M1(i).mld5(isempty(M1(i).mld5))=deep; %replace with deepest depth if empty    
    [M1(i).maxdTdz,idx]=max(M1(i).dTdz);
    M1(i).Zmax=M1(i).Zi(idx);   
    M1(i).Tmax=M1(i).Ti(idx);    

    else      
        M1(i).diff = NaN*ones(size(M1(1).Zi));   
        M1(i).mld5=NaN;
        M1(i).dTdz=NaN*ones(length(M1(1).Zi)-1,1); 
        M1(i).maxdTdz=NaN;        
        M1(i).Zmax=NaN;
        M1(i).Tmax=NaN;
    
    end
    
end

% i=~isnan([M1.mld5]');
% 
% mld5(i)=smooth(medfilt(medfilt(medfilt([M1(i).mld5]))),9);
% maxdTdz(i)=smooth(medfilt(medfilt(medfilt([M1(i).maxdTdz]))),9);
% Zmax(i)=smooth(medfilt(medfilt(medfilt([M1(i).Zmax]))),9);
% Tmax(i)=smooth(medfilt(medfilt(medfilt([M1(i).Tmax]))),9);
% 
% for i=1:length(M1)
%     M1(i).mld5=mld5(i);
%     M1(i).maxdTdz=maxdTdz(i);
%     M1(i).Zmax=Zmax(i);
%     M1(i).Tmax=Tmax(i);
%     
% end 

clearvars b deep depth dn DN i idx in_dir index j longRun n S salt sfilt...
    SS SSS T temp tfilt time TT TTT U V x xx y;

%% match up with ROMs data
filepath='~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD'],'ROMS');

% match up ROMS data with M1 data so don't overlap
idx = find([ROMS.dn]>=[M1(end).dn],1); %id for where the points overlap

dn = [[M1.dn]'; [ROMS(idx:end).dn]'];   
Ti = [[M1.Ti]'; [ROMS(idx:end).Ti]'];   
Si = [[M1.Si]'; [ROMS(idx:end).Si]'];   
mld5 = [[M1.mld5]'; [ROMS(idx:end).mld5]'];   
dTdz = [[M1.dTdz]'; [ROMS(idx:end).dTdz]'];   
maxdTdz = [[M1.maxdTdz]'; [ROMS(idx:end).maxdTdz]'];   
Zmax = [[M1.Zmax]'; [ROMS(idx:end).Zmax]'];   
Tmax = [[M1.Tmax]'; [ROMS(idx:end).Tmax]'];   

for i=1:length(dn)
    M1R(i).dn=dn(i);
    M1R(i).Zi=M1(1).Zi; %same depth for all  
    M1R(i).Ti=(Ti(i,:))';
    M1R(i).Si=(Si(i,:))';

    M1R(i).dTdz=(dTdz(i,:))';    
    M1R(i).maxdTdz=(maxdTdz(i));    
    M1R(i).Zmax=(Zmax(i));    
    M1R(i).Tmax=(Tmax(i));    
    M1R(i).mld5=(mld5(i));  
end

%%
save([filepath 'Data/M1_TS'],'M1','M1R');
