%% merge IFCB underway data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';

S19=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2019']);
S21=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2021']);

dt=[S19.dtI;S21.dtI];
filelist=[S19.filelistTB;S21.filelistTB];
lat=[S19.latI;S21.latI];
lon=[S19.lonI;S21.lonI];

save([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada_2019_2021'],'dt','filelist','lat','lon');
