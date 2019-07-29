%%%% import HF radar data
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

% import SCW; 36.96°N, 122.02°W 
clear;
filepath = '~/MATLAB/bloom-baby-bloom/'; 
in_dir='http://hfrnet-tds.ucsd.edu/thredds/dodsC/HFR/USWC/2km/hourly/RTV/HFRADAR_US_West_Coast_2km_Resolution_Hourly_RTV_best.ncd';
ncdisp(in_dir);

iilat=[36.73 36.96]; 
lat=ncread(in_dir,'lat'); ilat=find(lat>=iilat(1) & lat<=iilat(2)); 
LAT=double(ncread(in_dir,'lat',ilat(1),length(ilat)))'; 

iilon=[-122.15 -121.8];
lon=ncread(in_dir,'lon'); ilon=find(lon>=iilon(1) & lon<=iilon(2)); 
LON=double(ncread(in_dir,'lon', ilon(1),length(ilon)));

lat=repmat(LAT,length(LON),1); lon=repmat(LON,1,length(LAT)); 

time=ncread(in_dir,'time'); dn=datenum(hours(time) + datetime('2011-10-01 00:00:00')); %UTC

%cannot download more than 150 timestamps of data at a time
itime1=find(dn>=datenum('10-Feb-2018') & dn<=datenum('05-Mar-2018')); DN1=dn(itime1);
u1=100*double(ncread(in_dir,'u',[ilon(1) ilat(1) itime1(1)],[length(ilon) length(ilat) length(itime1)])); % eastward velocity 
v1=100*double(ncread(in_dir,'v',[ilon(1) ilat(1) itime1(1)],[length(ilon) length(ilat) length(itime1)])); % northward velocity

itime2=find(dn>=datenum('06-Mar-2018') & dn<=datenum('30-Mar-2018')); DN2=dn(itime2);
u2=100*double(ncread(in_dir,'u',[ilon(1) ilat(1) itime2(1)],[length(ilon) length(ilat) length(itime2)])); % eastward velocity 
v2=100*double(ncread(in_dir,'v',[ilon(1) ilat(1) itime2(1)],[length(ilon) length(ilat) length(itime2)])); % northward velocity

uu=cat(3,u1,u2); vv=cat(3,v1,v2); dn=[DN1;DN2];
uuu=inpaintn(uu); vvv=inpaintn(vv);

replace nans on land segments
for i=1:length(dn)
    uuu(2:6,13,i)=NaN;    
    uuu(9,13,i)=NaN;    
    uuu(16:end,1:2,i)=NaN;
    uuu(end,3:4,i)=NaN;
    uuu(end,6:7,i)=NaN;
    uuu(16:end,8:9,i)=NaN;
    uuu(15:end,10,i)=NaN;
    uuu(14:end,11,i)=NaN;    
    uuu(14:end,12,i)=NaN;
    uuu(13:end,13,i)=NaN;
end

for i=1:length(dn)
    vvv(2:6,13,i)=NaN; 
    vvv(9,13,i)=NaN;       
    vvv(16:end,1:2,i)=NaN;
    vvv(end,3:4,i)=NaN;
    vvv(end,6:7,i)=NaN;
    vvv(16:end,8:9,i)=NaN;
    vvv(15:end,10,i)=NaN;
    vvv(14:end,11,i)=NaN;    
    vvv(14:end,12,i)=NaN;
    vvv(13:end,13,i)=NaN;    
end

take daily average of U and V
dn=datenum(datestr(datenum(dn),'dd-mmm-yyyy'));
[dnn,~,c]=unique(dn); % c corresponds to ids to be averaged
DN=datetime(dnn,'ConvertFrom','datenum'); DN.TimeZone='America/Los_Angeles';       
dn=datenum(DN);

u = zeros(size(uuu,1),size(uu,2),length(DN)); % preallocate
v = zeros(size(vvv,1),size(vv,2),length(DN)); 
for i=1:length(DN)
    idx=find(c==i);    
    u(:,:,i) = nanmean(uuu(:,:,idx),3);
    v(:,:,i) = nanmean(vvv(:,:,idx),3);
end

save([filepath 'SCW/Data/Hfr_daily_SCW_March2018'],'dn','u','v','lat','lon','iilat','iilon')

clearvars time LAT LON ilon ilat in_dir itime1 itime2 u1 u2 v1 v2 DN1 DN2 i
