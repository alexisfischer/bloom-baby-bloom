function [ ind_out, class_label ] = get_diatom_ind_PNW( class2use )
%function [ ind_out, class_label ] = get_diatom_ind( class2use, class_label )
% California class list specific to return of indices that correspond to diatom taxa
% parts modified from 'get_diatom_ind'
%  Alexis D. Fischer, NOAA, August 2021

class2get = {'Actinoptychus';'Asterioplanus';'Asteromphalus';'Attheya';...
    'Aulacodiscus';'Asterionellopsis';'Bacillaria';'Bacteriastrum';...
    'Centric_diatom';'Cerataulina';'Cerataulina,Detonula,Lauderia';...
    'Chaetoceros';'Chaetoceros setae';...
    'Corethron';'Coscinodiscus';'Cylindrotheca';'Dactyliosolen';'Detonula';
    'Ditylum';'Entomoneis';'Eucampia';'Flagilaria';'Guinardia';'Gyrosigma';...
    'Helicotheca';'Hemiaulus';'Lauderia';'Leptocylindrus';'Licmophora';...
    'Lioloma';'Lithodesmium';'Melosira';'Nitzschia';'Odontella';...
    'Paralia';'Pennate_diatom';'Plagiogrammopsis';'Plagiolemma';...
    'Pleurosigma';'Proboscia';'Pseudo-nitzschia';'Pn_large';'Pn_small';'Rhizosolenia';...
    'Skeletonema';'Stephanopyxis';'Striatella';'Thalassionema';...
    'Thalassiosira';'Tropidoneis'};

[~,ind_out] = intersect(class2use, class2get);
%ind_out = sort(ind_out);

class_label=class2use(ind_out);
class_label(strcmp('Actinoptychus', class_label)) = {'\itActinoptychus \rmspp.'};
class_label(strcmp('Asterioplanus', class_label)) = {'\itAsterioplanus \rmspp.'};
class_label(strcmp('Asteromphalus', class_label)) = {'\itAsteromphalus \rmspp.'};
class_label(strcmp('Attheya', class_label)) = {'\itAttheya \rmspp.'};
class_label(strcmp('Aulacodiscus', class_label)) = {'\itAulacodiscus \rmspp.'};
class_label(strcmp('Asterionellopsis', class_label)) = {'\itAsterionellopsis \rmspp.'};
class_label(strcmp('Bacillaria', class_label)) = {'\itBacillaria \rmspp.'};
class_label(strcmp('Bacteriastrum', class_label)) = {'\itBacteriastrum \rmspp.'};
class_label(strcmp('Centric_diatom', class_label)) = {'misc centric diatoms'};
class_label(strcmp('Cerataulina,Detonula,Lauderia', class_label)) = {'Cer Det Lau'};
class_label(strcmp('Cerataulina', class_label)) = {'\itCerataulina \rmspp.'};
class_label(strcmp('Chaetoceros', class_label)) = {'\itChaetoceros \rmspp.'};
class_label(strcmp('Chaetoceros setae', class_label)) = {'\itChaetoceros setae'};
class_label(strcmp('Corethron', class_label)) = {'\itCorethron \rmspp.'};
class_label(strcmp('Coscinodiscus', class_label)) = {'\itCoscinodiscus \rmspp.'};
class_label(strcmp('Cylindrotheca', class_label)) = {'\itCylindrotheca \rmspp.'};
class_label(strcmp('Dactyliosolen', class_label)) = {'\itDactyliosolen \rmspp.'};
class_label(strcmp('Detonula', class_label)) = {'\itDetonula \rmspp.'};
class_label(strcmp('Ditylum', class_label)) = {'\itDitylum \rmspp.'};
class_label(strcmp('Entomoneis', class_label)) = {'\itEntomoneis \rmspp.'};
class_label(strcmp('Eucampia', class_label)) = {'\itEucampia \rmspp.'};
class_label(strcmp('Flagilaria', class_label)) = {'\itFlagilaria \rmspp.'};
class_label(strcmp('Guinardia', class_label)) = {'\itGuinardia \rmspp.'};
class_label(strcmp('Gyrosigma', class_label)) = {'\itGyrosigma \rmspp.'};
class_label(strcmp('Helicotheca', class_label)) = {'\itHelicotheca \rmspp.'};
class_label(strcmp('Hemiaulus', class_label)) = {'\itHemiaulus \rmspp.'};
class_label(strcmp('Lauderia', class_label)) = {'\itLauderia \rmspp.'};
class_label(strcmp('Leptocylindrus', class_label)) = {'\itLeptocylindrus \rmspp.'};
class_label(strcmp('Licmophora', class_label)) = {'\itLicmophora \rmspp.'};
class_label(strcmp('Lioloma', class_label)) = {'\itLioloma \rmspp.'};
class_label(strcmp('Lithodesmium', class_label)) = {'\itLithodesmium \rmspp.'};
class_label(strcmp('Melosira', class_label)) = {'\itMelosira \rmspp.'};
class_label(strcmp('Nitzschia', class_label)) = {'\itNitzschia \rmspp.'};
class_label(strcmp('Odontella', class_label)) = {'\itOdontella \rmspp.'};
class_label(strcmp('Paralia', class_label)) = {'\itParalia \rmspp.'};
class_label(strcmp('Pennate_diatom', class_label)) = {'misc pennate diatoms'};
class_label(strcmp('Plagiogrammopsis', class_label)) = {'\itPlagiogrammopsis \rmspp.'};
class_label(strcmp('Plagiolemma', class_label)) = {'\itPlagiolemma \rmspp.'};
class_label(strcmp('Pleurosigma', class_label)) = {'\itPleurosigma \rmspp.'};
class_label(strcmp('Proboscia', class_label)) = {'\itProboscia \rmspp.'};
class_label(strcmp('Pseudo-nitzschia', class_label)) = {'\itPseudo-nitzschia \rmspp.'};
class_label(strcmp('Pn_large', class_label)) = {'Large \itPseudo-nitzschia'};
class_label(strcmp('Pn_small', class_label)) = {'Small \itPseudo-nitzschia'};
class_label(strcmp('Rhizosolenia', class_label)) = {'\itRhizosolenia \rmspp.'};
class_label(strcmp('Skeletonema', class_label)) = {'\itSkeletonema \rmspp.'};
class_label(strcmp('Stephanopyxis', class_label)) = {'\itStephanopyxis \rmspp.'};
class_label(strcmp('Striatella', class_label)) = {'\itStriatella \rmspp.'};
class_label(strcmp('Thalassionema', class_label)) = {'\itThalassionema \rmspp.'};
class_label(strcmp('Thalassiosira', class_label)) = {'\itThalassiosira \rmspp.'};
class_label(strcmp('Tropidoneis', class_label)) = {'\itTropidoneis \rmspp.'};

end

