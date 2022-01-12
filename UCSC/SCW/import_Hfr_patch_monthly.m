%% import little patch near SCW, monthly data
clear;
filepath = '~/MATLAB/bloom-baby-bloom/'; 
in_dir='http://hfrnet-tds.ucsd.edu/thredds/dodsC/USWC-month-LTA-2km.nc';

%iilat=[36.91 36.97]; 
iilat=[36.9 36.97]; 
lat=ncread(in_dir,'lat'); ilat=find(lat>=iilat(1) & lat<=iilat(2)); 
LAT=double(ncread(in_dir,'lat',ilat(1),length(ilat)))'; 

%iilon=[-122.04 -121.98];
iilon=[-122.06 -121.9];
lon=ncread(in_dir,'lon'); ilon=find(lon>=iilon(1) & lon<=iilon(2)); 
LON=double(ncread(in_dir,'lon', ilon(1),length(ilon)));

lat=repmat(LAT,length(LON),1); lon=repmat(LON,1,length(LAT)); 

DN=double(ncread(in_dir,'time')./86400 + datenum('1970-01-01'));

itime=find(DN>=datenum('01-Jan-2012') & DN<=datenum('31-Dec-2018')); dn=DN(itime);
uu=100*double(ncread(in_dir,'u_mean',[ilon(1) ilat(1) itime(1)],[length(ilon) length(ilat) length(itime)])); % eastward velocity 
%vv=100*double(ncread(in_dir,'v_mean',[ilon(1) ilat(1) itime(1)],[length(ilon) length(ilat) length(itime)])); % northward velocity

%% take daily average of U and V
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

%% select a patch of vectors of interest for long term timeseries
U=NaN*ones(3,3,length(dn)); V=U;
Umean=NaN*dn; Vmean=Umean;

for i=1:length(dn)
   U(:,:,i)=u(6:8,11:13,i);
   V(:,:,i)=v(6:8,11:13,i); 
   
   Umean(i)=nanmean(nanmean(U(:,:,i))); %take daily mean
   Vmean(i)=nanmean(nanmean(V(:,:,i)));   
end

%%
save([filepath 'SCW/Data/Hfr_daily_SCW_2012-2018'],'dn','u','v','lat','lon')

