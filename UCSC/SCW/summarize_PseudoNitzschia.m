clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

class2do_string = 'Pseudo-nitzschia'; chain=4; 

filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
%[class2useTB,classcountTB,classbiovolTB,ml_analyzedTB,mdateTB]=merge_IFCBbiovol_files([filepath 'Data/IFCB_summary/class/'],{2016,2017,2018,2019})
load([filepath 'Data/IFCB_summary/class/summary_biovol_TB2016-2019'],'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB');

%%%% extract Classifier data for class of interest
id = strmatch(class2do_string, class2useTB);
[~, biovolml] = timeseries2ydmat(mdateTB, classbiovolTB(:,id)./ml_analyzedTB);
[mdate, cellsml] = timeseries2ydmat(mdateTB, chain*classcountTB(:,id)./ml_analyzedTB);
cellsml(cellsml==Inf)=NaN; biovolml(biovolml==Inf)=NaN;

%put nans before August 2016 deployment
idx=mdate(:,1)<datenum('03-Aug-2016'); cellsml(idx,1)=NaN;

note1='units=cells per mL';
note2='NaNs indicate high quality data not available';

clearvars 'classcountTB' 'classbiovolTB' 'ml_analyzedTB' 'mdateTB' 'filelistTB'

save([filepath 'Data/IFCB_summary/class/Pseudo-nizschia_cellsmL_2016-2019_SCW'],'mdate','cellsml','note1','note2');

%% test plot
figure('Units','inches','Position',[1 1 7 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.11 .05], [0.08 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2016-08-01'); xax2=datenum('2019-08-01');     

    plot(mdate,cellsml,'ko','Linewidth',1); hold on
    set(gca,'xlim',[xax1 xax2],'fontsize',13,'tickdir','out','ycolor','k');  
    datetick('x','mmmyyyy','keeplimits');    
    ylabel('cells/mL')
hold on
