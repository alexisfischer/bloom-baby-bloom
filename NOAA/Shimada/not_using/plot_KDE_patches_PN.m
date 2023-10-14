%use KDE to find patches of PN and DA
clear; %close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2021; % 2019; 2021
fprint=1;
grid_size = 50; % Adjust as needed

%%%% load in discrete data
load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
if yr==2019
    P((P.DT>datetime('01-Jan-2020')),:)=[]; 
    top_percentage = 0.25; % Set the threshold for identifying high-density regions     
elseif yr==2021
    P((P.DT<datetime('01-Jan-2020')),:)=[];
end

%%%% Toxicity
idx=isnan(P.pDA_ngL); data=P.pDA_ngL(~idx); lat=P.LAT(~idx);
if yr==2019
    bandwidth_lat = 0.6; % USER
    bandwidth_data = 0.8; % USER    
    top_percentage = 0.25; % Set the threshold for identifying high-density regions 
elseif yr==2021
    bandwidth_lat = 0.6; % USER
    bandwidth_data = 0.8; % USER
    data(end+1)=150; lat(end+1)=48.5; 
    top_percentage = 0.15; % USER  
end
data=log10(data); idx=find(data<0); data(idx)=[]; lat(idx)=[];
[grid_lat_tox,grid_tox,density_tox,lat_range_highest_data]=estimate_patch_KDE(lat,data,bandwidth_lat,bandwidth_data,grid_size,top_percentage);
lat_range_tox=[lat_range_highest_data(1) lat_range_highest_data(end)];
tox=data; toxlat=lat;

%%%% PN
data=P.Pseudonitzschia_large+P.Pseudonitzschia_medium; lat=P.LAT;
%data=P.Pseudonitzschia_large; lat=P.LAT;    
if yr==2019
    top_percentage = 0.25; % l+m
    bandwidth_lat = 0.6; % l+m
    bandwidth_data = 0.7; % l+m 
elseif yr==2021
    top_percentage = 0.25; % l+m
    bandwidth_lat = 0.6; % l+m
    bandwidth_data = 0.6; % l+m     
end
data=log10(data); idx=find(data<0); data(idx)=[]; lat(idx)=[];
[grid_lat_pn,grid_pn,density_pn,lat_range_highest_data]=estimate_patch_KDE(lat,data,bandwidth_lat,bandwidth_data,grid_size,top_percentage);
range=diff(lat_range_highest_data); idx=find(range>1);
lat_range_pn(1,:)=[lat_range_highest_data(1) lat_range_highest_data(idx)];
lat_range_pn(2,:)=[lat_range_highest_data(idx+1) lat_range_highest_data(end)];
pn=data; pnlat=lat;
clearvars idx data lat bandwidth* lat_range_highest_data %range

