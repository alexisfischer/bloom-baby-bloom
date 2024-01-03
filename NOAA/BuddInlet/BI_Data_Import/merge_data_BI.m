%% merge Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

%% merge continuous data (IFCB, Hobo T and S, Deschutes R)
%%%% load in and process IFCB data
load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB'],...
    'class2useTB','classcountTB_above_optthresh','mdateTB',...
    'filecommentTB','runtypeTB','ml_analyzedTB');

% remove discrete samples (data with file comment)
idx=contains(filecommentTB,'trigger'); 
ml_analyzedTB(idx)=[]; mdateTB(idx)=[]; filecommentTB(idx)=[]; classcountTB_above_optthresh(idx,:)=[]; runtypeTB(idx)=[];

% create new variables and put in timetable
dino=classcountTB_above_optthresh(:,contains(class2useTB,'Dinophysis'))./ml_analyzedTB;
meso=classcountTB_above_optthresh(:,contains(class2useTB,'Mesodinium'))./ml_analyzedTB;
cryp=classcountTB_above_optthresh(:,contains(class2useTB,'cryptophyta'))./ml_analyzedTB;
dt=datetime(mdateTB,'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss');
TT=timetable(dt,dino,meso,cryp);

% split dataset by PMTA and PMTB triggers
idf=contains(runtypeTB,{'NORMAL','Normal'});
ida=contains(runtypeTB,{'ALT','Alternative'});
fl=TT(idf,:); sc=TT(ida,:);

% daily average
fl=retime(fl,'daily','mean');
sc=retime(sc,'daily','mean');
TTT=synchronize(fl,sc);

% fill gaps of 2 days or less
TTT.dino_fl = fillmissing(TTT.dino_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.meso_fl = fillmissing(TTT.meso_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.cryp_fl = fillmissing(TTT.cryp_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.dino_sc = fillmissing(TTT.dino_sc,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.meso_sc = fillmissing(TTT.meso_sc,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.cryp_sc = fillmissing(TTT.cryp_sc,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));

% merge IFCB, temperature, salinity, Deschutes R discharge data
load([filepath 'NOAA/BuddInlet/Data/temp_sal_1m_3m_BuddInlet'],'H');
load([filepath 'NOAA/BuddInlet/Data/DeschutesR_discharge'],'DR');
HD = synchronize(DR,H,'first');
HD=retime(HD,'daily','mean');

T=synchronize(TTT,HD);
T.dt=datetime(T.dt,'Format','dd-MMM-yyyy');

clearvars fl sc idx TT TTT HD H DR idf ida dino meso cryp filecommentTB runtypeTB ml_analyzedTB dt mdateTB classcountTB_above_optthresh class2useTB

%% merge discrete data (DSP, microscopy)
%%%% add stratification depth to Discrete dataset
load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy_BI'],'TT'); 
load([filepath 'NOAA/BuddInlet/Data/BuddInlet_TSChl_profiles'],'B','dt');

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

T=synchronize(T,D);

clearvars idx TT

%%
save([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T');