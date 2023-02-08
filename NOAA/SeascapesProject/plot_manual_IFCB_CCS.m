%% map manual IFCB data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

yr=[2019,2021];
for i=1:length(yr)
    load([filepath 'IFCB-Data/Shimada/manual/count_class_manual_' num2str(yr(i)) ''],'filelist','classcount');
    filelist={filelist.name}'; filelist=cellfun(@(X) X(1:end-4),filelist,'Uniform',0);
    mTotal=sum(classcount(:,2:end),2);    
    I=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada' num2str(yr(i)) '']);
    [~,ia,ib]=intersect(filelist,I.filelistTB);
    dt=I.dtI(ib);         
    filelist=I.filelistTB(ib);     
    mTotal=mTotal(ia);         
    lat=I.latI(ib); 
    lon=I.lonI(ib); 

    idx=find(mTotal>100); %find and only count files w a lot of annotations
    M(i).yr=yr(i);
    M(i).dt=dt(idx);         
    M(i).filelist=filelist(idx);   
    M(i).mTotal=mTotal(idx);         
    M(i).lat=lat(idx);
    M(i).lon=lon(idx); 
end
clearvars i I ia ib filelist

% Plot data
figure; set(gcf,'color','w','Units','inches','Position',[1 1 5 5]); 
for i=1:length(yr)
subplot(1,length(yr),i)
    scatter3(M(i).lon,M(i).lat,M(i).mTotal,15,M(i).mTotal,'filled'); hold on
    view(2); hold on
    colormap(parula); caxis([0 4000]);

    states=load([filepath 'NOAA/Shimada/Data/USwestcoast_pol']); %plot map
    load([filepath 'NOAA/Shimada/Data/coast_CCS'],'coast');
    fillseg(coast); dasp(42); hold on;
    plot(states(:,1),states(:,2),'k'); hold on;
    set(gca,'ylim',[34 49],'xlim',[-127 -120],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');
    title(yr(i),'fontsize',12); hold on
end
    h=colorbar('south'); h.Label.String = {'# annotations'}; h.Label.FontSize = 12;               
    hp=get(h,'pos'); hp=[hp(1) .9*hp(2) .6*hp(3) .6*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); hold on   

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/Manual_IFCB_Shimada_2019-2021.png']);
hold off 