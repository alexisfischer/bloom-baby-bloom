%% Pipeline to import, process, and merge Phytoflash, Flowthru, and MOPED data
% 2012-2019
addpath(genpath('~/Documents/UCSC_research/SanFranciscoBay/Data/')); % add new data to search path
filepath='~/MATLAB/bloom-baby-bloom/SFB/';

%%%% 1) import Raphe's merged Phytoflash excel files (2012-June 2015)
%[p]=importPhytoflash_12_15('~/Documents/UCSC_research/SanFranciscoBay/Data/Phytoflash_merged/',filepath);
%load([filepath 'Data/Phytoflash_2012-2015'],'p');

%%%% 2) import and merge Phytoflash and MOPED 2015-2019
[PM] = importPhytoflash_15_19('~/Documents/UCSC_research/SanFranciscoBay/Data/',[filepath 'Data/']);
load([filepath 'Data/Phytoflash_2015-2019'],'PM');

%%%% 3) merge 2012-2015 and 2015-2019 Phytoflash data
[P,Pi] = mergePhytoflash([filepath 'Data/Phytoflash_2012-2015'],[filepath 'Data/Phytoflash_2015-2019'],filepath);
load([filepath 'Data/Phytoflash_summary'],'P','Pi');


