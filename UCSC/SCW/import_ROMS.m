%% import ROMS data for particular years of interest

%% ROMS Monterey Bay Nowcast (1km): 31 Aug 2010 - 11 Jan 2013
%SCW 36.9573°N, -122.0173°W
in_dir='http://thredds.cencoos.org/thredds/dodsC/MB_DAS.nc?';

lat=ncread([in_dir 'lat[132]'],'lat'); %degrees_north
lon=ncread([in_dir 'lon[75]'],'lon'); %degrees_east
depth=ncread([in_dir 'depth[0:1:7]'],'depth'); %degrees_north
depth(1)=1;

time=ncread([in_dir 'time[0:1:3364]'],'time'); % convert time from ISO String format to typical numerical type
dn=NaN*ones(length(time),1);
for i=1:length(dn)
    tt=time(1:20,i)';
    dn(i) = datenum(datetime(tt,'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z'));
end
    
temp  = ncread([in_dir 'temp[0:1:3364][0:1:7][132][75]'],'temp');
temp((temp==-9999))=NaN; temp((temp==0))=NaN; 
temp=double(squeeze(temp))';  %invert these time series to make it easier to work with

salt  = ncread([in_dir 'salt[0:1:3364][0:1:7][132][75]'],'salt');
salt((salt==-9999))=NaN; salt((salt==0))=NaN;
salt=double(squeeze(salt))'; %invert these time series to make it easier to work with

% take daily average and fill gaps with NaNs
for i=1:length(depth)
    [ DN, T(:,i)] = filltimeseriesgaps( dn, temp(:,i) );
    [ ~, S(:,i)] = filltimeseriesgaps( dn, salt(:,i) );
end

%interpolate data unless gaps >3
TT=NaN(size(T));
for i=1:length(depth)
    x=T(:,i);
    index    = isnan(x);
    x(index) = interp1(find(~index), x(~index), find(index), 'linear');
    [b, n]     = RunLength(index);
    longRun    = RunLength(b & (n > 3), n);
    x(longRun) = NaN;
    TT(:,i)=x;
end

SS=NaN(size(S));
for i=1:length(depth)
    x=S(:,i);
    index    = isnan(x);
    x(index) = interp1(find(~index), x(~index), find(index), 'linear');
    [b, n]     = RunLength(index);
    longRun    = RunLength(b & (n > 3), n);
    x(longRun) = NaN;
    SS(:,i)=x;
end

% smooth data, avoid nans
TTT=NaN(size(TT)); idx=~isnan(TT); TTT(idx)=smooth(TT(idx),10);
SSS=NaN(size(SS)); idx=~isnan(SS); SSS(idx)=smooth(SS(idx),10);

%put in structure
for i=1:length(DN)
    MB(i).dn=DN(i);    
    MB(i).lat=lat;
    MB(i).lon=lon; 
    MB(i).Z=double(depth);
    MB(i).T=double(TTT(i,:))';
    MB(i).S=double(SSS(i,:))'; 
    MB(i).Zi =double((1:1:depth(end)))';            
end

%interpolate (avoiding the NaNs)
for i=1:length(MB)
     if ~isnan(MB(i).T)
        MB(i).Ti = double(spline(MB(i).Z,MB(i).T,MB(i).Zi));
     else    
         MB(i).Ti=NaN*ones(size(MB(1).Zi));                   
     end
     if ~isnan(MB(i).S)
        MB(i).Si = double(spline(MB(i).Z,MB(i).S,MB(i).Zi));
     else    
         MB(i).Si=NaN*ones(size(MB(1).Zi));  
     end    
end

clearvars depth salt temp dn i lat lon s SSS TTT t tt tfilt sfilt time T S DN DNN idx ii longRun x TT SS index;

%% California ROMS Nowcast (3km): 31 July 2012 - 31 Dec 2018
in_dir='http://thredds.cencoos.org/thredds/dodsC/CENCOOS_CA_ROMS_DAS.nc?';

