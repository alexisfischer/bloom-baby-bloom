%% make 2019 and 2021 summary file for Emilie's niche analysis
% merge IFCB data, sensor data, and discrete data
%
clear;

th=3.9; %small and large PN width threshold
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

%% match timestamps of sensor data and HAB data
%%%% merge 2019 and 2021 data
S19=load([filepath 'NOAA/Shimada/Data/environ_Shimada2019'],'DT','LON','LAT','TEMP','SAL','PCO2');
S21=load([filepath 'NOAA/Shimada/Data/environ_Shimada2021'],'DT','LON','LAT','TEMP','SAL','PCO2');
DT=[S19.DT;S21.DT]; LON=[S19.LON;S21.LON]; LAT=[S19.LAT;S21.LAT];
TEMP=[S19.TEMP;S21.TEMP]; SAL=[S19.SAL;S21.SAL]; PCO2=[S19.PCO2;S21.PCO2];
T=timetable(DT,LAT,LON,TEMP,SAL,PCO2);

load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA'); %GMT time
HA.dt.Format='yyyy-MM-dd HH:mm:ss'; HA.dt=dateshift(HA.dt,'start','minute');
H=table2timetable(HA); H=removevars(H,{'st','lat','lon','PNcellsmL'});
H.pDA_ngL(H.pDA_ngL<0)=0; H=sortrows(H);
T = synchronize(T,H,'first','fillwithmissing');

%%%% duplicate HA data for 11 minutes before and after data collection
val=11;
idx=find(~isnan(T.chlA_ugL));
for i=1:length(idx)
    T.chlA_ugL(idx(i)-val:idx(i)+val)=T.chlA_ugL(idx(i));
    T.pDA_ngL(idx(i)-val:idx(i)+val)=T.pDA_ngL(idx(i));
    T.NitrateM(idx(i)-val:idx(i)+val)=T.NitrateM(idx(i));
    T.PhosphateM(idx(i)-val:idx(i)+val)=T.PhosphateM(idx(i));
    T.SilicateM(idx(i)-val:idx(i)+val)=T.SilicateM(idx(i));
end

clearvars S19 S21 LON LAT TEMP SAL PCO2 H HA DT idx i val

%% format IFCB data
classifiername='CCS_NOAA-OSU_v7';
load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB_' classifiername],...
    'class2useTB','classcountTB_above_optthresh','filelistTB','mdateTB','ml_analyzedTB');

dt=datetime(mdateTB,'convertfrom','datenum'); dt.Format='yyyy-MM-dd HH:mm:ss';        
cellsmL = classcountTB_above_optthresh./ml_analyzedTB;    

%%%% rename grouped classes 
class2useTB(strcmp('Cerataulina,Dactyliosolen,Detonula,Guinardia',class2useTB))={'Cera_Dact_Deto_Guin'};
class2useTB(strcmp('Chaetoceros_chain,Chaetoceros_single',class2useTB))={'Chaetoceros'};
class2useTB(strcmp('Dinophysis_acuminata,Dinophysis_acuta,Dinophysis_caudata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_odiosa,Dinophysis_parva,Dinophysis_rotundata,Dinophysis_tripos',class2useTB))={'Dinophysis'};
class2useTB(strcmp('Heterocapsa_triquetra,Scrippsiella',class2useTB))={'Hete_Scri'};
class2useTB(strcmp('Thalassiosira_chain',class2useTB))={'Thalassiosira'};
class2useTB(strcmp('Proboscia,Rhizosolenia',class2useTB))={'Prob_Rhiz'};

%%%% remove unclassified and PN from regular summary
idx=contains(class2useTB,'Pseudo-nitzschia'); cellsmL(:,idx)=[]; class2useTB(idx)=[];
idx=contains(class2useTB,'unclassified'); cellsmL(:,idx)=[]; class2useTB(idx)=[];
clearvars ml_analyzedTB idx classcountTB_above_optthresh mdateTB

%% split PN into small and large cells
load([filepath 'IFCB-Data/Shimada/class/summary_PN_allTB_micron-factor3.8'],'PNwidth_opt','ml_analyzedTB');

%preallocate
smallPN1=NaN*ml_analyzedTB; smallPN2=smallPN1; smallPN3=smallPN1; 
largePN1=smallPN1; largePN2=smallPN1; largePN3=smallPN1;
for i=1:length(PNwidth_opt)
    idx=(PNwidth_opt(i).cell1<th);
    smallPN1(i)=sum(idx); largePN1(i)=sum(~idx);
    
    idx=(PNwidth_opt(i).cell2<th);
    smallPN2(i)=sum(idx); largePN2(i)=sum(~idx);
    
    idx=(PNwidth_opt(i).cell3<th);
    smallPN3(i)=sum(idx); largePN3(i)=sum(~idx);
end

%sum up by cell count
cellsmL(:,end+1)=sum([smallPN1,2*smallPN2,3.5*smallPN3],2)./ml_analyzedTB;
cellsmL(:,end+1)=sum([largePN1,2*largePN2,3.5*largePN3],2)./ml_analyzedTB;
class2useTB(end+1)={'Pseudonitzschia_small'};
class2useTB(end+1)={'Pseudonitzschia_large'};

%%%% round IFCB data to nearest minute and match with environmental data
dt=dateshift(dt,'start','minute'); 
TT = array2timetable(cellsmL(:,1:end),'RowTimes',dt,'VariableNames',class2useTB(1:end));
TT=addvars(TT,filelistTB,'Before',class2useTB(1));

clearvars class2useTB th dt cellsmL filelistTB i idx ml_analyzedTB PNwidth_opt mdateTB smallPN1 smallPN2 smallPN3 largePN1 largePN2 largePN3

%% merge environmental data with IFCB data
TT=synchronize(TT,T,'first');

% make 2019 and 2021 datasets equivalent
TT(TT.LAT<40,:)=[]; % remove data south of 40 N
TT(TT.LAT>47.5 & TT.LON>-124.7,:)=[]; %remove data from the Strait
P=TT;

%%%% remove sensor data gaps
idx=ismissing(TT.TEMP); TT(idx,:)=[];
idx=ismissing(TT.PCO2); TT(idx,:)=[];

%% format for .csv file
writetimetable(TT,[filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.csv'])
save([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'TT','P');

clearvars I E T idx val
