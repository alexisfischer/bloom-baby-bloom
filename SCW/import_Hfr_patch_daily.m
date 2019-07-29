%% import little patch near SCW, monthly data
clear;
filepath = '~/MATLAB/bloom-baby-bloom/'; 
in_dir='~/Documents/UCSC_research/SCW_Dino_Project/Data/MBAY_2km_HFR_2011_2019.nc';
iilat=[36.92 36.97]; 
lat=ncread(in_dir,'lat'); ilat=find(lat>=iilat(1) & lat<=iilat(2)); 
LAT=double(ncread(in_dir,'lat',ilat(1),length(ilat)))'; 

iilon=[-122.04 -121.93];
%iilon=[-122.04 -121.95];
lon=ncread(in_dir,'lon'); ilon=find(lon>=iilon(1) & lon<=iilon(2)); 
LON=double(ncread(in_dir,'lon', ilon(1),length(ilon)));

lat=repmat(LAT,length(LON),1); lon=repmat(LON,1,length(LAT)); 

time=ncread(in_dir,'time'); dn=datenum(hours(time) + datetime('2011-10-01 00:00:00')); %UTC
itime=find(dn>=datenum('01-Jan-2012') & dn<=datenum('31-Dec-2018')); dn=dn(itime);

uu=100*double(ncread(in_dir,'u',[ilon(1) ilat(1) itime(1)],[length(ilon) length(ilat) length(itime)])); % eastward velocity 
vv=100*double(ncread(in_dir,'v',[ilon(1) ilat(1) itime(1)],[length(ilon) length(ilat) length(itime)])); % northward velocity

clearvars LON LAT in_dir itime time iilat iilon ilat ilon

% select a patch of vectors of interest for long term timeseries
u=NaN*dn; v=u;
for i=1:length(dn)
   uuu(i)=nanmean(nanmean(uu(:,:,i)));
   vvv(i)=nanmean(nanmean(vv(:,:,i)));
end
u=pl33tn(uuu); v=pl33tn(vvv);

clearvars uu vv uuu vvv

% take daily average of U and V
[dnn,~,c]=unique(datenum(datestr(datenum(dn),'dd-mmm-yyyy'))); % c corresponds to ids to be averaged
DN=datetime(dnn,'ConvertFrom','datenum'); DN.TimeZone='America/Los_Angeles';       
DN=datenum(DN);

U=NaN*DN; V=U; % preallocate
for i=1:length(DN)
    idx=find(c==i);    
    U(i) = nanmean(u(idx));
    V(i) = nanmean(v(idx));
end

clearvars dnn idx i c

[U] = interp1babygap(U,100); [V] = interp1babygap(V,100);

figure; plot(DN,U,'k-','linewidth',2); datetick;
figure; plot(DN,V,'k-','linewidth',2); datetick;

%%
save([filepath 'SCW/Data/Hfr_daily_SCW_2012-2018'],'dn','u','v','DN','U','V','lat','lon');

%%
% % take daily average of U and V
% dn=datenum(datestr(datenum(DN),'dd-mmm-yyyy'));
% [dnn,~,c]=unique(dn); % c corresponds to ids to be averaged
% DN=datetime(dnn,'ConvertFrom','datenum'); DN.TimeZone='America/Los_Angeles';
% dn=datenum(DN);
% 
% U = zeros(size(uu,1),size(uu,2),length(DN)); % preallocate
% V = zeros(size(vv,1),size(vv,2),length(DN));
% for i=1:length(DN)
%     idx=find(c==i);
%     U(:,:,i) = nanmean(uu(:,:,idx),3);
%     V(:,:,i) = nanmean(vv(:,:,idx),3);
% end
% clearvars uu vv DN dnn i idx c
% 
% % select a patch of vectors of interest for long term timeseries
% u=NaN*dn; v=u;
% 
% for i=1:length(dn)
%    u(i)=nanmean(nanmean(U(i))); %take daily mean
%    v(i)=nanmean(nanmean(V(i)));
% end
% clearvars U V i
% 
% figure; plot(dn,u,'k-','linewidth',2); datetick;
% figure; plot(dn,v,'k-','linewidth',2); datetick;
%
%save([filepath 'SCW/Data/Hfr_daily_SCW_2012-2018'],'dn','u','v','lat','lon');
