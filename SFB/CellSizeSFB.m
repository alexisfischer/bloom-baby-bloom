%% prepare 15 Mar 2018, st 18 USGS cruise data for Cloern and Jassby

% whole water: D20180315T175935_IFCB113 row 43
% net tow: D20180315T182329_IFCB113 row 44

%% Biovolume data
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/'));
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));

%%%% Step 1: Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SFB/'; 
load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018'],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');
    
%%%% Step 2: Convert Biovolume to Carbon
% convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
[ cellC ] = biovol2carbon(classbiovolTB, ind_diatom ); 

%convert from per cell to per mL
volC=zeros(size([cellC]));
volB=zeros(size([cellC]));

for i=1:length(cellC)
    volC(i,:)=cellC(i,:)./ml_analyzedTB(i);
    volB(i,:)=classbiovolTB(i,:)./ml_analyzedTB(i);    
end
    
%convert from pg/mL to ug/L 
volC=volC./1000;