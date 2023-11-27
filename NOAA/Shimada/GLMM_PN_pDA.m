%% factors associated with high cellular toxicity
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1; %0=don't print, 1=print
type=1; %1=discrete, 2=sensor
%yr='2019';
%yr='2021';
yr='2019 & 2021';

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');

if length(yr)==4
    if strcmp(yr,'2019')    
        P=P(P.DT<datetime('01-Jan-2020'),:);    
    elseif strcmp(yr,'2021')    
        P=P(P.DT>datetime('01-Jan-2020'),:);      
    end
else
end

P = timetable2table(P);
P=removevars(P,{'LON','LAT','gap_km','sample_km','coast_km','pDA_fgmL','filelistTB',...
    'Pseudonitzschia_small','Pseudonitzschia_medium','Pseudonitzschia_large',...
    'mean_PNwidth','PN_biovol','diatom_biovol','dino_biovol','dino_diat_ratio'...
    'tox_small','tox_medium','tox_large','tox_cell','tox_biovol'});
P.logPN=log10(P.PN_cell+1);

%glme = fitglme(P,'logPN ~ 1 + TEMP + SAL + PCO2')
%glme = fitglme(P,'logPN ~ 1 + TEMP + SAL + PCO2 + Nitrate_uM + Silicate_uM + Phosphate_uM + S2N + P2N')
glme = fitglme(P,'logPN ~ 1 + TEMP + SAL + PCO2 + Nitrate_uM + Silicate_uM + Phosphate_uM + S2N + P2N + Thalassiosira + Nitzschia + Navicula + Asterionellopsis + Eucampia')

%glme = fitglme(P,'pDA_pgmL ~ 1 + TEMP + SAL + PCO2 + Nitrate_uM + Silicate_uM + Phosphate_uM + S2N + P2N')

%%
if type==1
    X=[P.TEMP,P.SAL,P.PCO2,P.Nitrate_uM,P.Silicate_uM,P.Phosphate_uM,P.S2N,P.P2N];
    Xlabel={'Temperature' 'Salinity' 'pCO2' 'Nitrate' 'Silicate' 'Phosphate' 'Si:N' 'P:N' };
    Y=[P.PN_cell,P.pDA_pgmL];
    Ylabel={'PN' 'pDA'};
    pos=[1 1 2.5 4.3];
elseif type==2    
    X=[P.TEMP,P.SAL,P.PCO2];
    Xlabel={'Temperature' 'Salinity' 'pCO2'};
    Y=[P.PN_cell];
    Ylabel={'cells/mL'};    
    pos=[1 1 2. 2.5];
end
