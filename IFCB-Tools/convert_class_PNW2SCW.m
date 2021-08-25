function [ class2use ] = convert_class_PNW2SCW( PNWclass,PNWclass2use,SCWclass2use,SCWconversion )
%function [ SCWclass ] = convert_class_PNW2SCW( PNWclass )
% Convert PNW class of interest to the SCW class
% for use with classifier testing
%  Alexis D. Fischer, NOAA, August 2021
clear
filepath='C:\Users\ifcbuser\Documents\';
load([filepath 'GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\TopClasses'],'class'); 
load([filepath 'GitHub\bloom-baby-bloom\IFCB-Tools\PNW2SCWclassconversion'],'PNWclass2use','SCWconversion','SCWclass2use');

SCWclass2use=SCWclass2use';
PNWclass=sort(class)';
[~,~,ib] = intersect(PNWclass,PNWclass2use,'stable');
class2use=SCWconversion(ib);

%%
[c,ia,ib]= intersect(class2use,SCWclass2use,'stable');

%%
save('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\PNW2SCW_class2use','class2use','class2skip'); 

end