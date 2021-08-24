function [ ind_out, class_label ] = get_diatom_ind_CA( class2use, class_label )
%function [ ind_out, class_label ] = get_diatom_ind( class2use, class_label )
% California class list specific to return of indices that correspond to diatom taxa
% parts modified from 'get_diatom_ind'
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

class2get = {'Asterionellopsis';'Centric';'Chaetoceros';...
'Cyl_Nitz';'Det_Cer_Lau';'Dictyocha';'Eucampia';'Guin_Dact';'Pennate';...
'Pseudo-nitzschia';'Skeletonema';'Thalassionema';'Thalassiosira'};

% class2get = {'Asterionellopsis' 'Bacteriastrum' 'Boreadinium' 'Centric'...
%     'Chaetoceros' 'Corethron' 'Cyl_Nitz' 'Det_Cer_Lau' 'Ditylum' 'Entomoneis'...
%     'Eucampia' 'Guin_Dact' 'Gyrosigma' 'Hemiaulus' 'Helicotheca' 'Lio_Thal'...
%     'Leptocylindrus' 'Licmophora' 'Lithodesmium' 'Odontella' 'Paralia' 'Pennate'...
%     'Pleurosigma' 'Pseudo-nitzschia' 'Rhiz_Prob' 'Skeletonema' 'Steph_Melo'...
%     'Thalassionema' 'Thalassiosira' 'Tropidoneis \rmspp.'};

[~,ind_out1] = intersect(class2use, class2get);

% ind_out = union(ind_out1, [ind_out2; ind_out3; ind_out4; ind_out5]);
ind_out = sort(ind_out1);

class_label(strcmp('Asterionellopsis', class_label)) = {'\itAsterionellopsis \rmspp.'};
class_label(strcmp('Bacteriastrum', class_label)) = {'\itBacteriastrum \rmspp.'};
class_label(strcmp('Boreadinium', class_label)) = {'\itBoreadinium \rmspp.'};
class_label(strcmp('Centric', class_label)) = {'centric diatoms'};
class_label(strcmp('Chaetoceros', class_label)) = {'\itChaetoceros \rmspp.'};
class_label(strcmp('Corethron', class_label)) = {'\itCorethron \rmspp.'};
class_label(strcmp('Cyl_Nitz', class_label)) = {'\itCyl_Nitz \rmspp.'};
class_label(strcmp('Det_Cer_Lau', class_label)) = {'\itDetonula, Cerataulina, Lauderia \rmspp.'};
class_label(strcmp('Ditylum', class_label)) = {'\itDitylum \rmspp.'};
class_label(strcmp('Entomoneis', class_label)) = {'\itEntomoneis \rmspp.'};
class_label(strcmp('Eucampia', class_label)) = {'\itEucampia \rmspp.'};
class_label(strcmp('Guin_Dact', class_label)) = {'\itGuinardia, Dactyliosolen \rmspp.'};
class_label(strcmp('Gyrosigma', class_label)) = {'\itGyrosigma \rmspp.'};
class_label(strcmp('Hemiaulus', class_label)) = {'\itHemiaulus \rmspp.'};
class_label(strcmp('Helicotheca', class_label)) = {'\itHelicotheca \rmspp.'};
class_label(strcmp('Lio_Thal', class_label)) = {'\itLio_Thal \rmspp.'};
class_label(strcmp('Leptocylindrus', class_label)) = {'\itLeptocylindrus \rmspp.'};
class_label(strcmp('Licmophora', class_label)) = {'\itLicmophora \rmspp.'};
class_label(strcmp('Lithodesmium', class_label)) = {'\itLithodesmium \rmspp.'};
class_label(strcmp('Odontella', class_label)) = {'\itOdontella \rmspp.'};
class_label(strcmp('Paralia', class_label)) = {'\itParalia \rmspp.'};
class_label(strcmp('Pennate', class_label)) = {'pennate diatoms'};
class_label(strcmp('Pleurosigma', class_label)) = {'\itPleurosigma \rmspp.'};
class_label(strcmp('Pseudo-nitzschia', class_label)) = {'\itPseudo-nitzschia \rmspp.'};
class_label(strcmp('Rhiz_Prob', class_label)) = {'\itRhiz_Prob \rmspp.'};
class_label(strcmp('Skeletonema', class_label)) = {'\itSkeletonema \rmspp.'};
class_label(strcmp('Steph_Melo', class_label)) = {'\itSteph_Melo \rmspp.'};
class_label(strcmp('Thalassionema', class_label)) = {'\itThalassionema \rmspp.'};
class_label(strcmp('Thalassiosira', class_label)) = {'\itThalassiosira \rmspp.'};
class_label(strcmp('Tropidoneis', class_label)) = {'\itTropidoneis \rmspp.'};

end

