%clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1; %0=don't print, 1=print
type=1; %1=discrete, 2=sensor
yr=1; %1=2019, 2=2021, 3=both

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
id1=find(P.DT<datetime('01-Jan-2020') & P.LAT>42.8 & P.LAT<45.3);
id2=find(P.DT>datetime('01-Jan-2020') & P.LAT>48); idP=[id1;id2];
P.Pseudonitzschia_toxic=zeros(size(P.Pseudonitzschia_large));
P.Pseudonitzschia_toxic(idP)=P.Pseudonitzschia_large(idP)+P.Pseudonitzschia_medium(idP);

P.Pseudonitzschia_nontoxic=P.Pseudonitzschia_large+P.Pseudonitzschia_medium+P.Pseudonitzschia_small;
P.Pseudonitzschia_nontoxic(idP)=0*P.Pseudonitzschia_nontoxic(idP);

%nitrate deficit relative to silicate, Si* (Si* = Si(OH)4 - NO3−) 
P.Sstar=P.SilicateM-P.NitrateM;    
%nitrate deficit relative to phosphate, P* (P* = PO43− - NO3− / 16), 
P.Pstar=P.PhosphateM-P.NitrateM./16; 

if yr==1
    idx=find(P.DT>datetime('01-Jan-2020')); P(idx,:)=[];
    yrlabel='2019';
    id1=find(P.DT<datetime('01-Jan-2020') & P.LAT>42.8 & P.LAT<45.3);
    V.TEMP.y19=nanmean(P.TEMP(id1));
    V.SAL.y19=nanmean(P.SAL(id1));
    V.Sil.y19=nanmean(P.SilicateM(id1));
    V.Sstar.y19=nanmean(P.Sstar(id1));
elseif yr==2
    idx=find(P.DT<datetime('01-Jan-2020')); P(idx,:)=[];
    yrlabel='2021';    
    id2=find(P.DT>datetime('01-Jan-2020') & P.LAT>48);
    V.TEMP21=nanmean(P.TEMP(id2));
    V.SAL21=nanmean(P.SAL(id2));
    V.Sil21=nanmean(P.SilicateM(id2));
    V.Sstar21=nanmean(P.Sstar(id2));        
elseif yr==3
    yrlabel='2019 & 2021';   
    V.TEMP=nanmean(P.TEMP(idP));
    V.SAL=nanmean(P.SAL(idP));
    V.SilicateM=nanmean(P.SilicateM(idP));
    V.Sstar=nanmean(P.Sstar(idP));    
end