%% plot Shimada 2019 data 
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

filepath = '~/MATLAB/NOAA/Shimada/';
load([filepath 'Data/Shimada_HAB_2019'],'HA19');
load([filepath 'Data/pCO2_2019'],'P');
states=load([filepath 'Data/USwestcoast_pol']);
load([filepath 'Data/coast_CCS','coast']);

%%%% plot HAB data
%lat = HA19.Lat_dd; lon = HA19.Lon_dd; 
%data=HA19.Chl_agL; cax=[0 10]; label='Chl a (ug/L)'; varname='CHL';
%data=HA19.WaterTempC; cax=[10 20]; label='T (^oC)'; varname='TMP';
%data=HA19.S; cax=[30 34]; label='S (ppt)'; varname='SAL';
%data=HA19.PseudonitzschiaSpprelativeAbundance; cax=[0 3]; label={'Pseudo-nitzschia';'RA'}; varname='PNra';
%data=HA19.NitrateM; cax=[0 20]; label='Nitrate (uM)'; varname='NIT';
%data=HA19.SilicateM; cax=[0 70]; label='Silicate (uM)'; varname='SIL';

%%%% plot underway data
lat = P.lat; lon = P.lon; 
%data=P.pco2_uatm; cax=[200 800]; label='pCO_2 (uatm)'; varname='pCO2';
data=P.sst_c; cax=[9 20]; label='SST (^oC)'; varname='SST';
%data=P.sal_psu; cax=[32 34]; label='Sal (psu)'; varname='SAL';

% set mask for data
ii=~isnan(data+lat+lon);lon=lon(ii); lat=lat(ii); data=data(ii);  
[LON,LAT] = meshgrid(-127:.1:-120.4, 34.3:.1:48.6);
DATA = griddata(lon,lat',data,LON,LAT);

%[LON,LAT,DATA] = xyz2grid(lon,lat,data);
%lonL=NaN*LON(:,1); latL=lonL; lonR=lonL; latR=lonL;
% for i=1:size(LON,1)
%     idx=find(~isnan(DATA(i,:)),1,'first');
%     if isempty(idx)
%         lonL(i)=NaN;
%         latL(i)=NaN;
%     else
%         lonL(i)=LON(i,idx);
%         latL(i)=LAT(i,idx);        
%     end
% 
%     idx=find(~isnan(DATA(i,:)),1,'last');
%     if isempty(idx)
%         lonR(i)=NaN;
%         latR(i)=NaN;
%     else
%         lonR(i)=LON(i,idx);
%         latR(i)=LAT(i,idx);        
%     end  
% end
%
% lonR=flipud(lonL); latR=flipud(latL);
% lonrange=([lonL;lonR;lonL(1)]);
% latrange=([latL;latR;latL(1)]);

% isin = inpolygon(LON,LAT,lonrange,latrange);
% DATA(~isin) = NaN;

clearvars isin lonR lonL latR latL ii i idx data land;

% plot
figure('Units','inches','Position',[1 1 2.5 5],'PaperPositionMode','auto'); 
pcolor(LON,LAT,DATA); shading flat; hold on; 

%plot(coast(:,1),coast(:,2),'k'); hold on;
plot(lon,lat,'k.','Markersize',2); hold on

fillseg(coast); dasp(42); hold on;
plot(states(:,1),states(:,2),'k'); hold on;
set(gca,'ylim',[34 49],'xlim',[-127 -120],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');

colormap(parula);  caxis(cax);    
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 12;               
    hp=get(h,'pos'); 
    hp(1)=hp(1); hp(2)=.9*hp(2); hp(3)=.5*hp(3); hp(4)=.6*hp(4);
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); 
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'Figs/MappedDiscreteShimada2019_' varname '.tif']);
hold off 