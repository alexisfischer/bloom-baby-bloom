%% Pipeline to import and process SFB data
% 2012-2019
clear
addpath(genpath('~/Documents/UCSC_research/SanFranciscoBay/Data/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/SFB/Data/')); % add new data to search path

filepath='~/MATLAB/bloom-baby-bloom/SFB/';

%% 1) merge Phytoflash, Flowthru, and MOPED data
%%%% A) import Raphe's merged Phytoflash excel files (2012-June 2015)
[p]=importPhytoflash_12_15('~/Documents/UCSC_research/SanFranciscoBay/Data/Phytoflash_merged_2012-2015/',[filepath 'Data/']);
%load([filepath 'Data/Phytoflash_2012-2015'],'p');

%%%% B) import and merge Phytoflash and MOPED 2015-2019
[PM] = importPhytoflash_15_19('~/Documents/UCSC_research/SanFranciscoBay/Data/',[filepath 'Data/']);
%load([filepath 'Data/Phytoflash_2015-2019'],'PM');

%%%% C) merge 2012-2015 and 2015-2019 Phytoflash data
[P,Pi] = mergePhytoflash([filepath 'Data/Phytoflash_2012-2015'],[filepath 'Data/Phytoflash_2015-2019'],filepath);
%load([filepath 'Data/Phytoflash_summary'],'P','Pi');

%% 2) calculate MLD and integrated salinity and chlorophyll
[M,Mi]=import_depthstructure_SFB("/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/density_sal_depth_SFB.xlsx",...
    '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/',[filepath 'Data/st_lat_lon_distance']);

%% 3) import Delta Flow
import_DeltaFlow('/Users/afischer/MATLAB/bloom-baby-bloom/SFB/',...
    '/Users/afischer/Documents/UCSC_research/SanFranciscoBay/Data/Dayflow1955-2019.csv');

%% 4) import and process 2013-2019 SFB cruise data and merge with phytoflash data and MLD
import_USGS_cruisedata_v2(filepath,...
    "/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/sfb_raw_1992-present.xlsx",...
    [filepath 'Data/NetDeltaFlow'],[filepath 'Data/st_lat_lon_distance'],...
    [filepath 'Data/Phytoflash_summary'],[filepath 'Data/correction_FvFm_PHA'],...
    [filepath 'Data/integratedSal_MLD']);

%% 5) import and merge microscopy data from 1992-2019 with big SFB structure
microscopy="/Users/afischer/Documents/UCSC_research/SanFranciscoBay/Data/Microscopy/Microscopy_SFB_1992_present.xlsx";
import_microscopy_SFB(filepath,microscopy,[filepath 'Data/st_lat_lon_distance']);

% %% 6) import long timeseries of SFB salinity, chl, and chlpha
% import_historicalSFBsalchl(filepath,['/Users/afischer/MATLAB/bloom-baby-bloom/SFB/','Data/st_lat_lon_distance'],1);
