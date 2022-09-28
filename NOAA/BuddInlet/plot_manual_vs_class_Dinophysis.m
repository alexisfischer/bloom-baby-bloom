% plot Dinophysis in Budd Inlet
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;
fprint=0;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
load([filepath 'IFCB-Data/BuddInlet/manual/count_class_manual'],...
   'class2use','ml_analyzed','matdate','classcount','filecomment');
load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB2022'],...
    'class2useTB','ml_analyzedTB','mdateTB','classcountTB','filecommentTB');
load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy'],'T');
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); 

%%%% separate discrete samples (data with file comment)
idx=contains(filecommentTB,' BS_trigger'); ml_analyzedBS=ml_analyzedTB(idx); mdateBS=mdateTB(idx); classcountBS=classcountTB(idx,:);
idx=contains(filecommentTB,' FL_trigger'); ml_analyzedFL=ml_analyzedTB(idx); mdateFL=mdateTB(idx); classcountFL=classcountTB(idx,:);

% delete all discrete from in situ data
idx=~strcmp(filecommentTB,{' '}); %classifier files
ml_analyzedTB(idx)=[]; mdateTB(idx)=[]; filecommentTB(idx)=[]; classcountTB(idx,:)=[];

idx=~strcmp(filecomment,{' '}); %manual files
ml_analyzed(idx)=[]; matdate(idx)=[]; classcount(idx,:)=[];

%%%% prepare for plotting
% classifier data
idc=(strcmp('Dinophysis,Dinophysis_acuminata,Dinophysis_acuta,Dinophysis_caudata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_odiosa,Dinophysis_parva,Dinophysis_rotundata,Dinophysis_tripos',class2useTB));
%classifier=(classcountTB(:,idc)./ml_analyzedTB);
[ mdate_mat, classifier, ~, ~ ] = timeseries2ydmat( mdateTB, (classcountTB(:,idc)./ml_analyzedTB) );
dtTB=datetime(mdate_mat,'ConvertFrom','datenum');

% discrete classifier data
[ mdateBS, BS, ~, ~ ] = timeseries2ydmat( mdateBS, (classcountBS(:,idc)./ml_analyzedBS) );
dtBS=datetime(mdateBS,'ConvertFrom','datenum');

[ mdateFL, FL, ~, ~ ] = timeseries2ydmat( mdateFL, (classcountFL(:,idc)./ml_analyzedFL) );
dtFL=datetime(mdateFL,'ConvertFrom','datenum');

% manual data
idm=find(ismember(class2use,{'D_acuminata' 'D_acuta' 'D_caudata' 'D_fortii'...
    'D_norvegica' 'D_odiosa' 'D_parva' 'D_rotundata' 'D_tripos' 'Dinophysis'}));
manual=sum(classcount(:,idm),2)./ml_analyzed;
dt=datetime(matdate,'ConvertFrom','datenum');

%%%% plot Dinophysis manual vs classifier
figure('Units','inches','Position',[1 1 3.5 2],'PaperPositionMode','auto'); 

xax1=datetime('2021-08-01'); xax2=datetime('2022-10-01');     

plot(dtTB,classifier,'k-',dt,manual,'r*'); hold on;
    set(gca,'xlim',[xax1 xax2])
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('Dinophysis (cells/mL)','fontsize',12);
    legend('Classifier','Manual','Location','NW'); legend boxoff;
    title('In situ')

% subplot(2,1,2); %discrete
% plot(dtBS,BS,'bs',dtFL,FL,'m^'); hold on;
%     set(gca,'xlim',[xax1 xax2],'ylim',[0 17])
%     datetick('x', 'mmm', 'keeplimits');    
%     ylabel('Dinophysis (cells/mL)','fontsize',12);
%     legend('BS','FL','Location','NW'); legend boxoff;
%     title('Discrete classified samples')

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'NOAA/BuddInlet/Figs/ManualvsClassifer.png']);
hold off
