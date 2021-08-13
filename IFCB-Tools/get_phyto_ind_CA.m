function [ ind_out, class_label ] = get_phyto_ind_CA( class2use, class_label )
%function [ ind_out, class_label ] = get_phyto_ind_CA( class2use, class_label )
% California class list specific to return of indices that correspond to 
% living taxa
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

class2get = {'Akashiwo';'Alexandrium_singlet';'Amy_Gony_Protoc';...
    'Asterionellopsis';'Centric';'Ceratium';'Chaetoceros';'Cochlodinium';...
    'Cryptophyte,NanoP_less10,small_misc';'Cyl_Nitz';'Det_Cer_Lau';...
    'Dictyocha';'Dinophysis';'Eucampia';'Guin_Dact';'Gymnodinium,Peridinium';...
    'Lingulodinium';'Pennate';'Prorocentrum';'Pseudo-nitzschia';...
    'Scrip_Het';'Skeletonema';'Thalassionema';'Thalassiosira';'unclassified'};

[~,ind_out] = intersect(class2use, class2get);
ind_out = sort(ind_out);

class_label(strcmp('Akashiwo', class_label)) = {'\itAkashiwo \itsanguinea'};
class_label(strcmp('Alexandrium_singlet', class_label)) = {'\itAlexandrium \rmspp.'};
class_label(strcmp('Asterionellopsis', class_label)) = {'\itAsterionellopsis \rmspp.'};
%class_label(strcmp('Amy_Gony_Protoc', class_label)) = {'\itAmylax, Gonyaulax,';'Protoceratium \rmspp.'};
class_label(strcmp('Amy_Gony_Protoc', class_label)) = {'Amy,Gony,Protoc'};
class_label(strcmp('Ceratium', class_label)) = {'\itCeratium \rmspp.'};
class_label(strcmp('Chaetoceros', class_label)) = {'\itChaetoceros \rmspp.'};
class_label(strcmp('Centric', class_label)) = {'centric diatoms'};
class_label(strcmp('Cochlodinium', class_label)) = {'\itMargalefidinium \rmspp.'};
class_label(strcmp('Cryptophyte,NanoP_less10,small_misc', class_label)) = {'Nanoplankton'};
class_label(strcmp('Cyl_Nitz', class_label)) = {'Cyl,Nitz'};
%class_label(strcmp('Det_Cer_Lau', class_label)) = {'\itDetonula, Cerataulina,';'Lauderia \rmspp.'};
class_label(strcmp('Det_Cer_Lau', class_label)) = {'Det,Cer,Lau'};
class_label(strcmp('Dictyocha', class_label)) = {'\itDictyocha \rmspp.'};
class_label(strcmp('Dinophysis', class_label)) = {'\itDinophysis \rmspp.'};
class_label(strcmp('Eucampia', class_label)) = {'\itEucampia \rmspp.'};
%class_label(strcmp('Guin_Dact', class_label)) = {'\itGuinardia, Dactyliosolen \rmspp.'};
class_label(strcmp('Guin_Dact', class_label)) = {'Guin,Dact'};
class_label(strcmp('Gymnodinium,Peridinium', class_label)) = {'\itGymnodinium \rmspp.'};
class_label(strcmp('Lingulodinium', class_label)) = {'\itLingulodinium \rmspp.'};
class_label(strcmp('Pennate', class_label)) = {'pennate diatoms'};
class_label(strcmp('Prorocentrum', class_label)) = {'\itProrocentrum \rmspp.'};
class_label(strcmp('Pseudo-nitzschia', class_label)) = {'\itPseudo-nitzschia \rmspp.'};
%class_label(strcmp('Scrip_Het', class_label)) = {'\itScrippsiella,';'Heterocapsa \rmspp.'};
class_label(strcmp('Scrip_Het', class_label)) = {'Scrip,Het'};
class_label(strcmp('Skeletonema', class_label)) = {'\itSkeletonema \rmspp.'};
class_label(strcmp('Thalassionema', class_label)) = {'\itThalassionema \rmspp.'};
class_label(strcmp('Thalassiosira', class_label)) = {'\itThalassiosira \rmspp.'};
class_label(strcmp('unclassified', class_label)) = {'unclassified'};

end