lat=ncread([in_dir 'lat[187]'],'lat'); %degrees_north
lon=ncread([in_dir 'lon[181]'],'lon'); %degrees_east
lon=lon-360; %degrees_west
depth  = ncread([in_dir 'depth[0:1:5]'],'depth');
depth(1)=1; %replace 0 with 1
time=ncread([in_dir 'time[1:1:9200]'],'time'); %units: hours since 1970-01-01 00:00:00 UTC
dn=double(time)/24 + datenum('1970-01-01 00:00:00'); %7 hrs ahead of PT
clearvars time

temp = ncread([in_dir 'temp[1:1:9200][0:1:5][187][181]'],'temp');
temp((temp==-9999))=NaN; temp=(squeeze(temp))';
salt  = ncread([in_dir 'salt[1:1:9200][0:1:5][187][181]'],'salt');
salt((salt==-9999))=NaN; salt=(squeeze(salt))';

% remove messed up 11 Apr 2018 datapoint
id=find(dn==datenum('11-Apr-2018 09:00:00'));
temp(id,:)=[]; salt(id,:)=[]; dn(id)=[];

% take daily average and fill gaps with NaNs
for i=1:length(depth)
    [ DN, T(:,i)] = filltimeseriesgaps( dn, temp(:,i) );
    [ ~, S(:,i)] = filltimeseriesgaps( dn, salt(:,i) );
end

% make temporary data for 10 Aug - 02 Sep 2018 datagap
id=find(DN>=datenum('10-Aug-2018') & DN<=datenum('03-Sep-2018'));
nid=(id(1)-length(id):id(1)-1)';
for j=1:length(id)
    T(id(j),:)=T(nid(j),:);
    S(id(j),:)=S(nid(j),:);       
end
    
% interpolate data unless gaps >3
TT=NaN(size(T));
for i=1:length(depth)
    x=T(:,i);
    index    = isnan(x);
    x(index) = interp1(find(~index), x(~index), find(index), 'linear');
    [b, n]     = RunLength(index);
    longRun    = RunLength(b & (n > 3), n);
    x(longRun) = NaN;
    TT(:,i)=x;
end

SS=NaN(size(S));
for i=1:length(depth)
    x=S(:,i);
    index    = isnan(x);
    x(index) = interp1(find(~index), x(~index), find(index), 'linear');
    [b, n]     = RunLength(index);
    longRun    = RunLength(b & (n > 3), n);
    x(longRun) = NaN;
    SS(:,i)=x;
end

%smooth data, avoid nans
TTT=NaN(size(TT)); idx=~isnan(TT); TTT(idx)=smooth(TT(idx),10);
SSS=NaN(size(SS)); idx=~isnan(SS); SSS(idx)=smooth(SS(idx),10);

%put in structure
for i=1:length(DN)
    CA(i).dn=DN(i);    
    CA(i).lat=lat;
    CA(i).lon=lon; 
    CA(i).Z=double(depth);
    CA(i).T=double(TTT(i,:))';
    CA(i).S=double(SSS(i,:))'; 
    CA(i).Zi =double((1:1:depth(end)))';            
end

%interpolate (avoiding the NaNs)
for i=1:length(CA)
     if ~isnan(CA(i).T)
        CA(i).Ti = double(spline(CA(i).Z,CA(i).T,CA(i).Zi));
     else    
         CA(i).Ti=NaN*ones(size(CA(1).Zi));                   
     end
     if ~isnan(CA(i).S)
        CA(i).Si = double(spline(CA(i).Z,CA(i).S,CA(i).Zi));
     else    
         CA(i).Si=NaN*ones(size(CA(1).Zi));  
     end   
end

clearvars depth salt temp dn i lat lon s t tt tfilt sfilt time T TTT S SSS DN DNN idx ii longRun x TT SS index b n var;

