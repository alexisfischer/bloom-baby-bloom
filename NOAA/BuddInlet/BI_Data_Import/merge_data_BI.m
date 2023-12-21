%% merge Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

%%%% add stratification depth to Discrete dataset
load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy_BI'],'TT'); 
load([filepath 'NOAA/BuddInlet/Data/BuddInlet_TSChl_profiles'],'B','dt');


%%
%%%% merge discrete data

load([filepath 'NOAA/BuddInlet/Data/DSP_BI'],'D');
D.dt=dateshift(D.dt,'start','day');
TT.dt=dateshift(TT.dt,'start','day');

D=synchronize(TT,D);
D.dt=datetime(D.dt,'Format','dd-MMM-yyyy');

%remove data gaps but allow for DST lag
idx=find(~isnan(D.SampleDepthm),1); D(1:idx-1,:)=[];
D((D.dt>datetime('30-Nov-2021') & D.dt<datetime('02-Mar-2022')),:)=[];
D((D.dt>datetime('15-Oct-2022') & D.dt<datetime('23-Mar-2023')),:)=[];
D(D.dt>datetime('16-Oct-2023'),:)=[];

D=removevars(D,{'ChlMaxDepthm','ChlMaxLower1','ChlMaxUpper1','ChlMaxLower2','ChlMaxUpper2'});
D=movevars(D,{'dinoML_microscopy','mesoML_microscopy','DST'},'After','IFCBDepthm');
clearvars idx TT


%% load in and process IFCB data
load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB'],...
    'class2useTB','classcountTB_above_optthresh','filelistTB','mdateTB',...
    'filecommentTB','runtypeTB','ml_analyzedTB');

% remove discrete samples (data with file comment)
idx=contains(filecommentTB,'trigger'); 
ml_analyzedTB(idx)=[]; mdateTB(idx)=[]; filecommentTB(idx)=[]; classcountTB_above_optthresh(idx,:)=[]; runtypeTB(idx)=[]; filelistTB(idx)=[];

% create new variables and put in timetable
dt=datetime(mdateTB,'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss');
dinoML=classcountTB_above_optthresh(:,contains(class2useTB,'Dinophysis'))./ml_analyzedTB;
mesoML=classcountTB_above_optthresh(:,contains(class2useTB,'Mesodinium'))./ml_analyzedTB;
crypML=classcountTB_above_optthresh(:,contains(class2useTB,'cryptophyta'))./ml_analyzedTB;
TT=timetable(dt,filelistTB,runtypeTB,dinoML,mesoML,crypML);
TT.dt=dateshift(TT.dt,'start','minute'); 

%% merge IFCB, temperature, salinity, Deschutes R discharge data
load([filepath 'NOAA/BuddInlet/Data/temp_sal_1m_3m_BuddInlet'],'H');
load([filepath 'NOAA/BuddInlet/Data/DeschutesR_discharge'],'DR');
HD = synchronize(DR,H,'first');
T=synchronize(TT,HD,'first');

clearvars idx mdateTB ml_analyzedTB filelistTB runtypeTB class2useTB classcountTB_above_optthresh filecommentTB dt dinoML mesoML crypML H DR HD TT



save([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'D','T');