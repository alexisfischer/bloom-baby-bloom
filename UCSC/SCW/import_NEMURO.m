filepath='~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
in_dir = 'http://oceanmodeling.pmc.ucsc.edu:8080/thredds/dodsC/CCSRA_NEM_2017a_agg_catalog_zlevs/fmrc/CCSRA_NEM_2017a_Historical_Reanalysis_Phys-Bio_ROMS_NEMURO_Aggregation_best.ncd';

time = ncread(in_dir, 'time');
% ncreadatt(in_dir, 'time', 'units')  % get the units for time
% length(time) % how many time entries are present?
DN=time/24 + datenum('2013-01-01 00:00:00'); %7 hrs ahead of PT

Z = ncread(in_dir, 'z'); %depth

%best coordinates lon=121 lat=70

%ncdisp(in_dir, 'lon_rho')
%lon = ncread(in_dir, 'lon_rho', [1,1], [inf,inf]); %all longitudes
LAT=ncread(in_dir, 'lat_rho', [121,70], [1,1])

%ncdisp(in_dir, 'lat_rho')
%lat = ncread(in_dir, 'lat_rho', [1,1], [inf,inf]); %all latitudes
LON=ncread(in_dir, 'lon_rho', [122,70], [1,1])

%% load in specific variable (can only do 2 yr intervals bc of server)
%i0=find(dn==datenum('01-Jan-2013'));
%iend=find(dn==datenum('31-Dec-2014'));
% i0=find(dn==datenum('01-Jan-2015'));
% iend=find(dn==datenum('31-Dec-2016'));
% i0=find(dn==datenum('01-Jan-2017'));
% iend=find(dn==datenum('31-Dec-2018'));
 i0=find(DN==datenum('01-Jan-2019'));
 iend=length(DN);
 
total=length(i0:iend);

%% NO3
%ncdisp(in_dir, 'NO3')
var = ncread(in_dir,'NO3',[121,70,11,i0], [1,1,1,total]); %all times, at surface (2m) and at specific lat long
%NO3_1314 = reshape(var,[total,1]);
%N03_1516 = reshape(var,[total,1]);
%N03_1718 = reshape(var,[total,1]);
NO3_19 = reshape(var,[total,1]);
NO3=[NO3_1314;NO3_1516;NO3_1718;NO3_19];

clearvars NO3_1314 NO3_1516 NO3_1718 NO3_19

%% NH4
%ncdisp(in_dir, 'NO3')
var = ncread(in_dir,'NH4',[121,70,11,i0], [1,1,1,total]); %all times, at surface (2m) and at specific lat long
%NH4_1314 = reshape(var,[total,1]);
%NH4_1516 = reshape(var,[total,1]);
%NH4_1718 = reshape(var,[total,1]);
NH4_19 = reshape(var,[total,1]);

%NH4=[NH4_1314;NH4_1516;NH4_1718;NH4_19];

clearvars NH4_1314 NH4_1516 NH4_1718 NH4_19

save([filepath 'Data/NEMURO'],'DN','LAT','LON','Z','NO3','NH4');

%% compare with SCW sampling

load([filepath 'Data/NEMURO'],'LAT','LON','NO3','NH4');
load([filepath 'Data/SCW_master'],'SC');

[C,ia,ib]=intersect(dn,SC.dn); %C = A(ia) and C = B(ib).
NO3=NO3(ia);
no3s=SC.nitrate(ib);

NH4=NH4(ia);
nh4s=SC.ammonium(ib);

%% plot NO3
%x=no3s; y=NO3; label='Nitrate';
x=nh4s; y=NH4; label='Ammonium';

[idx]=~isnan(x); x=x(idx); y=y(idx); %remove NaNs from SCW
[idx]=~isnan(y); x=x(idx); y=y(idx); %remove NaNs from NEMURO

b1 = x\y
yCalc1 = b1*x;

X = [ones(length(x),1) x];
b = X\y
yCalc2 = X*b;

Rsq1 = round(1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2),2,'significant')
Rsq2 = round(1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2),2,'significant')

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
scatter(x,y);
hold on 
plot(x,yCalc1)
hold on
plot(x,yCalc2,'--')

legend('Data',['Slope (R^2=' num2str(Rsq1) ')'],...
    ['Slope & Intercept (R^2=' num2str(Rsq2) ')'],'Location','NE'); legend boxoff
xlabel('SCW discrete sample');
ylabel('NEMURO modeled (2m)');
title(label)

set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/NEMURO_Discrete_' num2str(label) '.tif']);
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