%% match up CA data with Monterey bay ROMS so don't overlap
idx = find([CA.dn]>=[MB(end).dn],1); %id for where the points overlap

dn = [[MB.dn]'; [CA(idx:end).dn]'];   
lat = [[MB.lat]'; [CA(idx:end).lat]'];   
lon = [[MB.lon]'; [CA(idx:end).lon]'];   
Ti = [[MB.Ti]'; [CA(idx:end).Ti]'];   
Si = [[MB.Si]'; [CA(idx:end).Si]'];   

for i=1:length(dn)
    ROMS(i).dn=dn(i);
    ROMS(i).lat=double(lat(i));
    ROMS(i).lon=double(lon(i));
    ROMS(i).Zi=MB(1).Zi; %same depth for all  
    ROMS(i).Ti=double(Ti(i,:))';
    ROMS(i).Si=double(Si(i,:))';    
end

% find where dT from the surface exceeds 0.5ºC, aka the MLD
deep=max(ROMS(1).Zi);
for i=1:length(ROMS)
    if ~isnan(ROMS(i).Ti)        
    for j=1:length(ROMS(i).Ti)
       ROMS(i).diff(j)=abs(diff([ROMS(i).Ti(1) ROMS(i).Ti(j)]));
    end
    end
end

for i=1:length(ROMS) 
    if ~isnan(ROMS(i).Ti)        
    ROMS(i).dTdz=abs(diff(ROMS(i).Ti))';   
    ROMS(i).dTdz=(ROMS(i).dTdz)';  
    ROMS(i).diff=ROMS(i).diff';         
    ROMS(i).mld5=ROMS(i).Zi(find(ROMS(i).diff > 0.5,1));
    ROMS(i).mld5(isempty(ROMS(i).mld5))=deep; %replace with deepest depth if empty    
    [ROMS(i).maxdTdz,idx]=max(ROMS(i).dTdz);
    ROMS(i).Zmax=ROMS(i).Zi(idx);   
    ROMS(i).Tmax=ROMS(i).Ti(idx);    
    else      
        ROMS(i).diff = NaN*ones(size(ROMS(1).Zi));   
        ROMS(i).mld5=NaN;
        ROMS(i).dTdz=NaN*ones(length(ROMS(1).Zi)-1,1); 
        ROMS(i).maxdTdz=NaN;        
        ROMS(i).Zmax=NaN;
        ROMS(i).Tmax=NaN; 
    end
end

mld5=smooth(medfilt(medfilt(medfilt([ROMS.mld5]))),9);
maxdTdz=smooth(medfilt(medfilt(medfilt([ROMS.maxdTdz]))),9);
Zmax=smooth(medfilt(medfilt(medfilt([ROMS.Zmax]))),9);
Tmax=smooth(medfilt(medfilt(medfilt([ROMS.Tmax]))),9);

for i=1:length(ROMS)
    ROMS(i).mld5=mld5(i);
    ROMS(i).maxdTdz=maxdTdz(i);
    ROMS(i).Zmax=Zmax(i);
    ROMS(i).Tmax=Tmax(i);
    
end 

% calculate Brunt-Väisälä frequency
p=sw_pres(ROMS(1).Zi,ROMS(1).lat); % convert depth (m) to pressure (dbar)
for i=1:length(ROMS)
    ROMS(i).CT = gsw_CT_from_t( ROMS(i).Si, ROMS(i).Ti, p ); %calculate Conservative Temperature 
    [ROMS(i).N2, ~] = gsw_Nsquared( ROMS(i).Si, ROMS(i).CT, p, ROMS(1).lat );
    ROMS(i).N2 = smooth(ROMS(i).N2,10); %10 pt running average as in Graff & Behrenfeld 2018 and log transform
    ROMS(i).logN2=log10(abs(ROMS(i).N2));
end

%%
filepath='~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
save([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS','CA','MB');
