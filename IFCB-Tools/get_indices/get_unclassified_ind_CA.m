function [ ind_out, class_label ] = get_unclassified_ind_CA( class2use, class_label )
%function [ ind_out, class_label ] = get_cell_ind( class2use, class_label )
% California class list specific to return of indices that correspond to 
% living taxa
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

class2get = {'unclassified'};

[~,ind_out] = intersect(class2use, class2get);
ind_out = sort(ind_out);

end