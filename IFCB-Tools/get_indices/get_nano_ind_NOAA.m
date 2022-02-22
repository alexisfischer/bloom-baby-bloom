function [ ind_out, class_label ] = get_nano_ind_PNW( class2use )
%function [ ind_out, class_label ] = get_nano_ind( class2use, class_label )
% California class list specific to turn of indices that correspond to nanoplankton
% parts modified from 'get_diatom_ind'
%  Alexis D. Fischer, NOAA, August 2021

class2get = {'Cryptophyte';'Nanoplankton_<10';'Cryptophyte,Nanoplankton_<10'};

[~,ind_out] = intersect(class2use, class2get);
%ind_out = sort(ind_out);

class_label=class2use(ind_out);
class_label(strcmp('Cryptophyte', class_label)) = {'Cryptophytes'};
class_label(strcmp('Nanoplankton_<10', class_label)) = {'misc nanoplankton'};
class_label(strcmp('Cryptophyte,Nanoplankton_<10', class_label)) = {'misc nanoplankton'};

end

