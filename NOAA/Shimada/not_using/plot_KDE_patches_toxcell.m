%use KDE to find patches of PN and DA
clear; %close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2019; % 2019; 2021
fprint=1;
grid_size = 50; % Adjust as needed
logscale=0;
top_percentage = 0.3; % Set the threshold for identifying high-density regions 

%%%% load in discrete data
load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
if yr==2019
    P((P.DT>datetime('01-Jan-2020')),:)=[]; 
elseif yr==2021
    P((P.DT<datetime('01-Jan-2020')),:)=[];
end

%%%% Tox/biovol
idx=isnan(P.tox_biovol); data=(P.tox_biovol(~idx)); lat=P.LAT(~idx);
if logscale==0
    bandwidth_lat = 1; % USER
    if yr== 2019
        bandwidth_data = 10; % USER    
    elseif yr ==2021
        bandwidth_data = 5; % USER    
    end        
    val='';
elseif logscale==1
    top_percentage = 0.3; % Set the threshold for identifying high-density regions     
    data=log10(data);    
    bandwidth_lat = .4; % USER
    bandwidth_data = .5; % USER
    val='log ';
end

idx=find(data<-.1); data(idx)=[]; lat(idx)=[];
[grid_lat_tox,grid_tox,density_tox,lat_range_highest_data]=estimate_patch_KDE(lat,data,bandwidth_lat,bandwidth_data,grid_size,top_percentage);
range=diff(lat_range_highest_data); idx=find(range>1);
idA=[1,idx,length(lat_range_highest_data)];

%if isempty(idA)
if length(idA)<3
    lat_range_tox=[0 0];
elseif length(unique(idA))<length(idA)
    lat_range_tox=[0 0];
else    
    for i=1:length(idA)-1    
        lat_range(:,i)=[lat_range_highest_data(idA(i)) lat_range_highest_data(idA(i+1)-1) NaN];
    end
    lat_range_tox=[lat_range(:)];
end
tox=data; toxlat=lat;

%%%% Tox/cell
idx=isnan(P.tox_cell); data=(P.tox_cell(~idx)); lat=P.LAT(~idx);
if logscale==0
    bandwidth_lat = 1; % USER
    bandwidth_data = 30; % USER    
    val='';
elseif logscale==1
    data=log10(data);    
    bandwidth_lat = .4; % USER
    bandwidth_data = .5; % USER
    val='log ';    
end

idx=find(data<-.1); data(idx)=[]; lat(idx)=[];
[grid_lat_pn,grid_pn,density_pn,lat_range_highest_data]=estimate_patch_KDE(lat,data,bandwidth_lat,bandwidth_data,grid_size,top_percentage);
range=diff(lat_range_highest_data); idx=find(range>1);
idB=[1,idx,length(lat_range_highest_data)];

%if isempty(idB)
if length(idB)<3
    lat_range_pn=[0 0];
elseif length(unique(idB))<length(idB)
    lat_range_tox=[0 0];
else
    for i=1:length(idB)-1    
        lat_range(:,i)=[lat_range_highest_data(idB(i)) lat_range_highest_data(idB(i+1)-1) NaN];
    end
    lat_range_pn=[lat_range(:)];
end
pn=data; pnlat=lat;

clearvars idx data lat bandwidth* lat_range_highest_data %range

% Plot the density estimate
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.7 5.]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.05], [0.16 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1)
contourf(grid_lat_tox, grid_tox, density_tox', 'LineStyle', 'none'); hold on;
plot(toxlat,tox,'w.','linewidth',1,'markersize',4)
for i=length(lat_range_tox)
    plot(lat_range_tox,min(grid_tox)*ones(size(lat_range_tox)),'r','LineWidth',6); hold on
end

title(num2str(yr));
ylabel([val 'pDA/biovol']);
colorbar; 
set(gca,'xlim',[40 48.5],'xtick',40:1:49,'xticklabel',{},'fontsize',11,'tickdir','out'); hold on;

subplot(2,1,2)
contourf(grid_lat_pn, grid_pn, density_pn', 'LineStyle', 'none'); hold on;
plot(pnlat,pn,'w.','linewidth',1,'markersize',4)
for i=length(lat_range_pn)
    plot(lat_range_pn,min(grid_pn)*ones(size(lat_range_pn)),'r','LineWidth',6); hold on
end

xlabel('Latitude');
ylabel([val 'pDA/cell']);
colorbar;
set(gca,'xlim',[40 48.5],'xtick',40:1:49,'fontsize',11,'tickdir','out'); hold on;
hold off;

if fprint==1
    exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/KDE_' num2str(yr) '_tox.png'],'Resolution',100)    
end
hold off 

%% find top values in this patch
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


