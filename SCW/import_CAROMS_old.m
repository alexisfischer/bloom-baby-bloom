%% import ROMS data for particular years of interest

%year= 2015;
% load('MB_ROMs_filenames_2015','filename');
% filename=flipud(char(filename));
% in_dir='http://west.rssoffice.com:8080/thredds/dodsC/roms/CA3km-nowcast/MB/';
% out_dir='~/Documents/MATLAB/bloom-baby-bloom/SCW/Data/ROMS/MB_temp_sal_2015'; %change for whatever year
% in_dir_base='ca_subMB_das_';

load('MB_ROMs_filenames_2017-2018','filename');
filename=flipud(char(filename));
in_dir='http://west.rssoffice.com:8080/thredds/dodsC/roms/CA3km-nowcast/MB/';
out_dir='~/Documents/MATLAB/bloom-baby-bloom/SCW/Data/ROMS/MB_temp_sal_2017-2018'; %change for whatever year
in_dir_base='ca_subMB_das_';

%%
% organize data of interest
for i=1:length(filename)
    disp(filename(i,1:26));
    indir_name = [in_dir filename(i,1:26)];
    lat=ncread(indir_name,'lat'); %degrees_north
    lon_E=ncread(indir_name,'lon'); %degrees_east
    lon=lon_E-360; %convert to negative degrees_west    
    depth=ncread(indir_name,'depth'); 
    temp=ncread(indir_name,'temp'); 
    temp(find(temp==-9999))=NaN; %convert -9999 to NaNs
    salt=ncread(indir_name,'salt'); 
    salt(find(salt==-9999))=NaN; %convert -9999 to NaNs
    time=ncread(indir_name,'time'); 
    dn=datenum(datetime({num2str(filename(i,14:23))},'InputFormat','yyyyMMddHH'));

ROMS(i).dn=dn;    
ROMS(i).lat=lat(49); % 36.9573�N,    
ROMS(i).lon=lon(54); % -122.0173�W
ROMS(i).Z=depth;
ROMS(i).T=squeeze(temp(54,49,:));
ROMS(i).S=squeeze(salt(54,49,:));

end

% remove bad data on '11-Apr-2018 09:00:00'
%ROMS(392) = [];

% find max dT/dz and find 0.04�C/m
for i=1:length(ROMS)
   ROMS(i).Ti = spline(ROMS(1).Z,ROMS(i).T,0:1:40)'; %cubic spline interpolation
    ROMS(i).Si = spline(ROMS(1).Z,ROMS(i).S,0:1:40)';
   ROMS(i).Zi = (0:1:40)';
    ROMS(i).dTdz=diff(ROMS(i).Ti)';  
    ROMS(i).zero4=ROMS(i).Zi(find(ROMS(i).dTdz >= 0.04,1));
    ROMS(i).zero4(isempty(ROMS(i).zero4))=NaN; %replace with Nan if empty      
     ROMS(i).dTdz=(ROMS(i).dTdz)';  
     [ROMS(i).maxdTdz,idx]=max(ROMS(i).dTdz);
     ROMS(i).Tmax=ROMS(i).Ti(idx);
     ROMS(i).Zmax=ROMS(i).Zi(idx);   
end

    
% find where dT from the surface exceeds 0.5�C, aka the MLD
for i=1:length(ROMS)
    for j=1:length(ROMS(i).Ti)
       ROMS(i).diff(j)=abs(diff([ROMS(i).Ti(1) ROMS(i).Ti(j)]));
    end
    ROMS(i).mld2=ROMS(i).Zi(find(ROMS(i).diff > 0.2,1));
    ROMS(i).mld2(isempty(ROMS(i).mld2))=40; %replace with deepest depth if empty
    ROMS(i).mld5=ROMS(i).Zi(find(ROMS(i).diff > 0.5,1));
    ROMS(i).mld5(isempty(ROMS(i).mld5))=40; %replace with deepest depth if empty    
    ROMS(i).diff=ROMS(i).diff';
end

save(out_dir,'ROMS');

%% notes

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