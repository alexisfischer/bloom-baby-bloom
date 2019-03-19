filepath='~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
in_dir = 'http://oceanmodeling.pmc.ucsc.edu:8080/thredds/dodsC/CCSRA_NEM_2017a_agg_catalog_zlevs/fmrc/CCSRA_NEM_2017a_Historical_Reanalysis_Phys-Bio_ROMS_NEMURO_Aggregation_best.ncd';

time = ncread(in_dir, 'time');
% ncreadatt(in_dir, 'time', 'units')  % get the units for time
% length(time) % how many time entries are present?
dn=time/24 + datenum('2013-01-01 00:00:00'); %7 hrs ahead of PT

z = ncread(in_dir, 'z'); %depth

%best coordinates lon=121 lat=70

%ncdisp(in_dir, 'lon_rho')
%lon = ncread(in_dir, 'lon_rho', [1,1], [inf,inf]); %all longitudes
lat=ncread(in_dir, 'lat_rho', [121,70], [1,1])

%ncdisp(in_dir, 'lat_rho')
%lat = ncread(in_dir, 'lat_rho', [1,1], [inf,inf]); %all latitudes
lon=ncread(in_dir, 'lon_rho', [122,70], [1,1])

%ncdisp(in_dir, 'NO3')
var = ncread(in_dir,'NO3',[121,70,11,1], [1,1,1,inf]); %all times, at surface (2m) and at specific lat long
NO3_2 = reshape(var,[length(dn),1]);

%%
var = ncread(in_dir,'NO3',[121,70,10,1], [1,1,1,inf]); %all times, at surface (2m) and at specific lat long
NO3_5 = reshape(var,[length(dn),1]);

var = ncread(in_dir,'NH4',[121,70,11,1], [1,1,1,inf]); %all times, at surface (2m) and at specific lat long
NH4_2 = reshape(var,[length(dn),1]);

var = ncread(in_dir,'NH4',[121,70,10,1], [1,1,1,inf]); %all times, at surface (2m) and at specific lat long
NH4_5 = reshape(var,[length(dn),1]);

clearvars var time in_dir

save([filepath 'Data/NEMURO'],'dn','lat','lon','z','NO3_2','NO3_5','NH4_2','NH4_5');

%% compare with SCW sampling

load([filepath 'Data/NEMURO'],'dn','lat','lon','z','NO3_2','NO3_5','NH4_2','NH4_5');
load([filepath 'Data/SCW_master'],'SC');

[C,ia,ib]=intersect(dn,SC.dn); %C = A(ia) and C = B(ib).
NO3_2=NO3_2(ia);
%NO3_5=NO3_5(ia);
no3_sc=SC.nitrate(ib);

NH4_2=NH4_2(ia);
NH4_5=NH4_5(ia);
nh4_sc=SC.ammonium(ib);

%% plot NO3
%remove NaNs from SCW
[idx]=~isnan(no3_sc); no3_sc=no3_sc(idx); DN_no3=C(idx); NO3_2=NO3_2(idx); 

%remove NaNs from NEMURO
[idx]=~isnan(NO3_2); no3_sc=no3_sc(idx); DN_no3=C(idx); NO3_2=NO3_2(idx);

x=no3_sc;
y=NO3_2;
b1 = x\y
yCalc1 = b1*x;

X = [ones(length(x),1) x];
b = X\y
yCalc2 = X*b;

figure; 
scatter(x,y);
hold on 
plot(x,yCalc1)
hold on
plot(x,yCalc2,'--')
legend('Data','Slope','Slope & Intercept','Location','best');
xlabel('SCW discrete sample');
ylabel('NEMURO modeled (2m)');
title('Nitrate')
Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2)

Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)

%%
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/NEMURO_Discrete_Nitrate.tif']);
hold off


%% plot cool map of ocean surface temperatures
url          = 'http://oceanmodeling.pmc.ucsc.edu:8080/thredds/dodsC/CCSRA_NEM_2017a_agg_catalog_zlevs/fmrc/CCSRA_NEM_2017a_Historical_Reanalysis_Phys-Bio_ROMS_NEMURO_Aggregation_best.ncd';
lon_rho = ncread(url,'lon_rho'); %get 2d map of lons
lat_rho  = ncread(url,'lat_rho');  %get 2d map of lats
z            = ncread(url,'z');             %get 1d list of depths, same everywhere so don't need 2d map
[II,JJ]     = size(lon_rho);
ZZ        = length(z);
temp    = ncread(url,'temp',[1 1 ZZ-1 1],[II JJ 1 1]);  % temp = temp(lon,lat,depth,time)
%plot first snapshot in dataset of temperature at 5 m depth over entire domain
pcolor(lon_rho,lat_rho,temp); shading flat; colorbar
