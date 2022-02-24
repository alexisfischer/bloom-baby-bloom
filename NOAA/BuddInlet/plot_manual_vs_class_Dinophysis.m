% plot Dinophysis in Budd Inlet
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;
fprint=0;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
load([filepath 'IFCB-Data/BuddInlet/manual/count_class_manual_2021'],...
    'class2use','ml_analyzed','matdate','classcount');
load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB2021'],...
    'class2useTB','ml_analyzedTB','mdateTB','classcountTB');
load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy'],'T');
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); 

dtTB=datetime(mdateTB,'ConvertFrom','datenum');
dt=datetime(matdate,'ConvertFrom','datenum');

% plot Dinophysis manual vs classifier
figure('Units','inches','Position',[1 1 3.5 2],'PaperPositionMode','auto'); 

xax1=datetime('2021-08-01'); xax2=datetime('2021-11-20');     

idc=(strcmp('D_acuminata,D_acuta,D_caudata,D_fortii,D_norvegica,D_odiosa,D_parva,D_rotundata,D_tripos,Dinophysis',class2useTB));
classifier=(classcountTB(:,idc)./ml_analyzedTB);
idm=find(ismember(class2use,{'D_acuminata' 'D_acuta' 'D_caudata' 'D_fortii'...
    'D_norvegica' 'D_odiosa' 'D_parva' 'D_rotundata' 'D_tripos' 'Dinophysis'}));
manual=sum(classcount(:,idm),2)./ml_analyzed;

plot(dtTB,classifier,'k-',dt,manual,'r*'); hold on;

set(gca,'xlim',[xax1 xax2])
datetick('x', 'mmm', 'keeplimits');    
ylabel('Dinophysis (cells/mL)','fontsize',12);
legend('Classifier','Manual');
