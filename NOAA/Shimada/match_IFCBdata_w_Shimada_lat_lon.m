function [lat,lon,class2useTB,classbiovolTB,classcountTB,ml_analyzedTB,mdateTB] = match_IFCBdata_w_Shimada_lat_lon(filepath,yr,filelistTB,class2useTB,classbiovolTB,classcountTB,ml_analyzedTB,mdateTB)
% find lat lon coordinate of each file
%
% %Example Inputs
% yr=2021;
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
%class2useTB,classbiovolTB,classcountTB,ml_analyzedTB,mdateTB

I=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada' num2str(yr) '']);

[~,ia,ib]=intersect(filelistTB,I.filelistTB);
lat=I.latI(ib); lon=I.lonI(ib); classbiovolTB=classbiovolTB(ia,:); mdateTB=mdateTB(ia);
classcountTB=classcountTB(ia,:); ml_analyzedTB=ml_analyzedTB(ia);

end