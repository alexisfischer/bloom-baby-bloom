%% merge Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

%%%% merge continuous data (IFCB, Hobo T and S, Deschutes R)
%%%% load in and process IFCB data
load([filepath 'IFCB-Data/BuddInlet/class/summary_cells_allTB_2021_2023'],...
    'class2useTB','classcount_above_adhocthreshTB','filecommentTB','runtypeTB','mdateTB','ml_analyzedTB');

% remove discrete samples (data with file comment)
idx=contains(filecommentTB,'trigger'); 
ml_analyzedTB(idx)=[]; mdateTB(idx)=[]; filecommentTB(idx)=[]; runtypeTB(idx)=[];
classcount_above_adhocthreshTB(idx,:)=[]; 

% create new variables and put in timetable
dino=classcount_above_adhocthreshTB(:,contains(class2useTB,'Dinophysis'))./ml_analyzedTB;
meso=classcount_above_adhocthreshTB(:,contains(class2useTB,'Mesodinium'))./ml_analyzedTB;
cryp=classcount_above_adhocthreshTB(:,contains(class2useTB,'cryptophyta'))./ml_analyzedTB;
dt=datetime(mdateTB,'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss');
TT=timetable(dt,dino,meso,cryp);

% split dataset by PMTA and PMTB triggers
idf=contains(runtypeTB,{'NORMAL','Normal'});
ida=contains(runtypeTB,{'ALT','Alternative'});
fli=TT(idf,:); sci=TT(ida,:);

%%%% daily average/max
fl=retime(fli,'daily','mean');
sc=retime(sci,'daily','mean');
TTT=synchronize(fl,sc);

% fill gaps of 2 days or less
TTT.dino_fl = fillmissing(TTT.dino_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.meso_fl = fillmissing(TTT.meso_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.cryp_fl = fillmissing(TTT.cryp_fl,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.dino_sc = fillmissing(TTT.dino_sc,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.meso_sc = fillmissing(TTT.meso_sc,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));
TTT.cryp_sc = fillmissing(TTT.cryp_sc,'linear','SamplePoints',TTT.dt,'MaxGap',days(3));

%%%% merge IFCB, temperature, salinity, Deschutes R discharge data
load([filepath 'NOAA/BuddInlet/Data/temp_sal_1m_3m_BuddInlet'],'H');
load([filepath 'NOAA/BuddInlet/Data/DeschutesR_discharge'],'DR');
load([filepath 'NOAA/BuddInlet/Data/OlympiaWeather'],'W');

% daily average
HD = synchronize(DR,W,H,'first');
HD=retime(HD,'daily','mean');
T=synchronize(TTT,HD);
T.dt=datetime(T.dt,'Format','dd-MMM-yyyy');

clearvars HD Hc fl sc idx TT TTT idf ida dino meso cryp dt dinoG *TB 

%%%% match up IFCB continuous data with manual data
load([filepath 'IFCB-Data/BuddInlet/manual/count_class_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');
dt=datetime(matdate,'convertfrom','datenum','Format','dd-MMM-yyyy HH:mm:ss');

M_dacum=classcount(:,contains(class2use,'Dinophysis_acuminata'))./ml_analyzed;
M_dfort=classcount(:,contains(class2use,'Dinophysis_fortii'))./ml_analyzed;
M_dnorv=classcount(:,contains(class2use,'Dinophysis_norvegica'))./ml_analyzed;
M_dparv=classcount(:,contains(class2use,'Dinophysis_parva'))./ml_analyzed;

imclass=find(contains(class2use,'Mesodinium'));
M_meso=sum(classcount(:,imclass),2)./ml_analyzed;

M=timetable(dt,M_dacum,M_dfort,M_dnorv,M_dparv,M_meso);

Tc=synchronize(fli,M);

clearvars M* filelist class2use dt classcount matdate ml_analyzed imclass

%%%% match up continuous data with exact IFCB data
Hc = synchronize(DR,W,H,'first');
Hc.AWND = fillmissing(Hc.AWND,'linear','SamplePoints',Hc.dt,'MaxGap',days(3));
Hc.PRCP = fillmissing(Hc.PRCP,'linear','SamplePoints',Hc.dt,'MaxGap',days(3));
Hc.TAVG = fillmissing(Hc.TAVG,'linear','SamplePoints',Hc.dt,'MaxGap',days(3));
Tc.dt=dateshift(Tc.dt,'start','minute');
Tc=synchronize(Tc,Hc,'first');

clearvars Hc H DR 

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
save([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T','Tc','fli','sci');