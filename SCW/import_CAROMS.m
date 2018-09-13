%% import ROMS data for particular years of interest
out_dir='~/Documents/MATLAB/bloom-baby-bloom/SCW/Data/ROMS/SCW_ROMS_TS_MLD'; %change for whatever year

%% ROMS Monterey Bay Nowcast (1km) 2010-2013
%SCW 36.9573°N, -122.0173°W
in_dir='http://thredds.cencoos.org/thredds/dodsC/MB_DAS.nc?';
var='depth[0:1:7],lat[132],lon[75],temp[0:1:3364][0:1:7][132][75],salt[0:1:3364][0:1:7][132][75],time[0:1:3364]';

lat=ncread([in_dir var],'lat'); %degrees_north
lon=ncread([in_dir var],'lon'); %degrees_east
depth=ncread([in_dir var],'depth'); %degrees_north

time=ncread([in_dir var],'time'); % convert time from ISO String format to typical numerical type
dn=NaN*ones(length(time),1);
for i=1:length(dn)
    tt=time(1:20,i)';
    dn(i) = datenum(datetime(tt,'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z'));
end
    
temp  = ncread([in_dir var],'temp');
temp((temp==-9999))=NaN; %convert -9999 to NaNs
temp((temp==0))=NaN; %convert 0 to NaNs
temp=double(squeeze(temp))';

salt  = ncread([in_dir var],'salt');
salt((salt==-9999))=NaN; %convert -9999 to NaNs
salt((salt==0))=NaN; %convert 0 to NaNs
salt=double(squeeze(salt))';

tfilt=NaN*ones(size(temp));
sfilt=NaN*ones(size(salt));

% low pass filter
for i=1:length(depth)
    tfilt(:,i)=pl33tn(temp(:,i)); 
    sfilt(:,i)=pl33tn(salt(:,i)); 
end

% fill gaps with NaNs
for i=1:length(depth)
    [ DN, T(:,i), ~, ~ ] = filltimeseriesgaps( dn, tfilt(:,i) );
    [ ~, S(:,i), ~, ~ ] = filltimeseriesgaps( dn, sfilt(:,i) );
end

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

% put in structure
for i=1:length(DN)
    MB(i).dn=DN(i);    
    MB(i).lat=lat;
    MB(i).lon=lon; 
    MB(i).Z=depth;
    MB(i).T=TT(i,:);
    MB(i).S=SS(i,:); 
    MB(i).Zi =double(0:1:depth(end))';        
end


%interpolate over depths (avoiding the NaNs)
for i=1:length(MB)
    if MB(i).T == 0   
        MB(i).T=NaN*ones(size(MB(1).T));  
        MB(i).Ti=NaN*ones(size(MB(1).Zi));          
    elseif isnan(MB(i).T)
        MB(i).Ti=NaN*ones(size(MB(1).Zi));                  
    else    
    MB(i).Ti = double(spline(MB(1).Z,MB(i).T,MB(1).Zi)); %cubic spline interpolation
    end

    if MB(i).S == 0   
        MB(i).S=NaN*ones(size(MB(1).S));  
        MB(i).Si=NaN*ones(size(MB(1).Zi));          
    elseif isnan(MB(i).S)
        MB(i).Si=NaN*ones(size(MB(1).Zi));                  
    else    
    MB(i).Si = double(spline(MB(1).Z,MB(i).S,MB(1).Zi)); %cubic spline interpolation
    end    
    
end

clearvars depth salt temp dn i lat lon s t tt tfilt sfilt time T S DN DNN idx ii longRun x TT SS index;

%% California ROMS Nowcast (3km) 2012-present
%SCW 36.9573°N, -122.0173°W

in_dir='http://thredds.cencoos.org/thredds/dodsC/CENCOOS_CA_ROMS_DAS.nc?';
var='depth[0:1:5],lat[187],lon[181],temp[0:1:8056][0:1:5][187][181],salt[0:1:8056][0:1:5][187][181],time[0:1:8056]';
lat=ncread([in_dir var],'lat'); %degrees_north
lon=ncread([in_dir var],'lon'); %degrees_east
lon=lon-360; %degrees_west
depth  = ncread([in_dir var],'depth');
time=ncread([in_dir var],'time'); %units: hours since 1970-01-01 00:00:00 UTC
dn=double(time)/24 + datenum('1970-01-01 00:00:00'); %7 hrs ahead of PT
clearvars time

temp = ncread([in_dir var],'temp');
temp((temp==-9999))=NaN; %convert -9999 to NaNs
temp=(squeeze(temp))';

salt  = ncread([in_dir var],'salt');
salt((salt==-9999))=NaN; %convert -9999 to NaNs
salt=(squeeze(salt))';

% low pass filter
for i=1:length(depth)
    tfilt(:,i)=pl33tn(temp(:,i)); 
    sfilt(:,i)=pl33tn(salt(:,i)); 
