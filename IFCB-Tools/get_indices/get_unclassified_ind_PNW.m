function [ ind_out, class_label ] = get_unclassified_ind_PNW( class2use )
%function [ ind_out, class_label ] = get_cell_ind( class2use, class_label )
% California class list specific to return of indices that correspond to 
% living taxa
%  Alexis D. Fischer, NOAA, August 2021

class2get = {'unclassified'};

[~,ind_out] = intersect(class2use, class2get);
%ind_out = sort(ind_out);

class_label=class2use(ind_out);

end