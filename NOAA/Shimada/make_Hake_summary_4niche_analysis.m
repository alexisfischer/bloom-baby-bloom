%% make 2019 and 2021 summary file for Emilie's niche analysis
% merge IFCB data, sensor data, and discrete data
%
clear;

classifiername='CCS_NOAA-OSU_v7';
thm=3.4; %large PN width threshold
thl=6.5; %australis width threshold
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

%%%% match timestamps of sensor data and HAB data
%%%% merge 2019 and 2021 data
S19=load([filepath 'NOAA/Shimada/Data/environ_Shimada2019'],'DT','LON','LAT','TEMP','SAL','PCO2');
S21=load([filepath 'NOAA/Shimada/Data/environ_Shimada2021'],'DT','LON','LAT','TEMP','SAL','PCO2');
DT=[S19.DT;S21.DT]; LON=[S19.LON;S21.LON]; LAT=[S19.LAT;S21.LAT];
TEMP=[S19.TEMP;S21.TEMP]; SAL=[S19.SAL;S21.SAL]; PCO2=[S19.PCO2;S21.PCO2];
T=timetable(DT,LAT,LON,TEMP,SAL,PCO2);

load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA'); %GMT time
HA.dt.Format='yyyy-MM-dd HH:mm:ss'; HA.dt=dateshift(HA.dt,'start','minute');
H=table2timetable(HA); H=removevars(H,{'st','lat','lon','PNcellsmL','fx_pseu','fx_heim','fx_pung','fx_mult','fx_frau','fx_aust','fx_deli'});
H.pDA_pgmL(H.pDA_pgmL<0)=0; H=sortrows(H);
T = synchronize(T,H,'first','fillwithmissing');

%%%% find Euclidian distance in km between each data point
REQUIRES MAPPING TOOLBOX
T.kmi=NaN*T.Silicate_uM;
wgs84 = wgs84Ellipsoid; 
for i=1:length(idx)
    T.kmi(i)=distance(T.LAT(i),T.LON(i),T.LAT(i+1),T.LON(i+1),wgs84);
end

%%
% %% no longer using this bc have mapping toolbox
%Does not REQUIRE MAPPING TOOLBOX
%T.kmi=ones(size(T.Silicate_uM));

load([filepath 'NOAA/Shimada/Data/T_distance']);
T.km_gap=NaN*T.Silicate_uM;
X=10; % minutes. max gap allowed 
range=(1:1:10)';
dist=[flipud(range);0;range];
idx=find(~isnan(T.chlA_ugL));

%%%% duplicate HA data for X minutes before and after data collection
for i=1:length(idx)
%i=1
    %fill before
        irange=idx(i)-X:idx(i)-1;
        T.km_gap(irange)=flipud(cumsum([T.kmi(irange)]));
    %fill after
        irange=idx(i)+1:idx(i)+X;
        T.km_gap(irange)=cumsum([T.kmi(irange)]);
        T.km_gap(idx(i))=0;

    irange=idx(i)-X:idx(i)+X;
    T.chlA_ugL(irange)=T.chlA_ugL(idx(i));
    T.pDA_pgmL(irange)=T.pDA_pgmL(idx(i));
    T.Nitrate_uM(irange)=T.Nitrate_uM(idx(i));
    T.Phosphate_uM(irange)=T.Phosphate_uM(idx(i));
    T.Silicate_uM(irange)=T.Silicate_uM(idx(i));
    T.S2N(irange)=T.S2N(idx(i));
    T.P2N(irange)=T.P2N(idx(i));      
end
%%
T.km_gap=T.km_gap*.5;

clearvars S19 S21 LON LAT TEMP SAL PCO2 H HA DT i 


%% format IFCB data
load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB_' classifiername],...
    'class2useTB','classcountTB_above_optthresh','classbiovolTB_above_optthresh','filelistTB','mdateTB','ml_analyzedTB');

dt=datetime(mdateTB,'convertfrom','datenum'); dt.Format='yyyy-MM-dd HH:mm:ss';        
cellsmL = classcountTB_above_optthresh./ml_analyzedTB;    

%%%% sum PN biovolume into one variable all variables except and PN from regular summary
id1=find(contains(class2useTB,'Pseudo-nitzschia_large_1cell')); 
id2=find(contains(class2useTB,'Pseudo-nitzschia_large_2cell')); 
id3=find(contains(class2useTB,'Pseudo-nitzschia_large_3cell')); 
PN_bvmL = sum(classbiovolTB_above_optthresh(:,[id1,id2,id3]),2)./ml_analyzedTB;

%%%% get ratio of of dinos to diatoms 
% sum diatom biovolume
[idiatom,~]=get_class_ind(class2useTB,'diatom',[filepath 'IFCB-Tools/convert_index_class/class_indices']);
[idino,~]=get_class_ind(class2useTB,'dinoflagellate',[filepath 'IFCB-Tools/convert_index_class/class_indices']);
diatom_bvmL=sum(classbiovolTB_above_optthresh(:,idiatom),2)./ml_analyzedTB;
dino_bvmL=sum(classbiovolTB_above_optthresh(:,idino),2)./ml_analyzedTB;
dino_diat_ratio=dino_bvmL./diatom_bvmL;

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
medPN1=smallPN1; medPN2=smallPN1; medPN3=smallPN1;
largePN1=smallPN1; largePN2=smallPN1; largePN3=smallPN1;

