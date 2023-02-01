function [lat,lon,ia,filelistTB,mdateTB] = match_IFCBdata_w_Shimada_lat_lon(filepath,yr,filelistTB,mdateTB)
% find lat lon coordinate of each file
%
% %Example Inputs
% yr=2021;
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% filelistTB
% mdateTB

S=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada' num2str(yr) '']);

[~,ia,ib]=intersect(filelistTB,S.filelistTB);
lat=S.latI(ib); lon=S.lonI(ib); 
filelistTB=filelistTB(ia); mdateTB=mdateTB(ia);

end