function [ ind_out, class_label ] = get_nonliving_ind_PNW( class2use )
%function [ ind_out, class_label ] = get_nano_ind( class2use, class_label )
% California class list specific to return of indices that correspond to ciliates
% parts modified from 'get_diatom_ind'
%  Alexis D. Fischer, NOAA, August 2021

class_label=class2use;

class2get = {'Bead';'Bubble';'Detritus';'Pollen'};

[~,ind_out] = intersect(class2use, class2get);
ind_out = sort(ind_out);

end

