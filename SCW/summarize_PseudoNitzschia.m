clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

class2do_string = 'Pseudo-nitzschia'; chain=4; 

filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
%[class2useTB,classcountTB,classbiovolTB,ml_analyzedTB,mdateTB,filelistTB]=merge_2yrs_IFCBbiovol([filepath 'Data/IFCB_summary/class/'],'2018','2019');
load([filepath 'Data/IFCB_summary/class/summary_biovol_TB2018_2019'],'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

%%%% (1) extract Classifier data for class of interest
id = strmatch(class2do_string, class2useTB);
[~, biovolml] = timeseries2ydmat(mdateTB, classbiovolTB(:,id)./ml_analyzedTB);
[mdate, cellsml] = timeseries2ydmat(mdateTB, chain*classcountTB(:,id)./ml_analyzedTB);
cellsml(cellsml==Inf)=NaN; biovolml(biovolml==Inf)=NaN;

clearvars 'classcountTB' 'classbiovolTB' 'ml_analyzedTB' 'mdateTB' 'filelistTB'

note1='units=cells per mL';
note2='NaNs indicate high quality data not available';

save([filepath 'Data/IFCB_summary/class/Pseudo-nizschia_cellsmL_2018_2019_SCW'],'mdate','cellsml','note1','note2');

%% test plot
figure('Units','inches','Position',[1 1 8.5 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.11 .05], [0.08 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2019-10-01');     

subplot(2,1,1)
    plot(mdate,cellsml,'ko','Linewidth',1); hold on
    set(gca,'xlim',[xax1 xax2],'fontsize',13,'tickdir','out','ycolor','k');  
    datetick('x','mmmyyyy','keeplimits');    
hold on

% subplot(2,1,2)
%     plot(mdate,biovolml,'ko','Linewidth',1); hold on
%     set(gca,'xlim',[xax1 xax2],'fontsize',13,'tickdir','out','ycolor','k');  
%     datetick('x','mmmyyyy','keeplimits');    