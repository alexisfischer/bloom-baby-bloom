%% plot cruise tracs of Hake, NCCE, and Newport lines
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/Shimada/';
addpath(genpath(filepath)); % add new data to search path

% load in data
states=load([filepath 'Data/USwestcoast_pol']);
load([filepath 'Data/coast_CCS'],'coast');
load([filepath 'Data/NCC_stationlist'],'N');
load([filepath 'Data/SeascapeSummary_NOAA-OSU-UCSC'],'S');
iO=find((S.dt>datetime('01-March-2019')) & strcmp(S.group,{'OSU'})); %find data from one osu cruise

load([filepath 'Data/IFCB_NOAA_UCSC_lat_lon_dt'],'NOAA');
d=length(NOAA.dt)-length(NOAA.filelist); NOAA.dt(end-d+1:end)=[];
iN=find(NOAA.dt>=datetime('01-Jan-2021'));

%%%% plot
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 5]); 
c=brewermap(3,'PuBuGn');

fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[34 49],'xlim',[-127 -120],'fontsize',11,'tickdir','out','box','on','xaxisloc','bottom');

hake=scatter(NOAA.lon(iN),NOAA.lat(iN),10,c(2,:),'filled'); hold on
ncce=scatter(S.lon(iO),S.lat(iO),10,c(3,:),'filled'); hold on
nwpt=scatter(N.Lon(1:7),N.Lat(1:7),12,'r','filled'); hold on
lh=legend([hake ncce nwpt],'Hake','NCCE','NH Line','Location','Southwest'); hold on
legend boxoff;
    legend boxoff; lh.FontSize = 11; hp=get(lh,'pos');
    lh.Position=[hp(1)*.75 hp(2)*.9 hp(3) hp(4)]; hold on    

% set figure parameters%
print(gcf,'-dpng','-r100',[filepath 'Figs/stationmap_Hake-NCCE-Newport.png']);
hold off 