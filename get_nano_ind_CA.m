function [ ind_out, class_label ] = get_nano_ind_CA( class2use, class_label )
%function [ ind_out, class_label ] = get_nano_ind( class2use, class_label )
% California class list specific to return of indices that correspond to nanoplankton
% parts modified from 'get_diatom_ind'
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

class2get = {'Cryptophyte' 'NanoP_less10'};

[~,ind_out1] = intersect(class2use, class2get);
% ind_out2 = get_Chaetoceros_ind( class2use, class_label );
% ind_out3 = get_G_delicatula_ind( class2use, class_label );
% ind_out4 = get_Cerataulinac_ind(  class2use, class_label );
% ind_out5 = get_ditylum_ind(  class2use, class_label );
% 
% ind_out = union(ind_out1, [ind_out2; ind_out3; ind_out4; ind_out5]);
ind_out = sort(ind_out1);

class_label(strmatch('Cryptophyte', class_label, 'exact')) = {'Cryptophyte'};
class_label(strmatch('NanoP_less10', class_label, 'exact')) = {'Nanoplankton'};

end

