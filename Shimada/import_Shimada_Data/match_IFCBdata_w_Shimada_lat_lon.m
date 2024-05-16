function [lat,lon,ia,filelistTB] = match_IFCBdata_w_Shimada_lat_lon(filepath,filelistTB)
% find lat lon coordinate of each file
%
% %Example Inputs
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% %filelistTB

S=load([filepath 'Shimada/Data/IFCB_underway_Shimada_2019_2021'],'dt','filelist','lat','lon');

[~,ia,ib]=intersect(filelistTB,S.filelist);
lat=S.lat(ib); lon=S.lon(ib); 
filelistTB=filelistTB(ia); 

end