%% import Feb 2018 HFR data
clear;
filepath = '~/MATLAB/bloom-baby-bloom/'; 
in_dir='~/Documents/UCSC_research/SCW_Dino_Project/Data/MBAY_2km_HFR_2011_2019.nc';

iilat=[36.5 37.1]; 
lat=ncread(in_dir,'lat'); ilat=find(lat>=iilat(1) & lat<=iilat(2)); 
LAT=double(ncread(in_dir,'lat',ilat(1),length(ilat)))'; 

iilon=[-122.29 -121.77]; 
lon=ncread(in_dir,'lon'); ilon=find(lon>=iilon(1) & lon<=iilon(2)); 
LON=double(ncread(in_dir,'lon', ilon(1),length(ilon)));

lat=repmat(LAT,length(LON),1); lon=repmat(LON,1,length(LAT)); 

time=ncread(in_dir,'time'); dnn=datenum(hours(time) + datetime('2011-10-01 00:00:00')); %UTC
itime=find(dnn>=datenum('20-Feb-2018') & dnn<=datenum('01-Mar-2018')); dnn=dnn(itime);

uu=100*double(ncread(in_dir,'u',[ilon(1) ilat(1) itime(1)],[length(ilon) length(ilat) length(itime)])); % eastward velocity 
vv=100*double(ncread(in_dir,'v',[ilon(1) ilat(1) itime(1)],[length(ilon) length(ilat) length(itime)])); % northward velocity

clearvars LON LAT in_dir itime time ilat ilon

%% take 25 point average (option 1)
n=25;
dt=datetime(dnn,'ConvertFrom','datenum');
dn = floor(datenum(arrayfun(@(k) nanmean(dt(k:k+n-1)),1:n:length(dt)-n+1)')); 

u = NaN*ones(size(uu,1),size(uu,2),length(dn)); % preallocate
v = NaN*ones(size(vv,1),size(vv,2),length(dn)); 
 
for i=1:size(uu,1)
    for j=1:size(uu,2)
        
        a=squeeze(uu(i,j,:));        
        u(i,j,:) = arrayfun(@(k) nanmean(a(k:k+n-1)),1:n:length(a)-n+1)'; 
      
        a=squeeze(vv(i,j,:));
        v(i,j,:) = arrayfun(@(k) nanmean(a(k:k+n-1)),1:n:length(a)-n+1)';          
        
    end
end

clearvars dt vv uu i j n ui vi dnn a

%% take 25 point average (option 2)
n=25;
dn=dnn(1:n:end);
[~,a,b]=intersect(dn,dnn);
index=NaN*dnn; index(b)=a;
for i=1:length(index)
    if isnan(index(i))
        index(i)=index(i-1);
    else
    end
end

u = NaN*ones(size(uu,1),size(uu,2),length(dn)); % preallocate
v = NaN*ones(size(vv,1),size(vv,2),length(dn)); 

for i = 1:length(a)
    j = (a(i) == index);
    u(:,:,a(i)) = nanmean(uu(:,:,j),3);
    v(:,:,a(i)) = nanmean(vv(:,:,j),3);
    
end

dn=floor(dn);

clearvars a b i j uu vv dnn n index

%%
save([filepath 'SCW/Data/Hfr_daily_SCW_Feb2018'],'dn','u','v','lat','lon','iilat','iilon');
