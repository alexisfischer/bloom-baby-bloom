function [ ind_out, class_label ] = get_zoop_ind_PNW( class2use )
%function [ ind_out, class_label ] = get_nano_ind( class2use, class_label )
% California class list specific to return of indices that correspond to ciliates
% parts modified from 'get_diatom_ind'
%  Alexis D. Fischer, NOAA, August 2021

class_label=class2use;

class2get = {'Ciliate';'Mesodinium';'Strombidium';'Tiarina';'Tintinnid';...
    'Tontonia';'Zooplankton'};

[~,ind_out] = intersect(class2use, class2get);
ind_out = sort(ind_out);

class_label(strcmp('Ciliate', class_label)) = {'misc ciliates'};
class_label(strcmp('Mesodinium', class_label)) = {'\itMesodinium \rmspp.'};
class_label(strcmp('Strombidium', class_label)) = {'\itStrombidium \rmspp.'};
class_label(strcmp('Tiarina', class_label)) = {'\itTiarina \rmspp.'};
class_label(strcmp('Tintinnid', class_label)) = {'Tintinnids'};
class_label(strcmp('Tontonia', class_label)) = {'\itTontonia \rmspp.'};
class_label(strcmp('Zooplankton', class_label)) = {'misc zooplankton'};

end

