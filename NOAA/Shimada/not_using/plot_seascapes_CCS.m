%% plot geographic locations of seascapes in 2019 and 2021 summer hake surveys
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1;
yr=2019; % 2019; 2021

load([filepath 'NOAA/SeascapesProject/Data/SeascapeSummary_NOAA-OSU-UCSC'],'S');
%%
load([filepath 'NOAA/SeascapesProject/Data/seascape_topclasses'],'SS');
ib=find(~strcmp('NOAA',S.group)); S(ib,:)=[]; %only keep Hake survey data

%only keep top seascapes
idx=[];
for i=1:(length(SS)-1)
    topSS(i)=str2double(SS(i).ss);
    id_new=find(S.ss==topSS(i));
    idx=[idx;id_new];    
end
S=S(idx,:);

%set seascapes to ordered numbers so they plot better with colors
Sc=S;
for i=1:length(topSS)
    Sc.ss(find(Sc.ss==topSS(i)))=i;
end

idx=find(year(Sc.dt)==yr); %only use selected year of data
data=Sc.ss(idx); LON=Sc.lon(idx); LAT=Sc.lat(idx); cax=[1 length(topSS)]; 

load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB' num2str(yr) ''],'filelistTB','mdateTB');
[latR,lonR,~,filelistTB,mdateTB]=match_IFCBdata_w_Shimada_lat_lon(filepath,yr,filelistTB,mdateTB);

%t0=datetime(mdateTB(1),'ConvertFrom','datenum');
%tend=datetime(mdateTB(end),'ConvertFrom','datenum');

%find IFCB files without seascapes
filelistS=cellfun(@(X) X(1:end-4),Sc.filename(idx),'Uniform',0);

[filelist_noSS,ia]=setdiff(filelistTB,filelistS); latR=latR(ia); lonR=lonR(ia);
clearvars ia ib idx filelistTB mdateTB;

%%%% plot individual data points
figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 5]); 
    scatter(lonR,latR,10,'k','filled'); hold on
    scatter3(LON,LAT,data,10,data,'filled'); 
    view(2); hold on

    c=brewermap(length(topSS),'Accent'); 
    colormap(c); caxis(cax);
    axis([min(LON) max(LON) min(LAT) max(LAT)]);
    h=colorbar('south','XTick',1:1:length(topSS),'Xticklabel',topSS,'TickLength',.05,'TickDirection','out'); 
   % h.Ruler.TickLabelRotation=0;
    hp=get(h,'pos'); hp=[1.9*hp(1) .9*hp(2) .4*hp(3) .6*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','top','fontsize',10); 
    h.Label.String = 'Seascape #';     
    hold on    

% Plot map
states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol']);
load([filepath 'NOAA/Shimada/Data/coast_CCS'],'coast');
fillseg(coast); dasp(42); hold on;
plot(states(:,1),states(:,2),'k'); hold on;
set(gca,'ylim',[34 49],'xlim',[-127.5 -120],'fontsize',10,'tickdir','out','box','on','xaxisloc','bottom');
title(yr,'fontsize',12);
    
if fprint
    exportgraphics(gca,[filepath 'NOAA/SeascapesProject/Figs/Seascapes_Hake' num2str(yr) '.png'],'Resolution',100)    
end
hold off 