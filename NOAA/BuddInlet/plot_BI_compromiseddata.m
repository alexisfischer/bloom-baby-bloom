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
load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB_2021-2022'],...
    'mdateTB','class2useTB','ml_analyzedTB','classcountTB','filecommentTB','runtypeTB');

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
idc=(strcmp('Dinophysis,Dinophysis_acuminata,Dinophysis_acuta,Dinophysis_caudata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_odiosa,Dinophysis_parva,Dinophysis_rotundata,Dinophysis_tripos',class2useTB));
dinoC=(classcountTB(:,idc)./ml_analyzedTB);
idc=(strcmp('cryptophyta',class2useTB));
dtTB=datetime(mdateTB,'ConvertFrom','datenum');

idm=find(ismember(class2use,{'D_acuminata' 'D_acuta' 'D_caudata' 'D_fortii'...
    'D_norvegica' 'D_odiosa' 'D_parva' 'D_rotundata' 'D_tripos' 'Dinophysis'}));
dinoM=sum(classcount(:,idm),2)./ml_analyzed;
dt=datetime(matdate,'ConvertFrom','datenum');

%%%% plot Dinophysis manual vs classifier
%% full temporal resolution on 2022
figure('Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto'); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.1 0.05], [0.2 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datetime('2022-06-20'); xax2=datetime('2022-10-01');     

subplot(3,1,1)
d1=[datetime('18-Jul-2022') datetime('26-Jul-2022') datetime('26-Jul-2022') datetime('18-Jul-2022')];
d2=[datetime('08-Sep-2022') datetime('12-Sep-2022') datetime('12-Sep-2022') datetime('08-Sep-2022')];
d3=[datetime('23-Sep-2022') datetime('28-Sep-2022') datetime('28-Sep-2022') datetime('23-Sep-2022')];

    h1=patch(d1,[0 0 10000 10000],'y'); hold on
    patch(d2,[0 0 10000 10000],'y'); hold on
    patch(d3,[0 0 10000 10000],'y'); hold on

    trigger=sum(classcountTB,2);
    plot(datetime(mdateTB,'convertfrom','datenum'),trigger,'k.','markersize',2);
    hold on;
    set(gca,'xaxislocation','top','xlim',[xax1 xax2],'ylim',[0 10000]);
        datetick('x', 'mm/dd', 'keeplimits');    
    ylabel('total IFCB images'); box on;
    legend(h1,'compromised?','location','n'); legend boxoff

subplot(3,1,2)
h=plot(T.SampleDate,T.IFCBSampleDepthm,'r--',T.SampleDate,T.SampleDepths,'b:',...
    [T.SampleDate';T.SampleDate'],[T.ChlMaxLower1';T.ChlMaxUpper1'],'g',...
    [T.SampleDate';T.SampleDate'],[T.ChlMaxLower2';T.ChlMaxUpper2'],'g','linewidth',2);
    set(h(3),'linewidth',5)
    set(h(4),'linewidth',5)
    datetick('x', 'mm/dd', 'keeplimits');        
    set(gca,'xlim',[xax1 xax2],'ylim',[0 7],'YDir','reverse','xticklabel',{});
    ylabel('Depth (m)','fontsize',12);
    legend('IFCB samples','Discrete samples','Chl Max','Location','SE'); legend boxoff;
    hold on

subplot(3,1,3)
%dtTB(:),dinoC(:),'k-',
plot(dt,dinoM,'r*',T.SampleDate,.001*T.DinophysisConcentrationcellsL,'b^','markersize',5,'linewidth',1.5); hold on;
    set(gca,'xlim',[xax1 xax2],'ylim',[0 17]);
    datetick('x', 'mm/dd', 'keeplimits');    
    ylabel('Dinophysis (cells/mL)','fontsize',12);
    legend('IFCB (manual)','Microscopy','Location','N'); legend boxoff

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'NOAA/BuddInlet/Figs/ManualvsClassifer.png']);
hold off

%% daily average
% classifier data
[ mdate_mat, dinoMavg, ~, ~ ] = timeseries2ydmat( mdateTB, dinoC(:) );
dtTBa=datetime(mdate_mat,'ConvertFrom','datenum');

figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto'); 

xax1=datetime('2021-08-01'); xax2=datetime('2022-10-01');     

subplot(2,1,1)
h=plot(T.SampleDate,T.IFCBSampleDepthm,'r--',T.SampleDate,T.SampleDepths,'b:',...
    [T.SampleDate';T.SampleDate'],[T.ChlMaxLower1';T.ChlMaxUpper1'],'g',...
    [T.SampleDate';T.SampleDate'],[T.ChlMaxLower2';T.ChlMaxUpper2'],'g','linewidth',2);
    set(h(3),'linewidth',5)
    set(h(4),'linewidth',5)
    set(gca,'xlim',[xax1 xax2],'ylim',[0 7],'YDir','reverse');
    ylabel('Depth (m)','fontsize',12);
    legend('IFCB samples','Discrete samples','Chl Max','Location','SW'); legend boxoff;
hold on

subplot(2,1,2)
%dtTBa(:),dinoMavg(:),'k-',
h=plot(dt,dinoM,'r*',T.SampleDate,...
    .001*T.DinophysisConcentrationcellsL,'b^','markersize',5,'linewidth',1.5); hold on;
set(gca,'xlim',[xax1 xax2])
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('Dinophysis (cells/mL)','fontsize',12);
    legend('IFCB (manual)','Microscopy','Location','NW'); legend boxoff
    title('daily average')

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'NOAA/BuddInlet/Figs/ManualvsClassifer_dailyaverage.png']);
hold off

%%
% % discrete classifier data
% [ mdateBS, BS, ~, ~ ] = timeseries2ydmat( mdateBS, (classcountBS(:,idc)./ml_analyzedBS) );
% dtBS=datetime(mdateBS,'ConvertFrom','datenum');
% 
% [ mdateFL, FL, ~, ~ ] = timeseries2ydmat( mdateFL, (classcountFL(:,idc)./ml_analyzedFL) );
% dtFL=datetime(mdateFL,'ConvertFrom','datenum');


% subplot(2,1,2); %discrete
% plot(dtBS,BS,'bs',dtFL,FL,'m^'); hold on;
%     set(gca,'xlim',[xax1 xax2],'ylim',[0 17])
%     datetick('x', 'mmm', 'keeplimits');    
%     ylabel('Dinophysis (cells/mL)','fontsize',12);
%     legend('BS','FL','Location','NW'); legend boxoff;
%     title('Discrete classified samples')
