function [ ind_out, class_label ] = get_dino_ind_CA( class2use, class_label )
%function [ ind_out, class_label ] = get_dino_ind( class2use, class_label )
% California class list specific to return of indices that correspond to dinoflagellate taxa
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

class2get = {'Akashiwo';'Alexandrium_singlet';'Amy_Gony_Protoc';'Ceratium';...
    'Cochlodinium';'Dinophysis';'Gymnodinium';'Gymnodinium,Peridinium';...
    'Lingulodinium';'Margalefidinium';'Peridinium';'Prorocentrum';'Scrip_Het'};

% class2get = {'Akashiwo' 'Alexandrium_singlet' 'Amy_Gony_Protoc' 'Ceratium'...
%     'Cochlodinium' 'DinoMix' 'Dinophysis' 'Gymnodinium' 'Gyrodinium' 'Karenia'...
%     'Lingulodinium' 'Noctiluca' 'Peridinium' 'Polykrikos' 'Prorocentrum' 'Protoperidinium'...
%     'Pyrocystis' 'Scrip_Het' 'Boreadinium' 'Azadinium' 'Torodinium' 'Oxyp_Oxyt'};

[~,ind_out] = intersect(class2use, class2get);
ind_out = sort(ind_out);

class_label(strcmp('Akashiwo', class_label)) = {'\itAkashiwo \itsanguinea'};
class_label(strcmp('Alexandrium_singlet', class_label)) = {'\itAlexandrium \rmspp.'};
class_label(strcmp('Amy_Gony_Protoc', class_label)) = {'\itAmylax_Gonyaulax_Protoceratium \rmspp.'};
class_label(strcmp('Ceratium', class_label)) = {'\itCeratium \rmspp.'};
class_label(strcmp('Cochlodinium', class_label)) = {'\itMargalefidinium \rmspp.'};
class_label(strcmp('DinoMix', class_label)) = {'\itDinoMix'};
class_label(strcmp('Dinophysis', class_label)) = {'\itDinophysis \rmspp.'};
class_label(strcmp('Gymnodinium', class_label)) = {'\itGymnodinium \rmspp.'};
class_label(strcmp('Gymnodinium,Peridinium', class_label)) = {'\itGymnodinium \rmspp.'};
class_label(strcmp('Gyrodinium', class_label)) = {'\itGyrodinium \rmspp.'};
class_label(strcmp('Karenia', class_label)) = {'\itKarenia \rmspp.'};
class_label(strcmp('Lingulodinium', class_label)) = {'\itLingulodinium \rmspp.'};
class_label(strcmp('Margalefidinium', class_label)) = {'\itMargalefidinium \rmspp.'};
class_label(strcmp('Noctiluca', class_label)) = {'\itNoctiluca \rmspp.'};
class_label(strcmp('Peridinium', class_label)) = {'\itPeridinium \rmspp.'};
class_label(strcmp('Polykrikos', class_label)) = {'\itPolykrikos \rmspp.'};
class_label(strcmp('Prorocentrum', class_label)) = {'\itProrocentrum \rmspp.'};
class_label(strcmp('Protoperidinium', class_label)) = {'\itProtoperidinium \rmspp.'};
class_label(strcmp('Pyrocystis', class_label)) = {'\itPyrocystis \rmspp.'};
class_label(strcmp('Scrip_Het', class_label)) = {'\itScrippsiella, Heterocapsa \rmspp.'};
class_label(strcmp('Boreadinium', class_label)) = {'\itBoreadinium \rmspp.'};
class_label(strcmp('Azadinium', class_label)) = {'\itAzadinium \rmspp.'};
class_label(strcmp('Torodinium', class_label)) = {'\itTorodinium \rmspp.'};
class_label(strcmp('Oxyp_Oxyt', class_label)) = {'\itOxyp_Oxyt \rmspp.'};

end