%% map pcolor PN data along CCS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=0;
yr=2021; % 2019; 2021

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');

%%%% remove cruise legs to port
    P((P.DT<datetime('09-Jul-2019')),:)=[];
    P((P.DT>=datetime('14-Jul-2019') & P.DT<datetime('20-Jul-2019')),:)=[];
    P((P.DT>=datetime('01-Aug-2019') & P.DT<datetime('07-Aug-2019')),:)=[];
    P((P.DT>=datetime('12-Aug-2019 10:00:00') & P.DT<datetime('14-Aug-2019 02:00:00')),:)=[];
    P((P.DT>=datetime('19-Aug-2019') & P.DT<datetime('26-Jul-2021')),:)=[];
    P((P.DT>=datetime('08-Aug-2021') & P.DT<datetime('06-Sep-2021')),:)=[];
    P((P.DT>=datetime('22-Sep-2021')),:)=[];

P=sortrows(P,'LAT','ascend'); % sort by latitude
diat=P.diatom_biovol; dino=P.dino_biovol; lat=P.LAT; dt=P.DT;
latbins=(40:.2:49)';

%2019
idx=find(dt<datetime('01-Jan-2020')); diat19=diat(idx); dino19=dino(idx); lat19=lat(idx);
ratio19=NaN*latbins;
for i=1:length(latbins)-1
    id=lat19>=latbins(i) & lat19<latbins(i+1);
    ratio19(i)=mean(dino19(id),'omitnan')./mean(diat19(id),'omitnan');
end

%2021
idx=find(dt>datetime('01-Jan-2020')); diat21=diat(idx); dino21=dino(idx); lat21=lat(idx);
ratio21=NaN*latbins;
for i=1:length(latbins)-1
    id=lat21>=latbins(i) & lat21<latbins(i+1);    
    ratio21(i)=mean(dino21(id),'omitnan')./mean(diat21(id),'omitnan');
end

%%
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 1.3 4]);
plot(ratio19,latbins,'r-',ratio21,latbins,'b-')
vline(.5,'--k')
set(gca,'ylim',[39.9 49],'xlim',[0 1],'xtick',0:.5:1,'xaxislocation','top','yticklabel',...
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},...
    'fontsize',9,'tickdir','out');
box on;
xlabel({'dino:diatom'})
legend('2019','2021','Location','SW'); legend boxoff;

exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/dino_diatom_ratio.png'],'Resolution',300)    