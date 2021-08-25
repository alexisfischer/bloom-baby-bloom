function [ SCWclass ] = convert_class_PNW2SCW( PNWclass )
%function [ SCWclass ] = convert_class_PNW2SCW( PNWclass )
% Convert PNW class of interest to the SCW class
% for use with classifier testing
%  Alexis D. Fischer, NOAA, August 2021

load('/Users/afischer/MATLAB/bloom-baby-bloom/IFCB-Data/PNW2SCWclassconversion','PNWclass2use','SCWconversion');

PNWclass=sort(PNWclass)';
[~,~,ib] = intersect(PNWclass,PNWclass2use,'stable');
SCWclass=SCWconversion(ib);

end