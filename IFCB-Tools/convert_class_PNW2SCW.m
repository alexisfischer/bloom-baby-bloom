function [ class2use, class2skip ] = convert_class_PNW2SCW( PNWclass,PNWclass2use,SCWclass2use,SCWconversion )
%function [ SCWclass ] = convert_class_PNW2SCW( PNWclass )
% Convert PNW class of interest to the SCW class
% for use with classifier testing
%  Alexis D. Fischer, NOAA, August 2021

% % pc testing
% filepath='C:\Users\ifcbuser\Documents\';
% load([filepath 'GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\TopClasses'],'class'); 
% load([filepath 'GitHub\bloom-baby-bloom\IFCB-Tools\PNW2SCWclassconversion'],'PNWclass2use','SCWconversion','SCWclass2use');
 
% % mac testing
% filepath = '/Users/afischer/MATLAB/';
% load([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/manual/TopClasses'],'class'); 
% load([filepath 'bloom-baby-bloom/IFCB-Tools/PNW2SCWclassconversion'],'PNWclass2use','SCWconversion','SCWclass2use');

PNWclass=sort(PNWclass)';
[~,~,ib] = intersect(PNWclass,PNWclass2use,'stable');
class2use=SCWconversion(ib);
class2use=unique(class2use);

% find classes to skip
[~,~,ib]= intersect(class2use,SCWclass2use,'stable'); 
num=(1:1:length(SCWclass2use))';
ia=setdiff(num,ib);
class2skip=(SCWclass2use(ia))';
class2use=class2use';

save('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\PNW2SCW_class2use','class2use','class2skip'); 

end