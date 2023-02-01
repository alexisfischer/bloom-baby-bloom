%% plot geographic locations of seascapes in 2019 and 2021 summer hake surveys
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
yr=2019; % 2019; 2021

load([filepath 'NOAA/SeascapesProject/Data/SeascapeSummary_NOAA-OSU-UCSC']);
ib=find(~strcmp('NOAA',S.group)); S(ib,:)=[]; %only keep Hake survey data

idx=find(year(S.dt)==yr); %only use selected year of data
data=S.ss(idx); LON=S.lon(idx); LAT=S.lat(idx); cax=[7 27]; label='Seascapes'; 

load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB' num2str(yr) ''],'filelistTB','mdateTB');
[latR,lonR,~,filelistTB,mdateTB]=match_IFCBdata_w_Shimada_lat_lon(filepath,yr,filelistTB,mdateTB);

%find IFCB files without seascapes
filelistS=cellfun(@(X) X(1:end-4),S.filename(idx),'Uniform',0);

[filelist_noSS,ia]=setdiff(filelistTB,filelistS); latR=latR(ia); lonR=lonR(ia);
clearvars ia ib idx filelistTB mdateTB;

%%%% plot individual data points
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 5]); 
    scatter(lonR,latR,10,'r','filled'); hold on
    scatter3(LON,LAT,data,10,data,'filled'); 
    view(2); hold on

    colormap(parula); caxis(cax);
    axis([min(LON) max(LON) min(LAT) max(LAT)]);
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 12;               
    hp=get(h,'pos'); 
    hp=[1.9*hp(1) .9*hp(2) .4*hp(3) .6*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); 
    hold on    

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol']);
load([filepath 'NOAA/Shimada/Data/coast_CCS'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states(:,1),states(:,2),'k'); hold on;
set(gca,'ylim',[34 49],'xlim',[-127 -120],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);
    
%% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/' label '_' type '_Shimada' num2str(yr) '.png']);
hold off 