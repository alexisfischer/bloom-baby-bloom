function [ ind_out, class_label ] = get_zoop_ind_CA( class2use, class_label )
%function [ ind_out, class_label ] = get_nano_ind( class2use, class_label )
% California class list specific to return of indices that correspond to ciliates
% parts modified from 'get_diatom_ind'
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

class2get = {'Ciliates,Mesodinium,Strombidium,Tiarina,Tintinnid,Tontonia'};

[~,ind_out1] = intersect(class2use, class2get);
 
ind_out = sort(ind_out1);

class_label(strmatch('Ciliates,Mesodinium,Strombidium,Tiarina,Tintinnid,Tontonia', class_label, 'exact')) = {'Ciliates'};

end