%%%% Plot the density estimate
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.7 5.]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.1 0.05], [0.14 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1)
contourf(grid_lat_tox, grid_tox, density_tox', 'LineStyle', 'none'); hold on;
plot(toxlat,tox,'k.','linewidth',1,'markersize',4)
plot(lat_range_tox,[0 0], 'r', 'LineWidth', 6); hold on
title(num2str(yr));
ylabel('log (pDA) ng/L');
colorbar; 
set(gca,'xlim',[40 48.5],'xtick',40:1:49,'xticklabel',{},'fontsize',11,'tickdir','out'); hold on;

subplot(2,1,2)
contourf(grid_lat_pn, grid_pn, density_pn', 'LineStyle', 'none'); hold on;
plot(pnlat,pn,'k.','linewidth',1,'markersize',4)
plot(lat_range_pn(1,:),[0 0],'r',lat_range_pn(2,:),[0 0],'r','LineWidth', 6);    
if yr==2021
    plot([47.5 48.5],[0 0],'k','LineWidth', 6);   
else
end
xlabel('Latitude');
ylabel('log (PN) cells/mL');
colorbar;
set(gca,'xlim',[40 48.5],'xtick',40:1:49,'fontsize',11,'tickdir','out'); hold on;
hold off;

if fprint==1
    exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/KDE_' num2str(yr) '_PN.png'],'Resolution',100)    
end
hold off 

%%%% find top values in this patch
%only select values with >1 cell
idx=find(sum([P.Pseudonitzschia_large,P.Pseudonitzschia_medium],2)>1); P=P(idx,:);
PN=P.Pseudonitzschia_large+P.Pseudonitzschia_medium;

if yr==2019
    val=[lat_range_tox,lat_range_pn(1,:)]; id1=min(val); id2=max(val);
    idT=find(P.LAT>=id1 & P.LAT<=id2);
elseif yr==2021
    idT=find(P.LAT>=lat_range_tox(1) & P.LAT<=lat_range_tox(end));
end
    idN1=find(P.LAT>=lat_range_pn(1,1) & P.LAT<=lat_range_pn(1,end));
    idN2=find(P.LAT>=lat_range_pn(2,1) & P.LAT<=lat_range_pn(2,end));

mean_tox=[nanmean(P.TEMP(idT));nanmean(P.SAL(idT));nanmean(P.PCO2(idT));...
    nanmean(P.NitrateM(idT));nanmean(P.PhosphateM(idT));...
    nanmean(P.SilicateM(idT));nanmean(P.chlA_ugL(idT));...
    nanmean(P.pDA_ngL(idT));nanmean(PN(idT))];
std_tox=[nanstd(P.TEMP(idT));nanstd(P.SAL(idT));nanstd(P.PCO2(idT));...
    nanstd(P.NitrateM(idT));nanstd(P.PhosphateM(idT));...
    nanstd(P.SilicateM(idT));nanstd(P.chlA_ugL(idT));...
    nanstd(P.pDA_ngL(idT));nanstd(PN(idT))];

mean_non1=[nanmean(P.TEMP(idN1));nanmean(P.SAL(idN1));nanmean(P.PCO2(idN1));...
    nanmean(P.NitrateM(idN1));nanmean(P.PhosphateM(idN1));...
    nanmean(P.SilicateM(idN1));nanmean(P.chlA_ugL(idN1));...
    nanmean(P.pDA_ngL(idN1));nanmean(PN(idN1))];
std_non1=[nanstd(P.TEMP(idN1));nanstd(P.SAL(idN1));nanstd(P.PCO2(idN1));...
    nanstd(P.NitrateM(idN1));nanstd(P.PhosphateM(idN1));...
    nanstd(P.SilicateM(idN1));nanstd(P.chlA_ugL(idN1));...
    nanstd(P.pDA_ngL(idN1));nanstd(PN(idN1))];

mean_non2=[nanmean(P.TEMP(idN2));nanmean(P.SAL(idN2));nanmean(P.PCO2(idN2));...
    nanmean(P.NitrateM(idN2));nanmean(P.PhosphateM(idN2));...
    nanmean(P.SilicateM(idN2));nanmean(P.chlA_ugL(idN2));...
    nanmean(P.pDA_ngL(idN2));nanmean(PN(idN2))];
std_non2=[nanstd(P.TEMP(idN2));nanstd(P.SAL(idN2));nanstd(P.PCO2(idN2));...
    nanstd(P.NitrateM(idN2));nanstd(P.PhosphateM(idN2));...
    nanstd(P.SilicateM(idN2));nanstd(P.chlA_ugL(idN2));...
    nanstd(P.pDA_ngL(idN2));nanstd(PN(idN2))];

var={'Temperature';'Salinity';'pCO2';'Nitrate';'Phosphate';'Silicate';'ChlA';'pDA';'PN'};
patch=table(var,mean_tox,std_tox,mean_non1,std_non1,mean_non2,std_non2);

save([filepath 'NOAA/Shimada/Data/Patch_' num2str(yr)],'lat_range_tox','lat_range_pn','patch');


