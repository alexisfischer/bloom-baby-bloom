% plot Dinophysis in Budd Inlet
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;
fprint=0;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); 

%%%% load in manual data
load([filepath 'IFCB-Data/BuddInlet/manual/count_class_manual'],...
   'class2use','ml_analyzed','matdate','classcount','filecomment','runtype');
idx=~strcmp(filecomment,{' '}); % remove discrete samples
ml_analyzed(idx)=[]; matdate(idx)=[]; classcount(idx,:)=[]; runtype(idx)=[];

%%%% load in classified data
load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB'],...
    'mdateTB','class2useTB','ml_analyzedTB','classcountTB_above_optthresh','filecommentTB','runtypeTB');
classcountTB=classcountTB_above_optthresh;

% remove backscatter triggered samples from data
idx=contains(runtypeTB,'ALT'); ml_analyzedTB(idx)=[]; mdateTB(idx)=[]; filecommentTB(idx)=[]; classcountTB(idx,:)=[];
idx=contains(runtype,'ALT'); ml_analyzed(idx)=[]; matdate(idx)=[]; filecomment(idx)=[]; classcount(idx,:)=[];

% separate discrete samples (data with file comment)
idx=contains(filecommentTB,' BS_trigger'); ml_analyzedBS=ml_analyzedTB(idx); mdateBS=mdateTB(idx); classcountBS=classcountTB(idx,:);
idx=contains(filecommentTB,' FL_trigger'); ml_analyzedFL=ml_analyzedTB(idx); mdateFL=mdateTB(idx); classcountFL=classcountTB(idx,:);

% delete all discrete from in situ data
idx=~strcmp(filecommentTB,{' '}); %classifier files
ml_analyzedTB(idx)=[]; mdateTB(idx)=[]; filecommentTB(idx)=[]; classcountTB(idx,:)=[];

%%%% load in microscopy data
load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy'],'T');

%%%% prepare for plotting
dinoC=(classcountTB(:,contains(class2useTB,'Dinophysis'))./ml_analyzedTB);
dtTB=datetime(mdateTB,'ConvertFrom','datenum');

dinoM=sum(classcount(:,contains(class2use,'Dinophysis')),2)./ml_analyzed;
dt=datetime(matdate,'ConvertFrom','datenum');

%%%% plot Dinophysis manual vs classifier
% full temporal resolution on 2022
figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto'); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.12], [0.2 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datetime('2022-06-20'); xax2=datetime('2022-09-28');     

subplot(2,1,1)
plot(T.SampleDate,T.IFCBSampleDepthm,'r--','linewidth',2);hold on;
plot(T.SampleDate,T.SampleDepths,'b:','linewidth',2);hold on;
plot([T.SampleDate';T.SampleDate'],[T.ChlMaxLower1';T.ChlMaxUpper1'],'g','linewidth',5);hold on;
plot([T.SampleDate';T.SampleDate'],[T.ChlMaxLower2';T.ChlMaxUpper2'],'g','linewidth',5);hold on;
    set(gca,'xaxislocation','top','xlim',[xax1 xax2],'ylim',[0 7],'YDir','reverse');
   % datetick('x', 'mm/dd', 'keeplimits');            
    ylabel('Depth (m)','fontsize',12);
    legend('IFCB samples','Discrete samples','Chl Max','Location','SE'); legend boxoff;
    hold on

subplot(2,1,2)
%dtTB(:),dinoC(:),'k-',
plot(dt,dinoM,'r*',T.SampleDate,.001*T.DinophysisConcentrationcellsL,'b^','markersize',5,'linewidth',1.5); hold on;
    set(gca,'xlim',[xax1 xax2],'ylim',[0 20]);
    %datetick('x', 'mm/dd', 'keeplimits');    
    ylabel({'Dinophysis';'(cells/mL)'},'fontsize',12);
    legend('IFCB (manual)','Microscopy','Location','N'); legend boxoff

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'NOAA/BuddInlet/Figs/BI_Discrete_vs_IFCB.png']);
hold off

%% manual vs classifier
figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.12], [0.2 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datetime('2022-04-01'); xax2=datetime('2022-10-01');     

subplot(2,1,1)
plot(datetime(mdateTB,'convertfrom','datenum'),classcountTB(:,contains(class2useTB,'Dinophysis'))./ml_analyzedTB,'k-',...
    dt,dinoM,'r*');
set(gca,'xaxislocation','top','ylim',[0 20],'xlim',[xax1 xax2])
%datetick('x', 'm', 'keeplimits');    
    ylabel({'Dinophysis';'(cells/mL)'},'fontsize',12);

subplot(2,1,2)
idx=contains(class2useTB,'Mesodinium');
h=plot(datetime(mdateTB,'convertfrom','datenum'),classcountTB(:,contains(class2useTB,'Mesodinium'))./ml_analyzedTB,'k-',...
    dt,classcount(:,contains(class2use,'Mesodinium'))./ml_analyzed,'r*');
set(gca,'ylim',[0 20],'xlim',[xax1 xax2])
%datetick('x', 'm', 'keeplimits');    
    ylabel({'Mesodinium';'(cells/mL)'},'fontsize',12);
legend([h(2),h(1)],'manual','classifier','Location','NE'); legend boxoff;

%%
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'NOAA/BuddInlet/Figs/BI_IFCB_ManualvsClassifer.png']);
hold off

