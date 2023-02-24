%% make 2019 and 2021 summary file for Emilie's niche analysis
% merge IFCB data, sensor data, and discrete data
%
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   

addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

% format IFCB data
classifiername='CCS_v9';
load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB_2019-2021_' classifiername],...
    'class2useTB','classcountTB_above_optthresh','filelistTB','mdateTB','ml_analyzedTB');

dt=datetime(mdateTB,'convertfrom','datenum'); dt.Format='yyyy-MM-dd HH:mm:ss';        
cellsmL = classcountTB_above_optthresh./ml_analyzedTB;    

%%%% sum up PN
id1=find(strcmp('Pseudo_nitzschia_large_1cell,Pseudo_nitzschia_small_1cell',class2useTB));
id2=find(strcmp('Pseudo_nitzschia_large_2cell,Pseudo_nitzschia_small_2cell',class2useTB));
id3=find(strcmp('Pseudo_nitzschia_large_3cell,Pseudo_nitzschia_small_3cell',class2useTB));
id4=find(strcmp('Pseudo_nitzschia_large_4cell,Pseudo_nitzschia_small_4cell',class2useTB));

cellsmL(:,id1)=sum([cellsmL(:,id1),2*cellsmL(:,id2),3*cellsmL(:,id3),4*cellsmL(:,id4)],2);
cellsmL(:,[id2,id3,id4])=[];
class2useTB([id2,id3,id4])=[];

%%%% rename grouped classes 
class2useTB(strcmp('Cerataulina,Dactyliosolen,Detonula,Guinardia',class2useTB))={'Cera_Dact_Deto_Guin'};
class2useTB(strcmp('Chaetoceros_chain,Chaetoceros_single',class2useTB))={'Chaetoceros'};
class2useTB(strcmp('Dinophysis_acuminata,Dinophysis_acuta,Dinophysis_caudata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_odiosa,Dinophysis_parva,Dinophysis_rotundata,Dinophysis_tripos',class2useTB))={'Dinophysis'};
class2useTB(strcmp('Heterocapsa_triquetra,Scrippsiella',class2useTB))={'Hete_Scri'};
class2useTB(strcmp('Thalassiosira_chain',class2useTB))={'Thalassiosira'};
class2useTB(strcmp('Proboscia,Rhizosolenia',class2useTB))={'Prob_Rhiz'};
class2useTB(strcmp('Pseudo_nitzschia_large_1cell,Pseudo_nitzschia_small_1cell',class2useTB))={'Pseudo-nitzschia'};

clearvars ia classcountTB_above_optthresh ml_analyzedTB class_indices_path id1 id2 id3 id4 mdateTB

%% match timestamps of IFCB and sensor data
S19=load([filepath 'NOAA/Shimada/Data/environ_Shimada2019'],'DT','LON','LAT','TEMP','SAL','FL','FCO2');
S21=load([filepath 'NOAA/Shimada/Data/environ_Shimada2021'],'DT','LON','LAT','TEMP','SAL','FL','FCO2');
S.DT=[S19.DT;S21.DT];
S.LON=[S19.LON;S21.LON];
S.LAT=[S19.LAT;S21.LAT];
S.TEMP=[S19.TEMP;S21.TEMP];
S.SAL=[S19.SAL;S21.SAL];
S.FCO2=[S19.FCO2;S21.FCO2];

[idI,idS] = match_timestamps_IFCB_Shimada(dt,S.DT);
filelistTB(idI)=[]; dt(idI)=[]; cellsmL(idI,:)=[];
lat=S.LAT(idS); lon=S.LON(idS); temp=S.TEMP(idS); sal=S.SAL(idS); pco2=S.FCO2(idS);

figure; plot(lon,lat,'o'); %sanity check plot

clearvars S19 S21 idI idS S

%% match HAB data
load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA'); %GMT time
HA.dt.Format='yyyy-MM-dd HH:mm:ss';        
[idI,idS] = match_timestamps_IFCB_Shimada(HA.dt,dt);
HA(idI,:)=[]; %remove the nans

chlA_ugL=NaN*lat; chlA_ugL(idS)=HA.chlA_ugL;
pDA_ngL=NaN*lat; pDA_ngL(idS)=HA.pDA_ngL;
NitrateM=NaN*lat; NitrateM(idS)=HA.NitrateM;
PhosphateM=NaN*lat; PhosphateM(idS)=HA.PhosphateM;
SilicateM=NaN*lat; SilicateM(idS)=HA.SilicateM;
PNcellsmL_mcpy=NaN*lat; PNcellsmL_mcpy(idS)=HA.PNcellsmL;

%%
save([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis'],...
    'dt','filelistTB','lat','lon','class2useTB','cellsmL','temp','sal','pco2',...
    'chlA_ugL','pDA_ngL','NitrateM','PhosphateM','SilicateM','PNcellsmL_mcpy');