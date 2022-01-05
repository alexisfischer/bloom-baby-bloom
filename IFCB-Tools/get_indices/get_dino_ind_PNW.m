function [ ind_out, class_label ] = get_dino_ind_PNW( class2use )
%function [ ind_out, class_label ] = get_dino_ind( class2use, class_label )
% California class list specific to return of indices that correspond to dinoflagellate taxa
%  Alexis D. Fischer, NOAA, August 2021

class2get = {'Actiniscus';'Akashiwo';'Alexandrium';'Amphidinium';'Amylax';...
    'Azadinium';'Boreadinium';'Ceratium';'Cochlodinium';'Cyst';...
    'Dinoflagellate_mix';'Diplopsalis';'Dinophysis';'Dissodinium';...
    'Gonyaulux';'Gymnodinium';'Gyrodinium';'Heterocapsa';...
    'Heterocapsa,Scrippsiella';...
    'Heterosigma';'Kofoidinium';'Katodinium';'Lingulodinium';'Minuscula';...
    'Nematodinium';'Noctiluca';'Oxyphysis';'Phaeocystis';'Polykrikos';...
    'Prorocentrum';'Proterythropsis';'Protoceratium';'Protoperidinium';...
    'Pyrophacus';'Scrippsiella';'Thecadinium';'Torodinium'};

[~,ind_out] = intersect(class2use, class2get);
%ind_out = sort(ind_out);

class_label=class2use(ind_out);
class_label(strcmp('Actiniscus', class_label)) = {'\itActiniscus \rmspp.'};
class_label(strcmp('Akashiwo', class_label)) = {'\itAkashiwo \itsanguinea'};
class_label(strcmp('Alexandrium', class_label)) = {'\itAlexandrium \rmspp.'};
class_label(strcmp('Azadinium', class_label)) = {'\itAzadinium \rmspp.'};
class_label(strcmp('Boreadinium', class_label)) = {'\itBoreadinium \rmspp.'};
class_label(strcmp('Ceratium', class_label)) = {'\itCeratium \rmspp.'};
class_label(strcmp('Cyst', class_label)) = {'Dinocyst'};
class_label(strcmp('Cochlodinium', class_label)) = {'\itMargalefidinium \rmspp.'};
class_label(strcmp('Dinoflagellate_mix', class_label)) = {'misc dinoflagellates'};
class_label(strcmp('Diplopsalis', class_label)) = {'\itDiplopsalis \rmspp.'};
class_label(strcmp('Dinophysis', class_label)) = {'\itDinophysis \rmspp.'};
class_label(strcmp('Dissodinium', class_label)) = {'\itDissodinium \rmspp.'};
class_label(strcmp('Gonyaulux', class_label)) = {'\itGonyaulux \rmspp.'};
class_label(strcmp('Gymnodinium', class_label)) = {'\itGymnodinium \rmspp.'};
class_label(strcmp('Gyrodinium', class_label)) = {'\itGyrodinium \rmspp.'};
class_label(strcmp('Heterocapsa', class_label)) = {'\itHeterocapsa \rmspp.'};
class_label(strcmp('Heterocapsa,Scrippsiella', class_label)) = {'\itHeterocapsa,Scrippsiella \rmspp.'};
class_label(strcmp('Heterosigma', class_label)) = {'\itHeterosigma \rmspp.'};
class_label(strcmp('Kofoidinium', class_label)) = {'\itKofoidinium \rmspp.'};
class_label(strcmp('Katodinium', class_label)) = {'\itKatodinium \rmspp.'};
class_label(strcmp('Lingulodinium', class_label)) = {'\itLingulodinium \rmspp.'};
class_label(strcmp('Minuscula', class_label)) = {'\itMinuscula \rmspp.'};
class_label(strcmp('Nematodinium', class_label)) = {'\itNematodinium \rmspp.'};
class_label(strcmp('Noctiluca', class_label)) = {'\itNoctiluca \rmspp.'};
class_label(strcmp('Oxyphysis', class_label)) = {'\itOxyphysis \rmspp.'};
class_label(strcmp('Phaeocystis', class_label)) = {'\itPhaeocystis \rmspp.'};
class_label(strcmp('Polykrikos', class_label)) = {'\itPolykrikos \rmspp.'};
class_label(strcmp('Prorocentrum', class_label)) = {'\itProrocentrum \rmspp.'};
class_label(strcmp('Proterythropsis', class_label)) = {'\itProterythropsis \rmspp.'};
class_label(strcmp('Protoceratium', class_label)) = {'\itProtoceratium \rmspp.'};
class_label(strcmp('Protoperidinium', class_label)) = {'\itProtoperidinium \rmspp.'};
class_label(strcmp('Pyrophacus', class_label)) = {'\itPyrophacus \rmspp.'};
class_label(strcmp('Scrippsiella', class_label)) = {'\itScrippsiella \rmspp.'};
class_label(strcmp('Thecadinium', class_label)) = {'\itThecadinium \rmspp.'};
class_label(strcmp('Torodinium', class_label)) = {'\itTorodinium \rmspp.'};

end