for i=1:length(PNwidth_opt)
    ids=(PNwidth_opt(i).cell1<thm);
    idm=(PNwidth_opt(i).cell1>=thm & PNwidth_opt(i).cell1<thl);
    idl=(PNwidth_opt(i).cell1>=thl);
    smallPN1(i)=sum(ids); medPN1(i)=sum(idm); largePN1(i)=sum(idl);
    
    ids=(PNwidth_opt(i).cell2<thm);
    idm=(PNwidth_opt(i).cell2>=thm & PNwidth_opt(i).cell2<thl);
    idl=(PNwidth_opt(i).cell2>=thl);
    smallPN2(i)=sum(ids); medPN2(i)=sum(idm); largePN2(i)=sum(idl);
    
    ids=(PNwidth_opt(i).cell3<thm);
    idm=(PNwidth_opt(i).cell3>=thm & PNwidth_opt(i).cell3<thl);
    idl=(PNwidth_opt(i).cell3>=thl);
    smallPN3(i)=sum(ids); medPN3(i)=sum(idm); largePN3(i)=sum(idl);
end

%sum up by cell count
cellsmL(:,end+1)=sum([smallPN1,2*smallPN2,3.5*smallPN3],2)./ml_analyzedTB;
cellsmL(:,end+1)=sum([medPN1,2*medPN2,3.5*medPN3],2)./ml_analyzedTB;
cellsmL(:,end+1)=sum([largePN1,2*largePN2,3.5*largePN3],2)./ml_analyzedTB;
class2useTB(end+1)={'Pseudonitzschia_small'};
class2useTB(end+1)={'Pseudonitzschia_medium'};
class2useTB(end+1)={'Pseudonitzschia_large'};

%mean width
width=[PNwidth_opt.mean]';
width(isnan(width))=0;
cellsmL(:,end+1)=width;
class2useTB(end+1)={'mean_PNwidth'};

%sum all PN
cellsmL(:,end+1)=sum([cellsmL(:,contains(class2useTB,'Pseudonitzschia'))],2);
class2useTB(end+1)={'PN_cell'};

%add biovol
cellsmL(:,end+1)=PN_bvmL;
cellsmL(:,end+1)=diatom_bvmL;
cellsmL(:,end+1)=dino_bvmL;
cellsmL(:,end+1)=dino_diat_ratio;
class2useTB(end+1)={'PN_biovol'};
class2useTB(end+1)={'diatom_biovol'};
class2useTB(end+1)={'dino_biovol'};
class2useTB(end+1)={'dino_diat_ratio'};

%%%% round IFCB data to nearest minute and match with environmental data
dt=dateshift(dt,'start','minute'); 
TT = array2timetable(cellsmL(:,1:end),'RowTimes',dt,'VariableNames',class2useTB(1:end));
TT=addvars(TT,filelistTB,'Before',class2useTB(1));

clearvars class2useTB th dt cellsmL filelistTB i idx ml_analyzedTB PNwidth_opt mdateTB smallPN1 smallPN2 smallPN3 largePN1 largePN2 largePN3

%% merge environmental data with IFCB data
P=synchronize(TT,T,'first');

P.pDA_fgmL=P.pDA_pgmL.*0.001.*1000000; %convert to fg/mL

% make 2019 and 2021 datasets equivalent
P(P.LAT<40,:)=[]; % remove data south of 40 N
P(P.LAT>47.5 & P.LON>-124.7,:)=[]; %remove data from the Strait
P=movevars(P,{'LAT' 'LON' 'km_gap' 'TEMP' 'SAL' 'PCO2' 'Nitrate_uM' 'Phosphate_uM' ...
    'Silicate_uM' 'P2N' 'S2N' 'chlA_ugL' 'pDA_pgmL' 'pDA_fgmL'},'Before','filelistTB');
P(isnan(P.LAT),:)=[];

%%find toxicity/cell and toxicity/biovolume
P.tox_small=P.pDA_fgmL./P.Pseudonitzschia_small;
P.tox_medium=P.pDA_fgmL./P.Pseudonitzschia_medium;
P.tox_large=P.pDA_fgmL./P.Pseudonitzschia_large;
P.tox_cell=P.pDA_fgmL./P.PN_cell;
P.tox_biovol=P.pDA_fgmL./P.PN_biovol;

P.tox_small(P.tox_small==Inf)=0;
P.tox_medium(P.tox_medium==Inf)=0;
P.tox_large(P.tox_large==Inf)=0;
P.tox_cell(P.tox_cell==Inf)=0;
P.tox_biovol(P.tox_biovol==Inf)=0;

%% format for .csv file
writetimetable(TT,[filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.csv'])
save([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');

clearvars E T idx X
