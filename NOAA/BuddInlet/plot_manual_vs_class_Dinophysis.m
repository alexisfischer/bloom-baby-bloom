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
   'class2use','ml_analyzed','matdate','classcount','filecomment');
idx=~strcmp(filecomment,{' '}); % remove discrete samples
ml_analyzed(idx)=[]; matdate(idx)=[]; classcount(idx,:)=[];

%%%% load in classified data
load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB_2021-2022'],...
    'mdateTB','class2useTB','ml_analyzedTB','classcountTB','filecommentTB','runtypeTB');

% remove backscatter triggered samples from data
idx=contains(runtypeTB,'ALT'); ml_analyzedTB(idx)=[]; mdateTB(idx)=[]; filecommentTB(idx)=[]; classcountTB(idx,:)=[];

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
figure('Units','inches','Position',[1 1 5 2],'PaperPositionMode','auto'); 

xax1=datetime('2022-06-15'); xax2=datetime('2022-07-24');     

h=plot(dtTB(:),dinoC(:),'k-',dt,dinoM,'r*',T.SampleDate,...
    .001*T.DinophysisConcentrationcellsL,'b^','linewidth',.5); hold on;
set(h(2),'markersize',6,'linewidth',1.5)
set(h(3),'markersize',5,'linewidth',1.5)
set(gca,'xlim',[xax1 xax2],'ylim',[0 20])
    datetick('x', 'mm/dd', 'keeplimits');    
    ylabel('Dinophysis (cells/mL)','fontsize',12);
    legend('IFCB (classifier)','IFCB (manual)','Microscopy','Location','NE'); 
    title('high temporal resolution, bloom closeup')

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'NOAA/BuddInlet/Figs/ManualvsClassifer.png']);
hold off

%% daily average
% classifier data
[ mdate_mat, dinoMavg, ~, ~ ] = timeseries2ydmat( mdateTB, dinoC(:) );
dtTBa=datetime(mdate_mat,'ConvertFrom','datenum');

figure('Units','inches','Position',[1 1 5 2],'PaperPositionMode','auto'); 

xax1=datetime('2021-08-01'); xax2=datetime('2022-10-01');     

h=plot(dtTBa(:),dinoMavg(:),'k-',dt,dinoM,'r*',T.SampleDate,...
    .001*T.DinophysisConcentrationcellsL,'b^','linewidth',.5); hold on;
set(h(2),'markersize',6,'linewidth',1.5)
set(h(3),'markersize',5,'linewidth',1.5)
set(gca,'xlim',[xax1 xax2])
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('Dinophysis (cells/mL)','fontsize',12);
    legend('IFCB (classifier)','IFCB (manual)','Microscopy','Location','NW');
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
