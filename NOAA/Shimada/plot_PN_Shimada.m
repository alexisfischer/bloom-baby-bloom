%% plot PN 
clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
filepath = '/Users/afischer/MATLAB/';

load([filepath 'NOAA/Shimada/Data/Shimada_HAB_2019'],'HA19');
HA19(any(ismissing(HA19.Total_PNcellsL),2),:)=[]; %remove nans from PN cell counts
X=[datenum(HA19.dt),HA19.Lat_dd,HA19.Lon_dd,HA19.Total_PNcellsL*0.001];
clearvars PN lat lon dt HA19

load([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/class/summary_biovol_allTB2019'],...
    'filelistTB','class2useTB','classcountTB','ml_analyzedTB','mdateTB')

%%%% find lat lon coordinate of each file
load([filepath 'NOAA/Shimada/Data/IFCB_Lat_Lon_coordinates_2019'],'L');
lat=NaN*mdateTB; lon=NaN*mdateTB;
for i=1:length(filelistTB)
    idx=(strcmp(filelistTB(i), L.headerfile));   
    lat(i)=L.Lat_dd(idx);
    lon(i)=L.Lon_dd(idx);
end
PN=classcountTB(:,(strcmp('Pseudo-nitzschia',class2useTB)))./ml_analyzedTB;
Y=[mdateTB,lat,lon,PN];

clearvars filelistTB i PN idx ml_analyzedTB classcountTB class2useTB L mdateTB;

%% find matching coordinates based off of distance
D = pdist2(X(:,2:3), Y(:,2:3),'euclidean');
[rowOfX, rowOfY] = find(D < .02);
XX=X(rowOfX,:); YY=Y(rowOfY,:);

figure('Units','inches','Position',[1 1 3. 3.],'PaperPositionMode','auto'); 
val=45;
mdl = fitlm(XX(:,4),YY(:,4),'RobustOpts','on');
scatter(XX(:,4),YY(:,4),30,'filled'); hold on;
plot(linspace(0,val),linspace(0,val),'k-'); hold on
%plot(mdl.Variables.x1,mdl.Fitted,'r-','Linewidth',1); hold on
set(gca,'xlim',[0 val],'ylim',[0 val],'xtick',0:10:val,'ytick',0:10:val,'fontsize',11); hold on;

axis square; box on;
ylabel('IFCB','fontsize',12)
xlabel('microscopy','fontsize',12)
title('\itPseudo-nitzschia \rmspp. (cells/mL)','fontsize',12);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'NOAA/Shimada/Figs/PN_mcrpy_vs_IFCB_Shimada2019.tif']);
hold off 