end

% fill gaps with NaNs
for i=1:length(depth)
    [ DN, T(:,i), ~, ~ ] = filltimeseriesgaps( dn, tfilt(:,i) );
    [ ~, S(:,i), ~, ~ ] = filltimeseriesgaps( dn, sfilt(:,i) );
end

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

%put in structure
for i=1:length(DN)
    CA(i).dn=DN(i);    
    CA(i).lat=lat;
    CA(i).lon=lon; 
    CA(i).Z=depth;
    CA(i).T=TT(i,:);
    CA(i).S=SS(i,:); 
    CA(i).Zi =double((0:1:depth(end)))';            
end

%interpolate (avoiding the NaNs)
for i=1:length(CA)
    if CA(i).T == 0   
        CA(i).T=NaN*ones(size(CA(1).T));  
        CA(i).Ti=NaN*ones(size(CA(1).Zi));          
    elseif isnan(CA(i).T)
        CA(i).Ti=NaN*ones(size(CA(1).Zi));                  
    else    
    CA(i).Ti = double(spline(CA(1).Z,CA(i).T,CA(1).Zi)); %cubic spline interpolation
    end

    if CA(i).S == 0   
        CA(i).S=NaN*ones(size(CA(1).S));  
        CA(i).Si=NaN*ones(size(CA(1).Zi));          
    elseif isnan(CA(i).S)
        CA(i).Si=NaN*ones(size(CA(1).Zi));                  
    else    
    CA(i).Si = double(spline(CA(1).Z,CA(i).S,CA(1).Zi)); %cubic spline interpolation
    end    
    
end

clearvars depth salt temp dn i lat lon s t tt tfilt sfilt time T S DN DNN idx ii longRun x TT SS index b n var;

%% eliminate nans
%this is kludgy and i should actually write a script at some point
CA(1:213)=[];
MB(1110:end)=[];

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

clearvars MB CA i dn lat lon Ti Si Zi idx;

%% find where dT from the surface exceeds 0.5ºC, aka the MLD
deep=max(ROMS(1).Zi);

for i=1:length(ROMS)
    
    if isnan(ROMS(i).Ti)
        ROMS(i).diff = NaN*ones(size(ROMS(1).Zi));   
        ROMS(i).mld2=NaN;
        ROMS(i).mld5=NaN;
        ROMS(i).dTdz=NaN*ones(length(ROMS(1).Zi)-1,1); 
        ROMS(i).zero4=NaN;
        ROMS(i).maxdTdz=NaN;        
        ROMS(i).Zmax=NaN;
        ROMS(i).Tmax=NaN;
     
    else          
    for j=1:length(ROMS(i).Ti)
       ROMS(i).diff(j)=abs(diff([ROMS(i).Ti(1) ROMS(i).Ti(j)]))';
    end
    ROMS(i).mld2=ROMS(i).Zi(find(ROMS(i).diff > 0.2,1));
    ROMS(i).mld2(isempty(ROMS(i).mld2))=deep; %replace with deepest depth if empty
    ROMS(i).mld5=ROMS(i).Zi(find(ROMS(i).diff > 0.5,1));
    ROMS(i).mld5(isempty(ROMS(i).mld5))=deep; %replace with deepest depth if empty    
    ROMS(i).diff=ROMS(i).diff';
    ROMS(i).dTdz=abs(diff(ROMS(i).Ti))';  
    ROMS(i).zero4=ROMS(i).Zi(find(ROMS(i).dTdz >= 0.04,1));
    ROMS(i).zero4(isempty(ROMS(i).zero4))=NaN; %replace with Nan if empty      
    ROMS(i).dTdz=(ROMS(i).dTdz)';  
    [ROMS(i).maxdTdz,idx]=max(ROMS(i).dTdz);
    ROMS(i).Zmax=ROMS(i).Zi(idx);   
    ROMS(i).Tmax=ROMS(i).Ti(idx);    
    
    end
    
end

save(out_dir,'ROMS');

%%
%% NOTES

surface=zeros(length(ROMS),1);
for i=1:length(ROMS)
    surface(i)=ROMS(i).temp(1,1);
end

imagesc(temp(:,:,1)) %surface, kinda like pcolor
imagesc(salt(:,:,1)) %below, kinda like pcolor

% daydir_0 = datetime({'2018010103'},'InputFormat','yyyyMMddHH'); % 01 January
% daydir_end = datetime({'2018070103'},'InputFormat','yyyyMMddHH'); % 01 July
% daydir_dt = [daydir_0: hours(6): daydir_end]'; % 6hr intervals of ROMS output
% daydir = datestr(daydir_dt,'yyyymmddHH');
% indir_name = [in_dir in_dir_base num2str(daydir(i,1:10)) '.nc'];
    dn=datenum(datetime({num2str(daydir(i,1:10))},'InputFormat','yyyyMMddHH'));
