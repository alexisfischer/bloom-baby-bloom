function [ ind_out, class_label ] = get_dino_ind_CA( class2use, class_label )
%function [ ind_out, class_label ] = get_dino_ind( class2use, class_label )
% California class list specific to return of indices that correspond to dinoflagellate taxa
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

class2get = {'Akashiwo';'Alexandrium_singlet';'Amy_Gony_Protoc';'Ceratium';...
    'Cochlodinium';'Dinophysis';'Gymnodinium';'Lingulodinium';...
    'Peridinium';'Prorocentrum';'Scrip_Het'};

% class2get = {'Akashiwo' 'Alexandrium_singlet' 'Amy_Gony_Protoc' 'Ceratium'...
%     'Cochlodinium' 'DinoMix' 'Dinophysis' 'Gymnodinium' 'Gyrodinium' 'Karenia'...
%     'Lingulodinium' 'Noctiluca' 'Peridinium' 'Polykrikos' 'Prorocentrum' 'Protoperidinium'...
%     'Pyrocystis' 'Scrip_Het' 'Boreadinium' 'Azadinium' 'Torodinium' 'Oxyp_Oxyt'};

[~,ind_out] = intersect(class2use, class2get);
ind_out = sort(ind_out);

class_label(strmatch('Akashiwo', class_label, 'exact')) = {'\itAkashiwo \itsanguinea'};
class_label(strmatch('Alexandrium_singlet', class_label, 'exact')) = {'\itAlexandrium spp.'};
class_label(strmatch('Amy_Gony_Protoc', class_label, 'exact')) = {'\itAmy_Gony_Protoc'};
class_label(strmatch('Ceratium', class_label, 'exact')) = {'\itCeratium'};
class_label(strmatch('Cochlodinium', class_label, 'exact')) = {'\itMargalefidinium'};
class_label(strmatch('DinoMix', class_label, 'exact')) = {'\itDinoMix'};
class_label(strmatch('Dinophysis', class_label, 'exact')) = {'\itDinophysis'};
class_label(strmatch('Gymnodinium', class_label, 'exact')) = {'\itGymnodinium'};
class_label(strmatch('Gyrodinium', class_label, 'exact')) = {'\itGyrodinium'};
class_label(strmatch('Karenia', class_label, 'exact')) = {'\itKarenia'};
class_label(strmatch('Lingulodinium', class_label, 'exact')) = {'\itLingulodinium'};
class_label(strmatch('Noctiluca', class_label, 'exact')) = {'\itNoctiluca'};
class_label(strmatch('Peridinium', class_label, 'exact')) = {'\itPeridinium'};
class_label(strmatch('Polykrikos', class_label, 'exact')) = {'\itPolykrikos'};
class_label(strmatch('Prorocentrum', class_label, 'exact')) = {'\itProrocentrum'};
class_label(strmatch('Protoperidinium', class_label, 'exact')) = {'\itProtoperidinium'};
class_label(strmatch('Pyrocystis', class_label, 'exact')) = {'\itPyrocystis'};
class_label(strmatch('Scrip_Het', class_label, 'exact')) = {'\itScrip_Het'};
class_label(strmatch('Boreadinium', class_label, 'exact')) = {'\itBoreadinium'};
class_label(strmatch('Azadinium', class_label, 'exact')) = {'\itAzadinium'};
class_label(strmatch('Torodinium', class_label, 'exact')) = {'\itTorodinium'};
class_label(strmatch('Oxyp_Oxyt', class_label, 'exact')) = {'\itOxyp_Oxyt'};

end