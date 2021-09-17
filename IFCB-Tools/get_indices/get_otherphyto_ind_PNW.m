function [ ind_out, class_label ] = get_otherphyto_ind_PNW( class2use )
%function [ ind_out, class_label ] = get_otherphyto_ind_CA( class2use, class_label )
% California class list specific to return of indices that correspond to 
% phytoplankton taxa that are not diatoms, dinoflagellates, or nanoplankton
%  Alexis D. Fischer, NOAA, August 2021

class2get = {'Aphanocapsa';'Chlorophyte_mix';'Clusterflagellate';...
    'Coccolithophore';'Cyanobacteria';'Dictyocha';'Dinobryon';'Ebria';...
    'Euglenoid';'Fibrocapsa';'Flagellate_mix';'Meringosphaera';'Pyramimonas'};

[~,ind_out] = intersect(class2use, class2get);
%ind_out = sort(ind_out);

class_label=class2use(ind_out);
class_label(strcmp('Aphanocapsa', class_label)) = {'\itAphanocapsa \rmspp.'};
class_label(strcmp('Chlorophyte_mix', class_label)) = {'Chlorophyte mix'};
class_label(strcmp('Clusterflagellate', class_label)) = {'Clusterflagellate'};
class_label(strcmp('Coccolithophore', class_label)) = {'Coccolithophore'};
class_label(strcmp('Cyanobacteria', class_label)) = {'Cyanobacteria'};
class_label(strcmp('Dictyocha', class_label)) = {'\itDictyocha \rmspp.'};
class_label(strcmp('Dinobryon', class_label)) = {'\itDinobryon \rmspp.'};
class_label(strcmp('Ebria', class_label)) = {'\itEbria \rmspp.'};
class_label(strcmp('Euglenoid', class_label)) = {'Euglenoid'};
class_label(strcmp('Fibrocapsa', class_label)) = {'\itFibrocapsa \rmspp.'};
class_label(strcmp('Flagellate_mix', class_label)) = {'Flagellate mix'};
class_label(strcmp('Meringosphaera', class_label)) = {'\itMeringosphaera \rmspp.'};
class_label(strcmp('Pyramimonas', class_label)) = {'\itPyramimonas \rmspp.'};

end