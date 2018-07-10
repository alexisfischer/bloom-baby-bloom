function [ ind_out, class_label ] = get_diatom_ind_CA( class2use, class_label )
%function [ ind_out, class_label ] = get_diatom_ind( class2use, class_label )
% California class list specific to return of indices that correspond to diatom taxa
% parts modified from 'get_diatom_ind'
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

class2get = {'Asterionellopsis' 'Bacteriastrum' 'Boreadinium' 'Centric'...
    'Chaetoceros' 'Corethron' 'Cyl_Nitz' 'Det_Cer_Lau' 'Ditylum' 'Entomoneis'...
    'Eucampia' 'Guin_Dact' 'Gyrosigma' 'Hemiaulus' 'Helicotheca' 'Lio_Thal'...
    'Leptocylindrus' 'Licmophora' 'Lithodesmium' 'Odontella' 'Paralia' 'Pennate'...
    'Pleurosigma' 'Pseudo-nitzschia' 'Rhiz_Prob' 'Skeletonema' 'Steph_Melo'...
    'Thalassionema' 'Thalassiosira' 'Tropidoneis'};

[~,ind_out1] = intersect(class2use, class2get);
% ind_out2 = get_Chaetoceros_ind( class2use, class_label );
% ind_out3 = get_G_delicatula_ind( class2use, class_label );
% ind_out4 = get_Cerataulinac_ind(  class2use, class_label );
% ind_out5 = get_ditylum_ind(  class2use, class_label );
% 
% ind_out = union(ind_out1, [ind_out2; ind_out3; ind_out4; ind_out5]);
ind_out = sort(ind_out1);

class_label(strmatch('Asterionellopsis', class_label, 'exact')) = {'\itAsterionellopsis'};
class_label(strmatch('Bacteriastrum', class_label, 'exact')) = {'\itBacteriastrum'};
class_label(strmatch('Boreadinium', class_label, 'exact')) = {'\itBoreadinium'};
class_label(strmatch('Centric', class_label, 'exact')) = {'\itCentric'};
class_label(strmatch('Chaetoceros', class_label, 'exact')) = {'\itChaetoceros'};
class_label(strmatch('Corethron', class_label, 'exact')) = {'\itCorethron'};
class_label(strmatch('Cyl_Nitz', class_label, 'exact')) = {'\itCyl_Nitz'};
class_label(strmatch('Det_Cer_Lau', class_label, 'exact')) = {'\itDet_Cer_Lau'};
class_label(strmatch('Ditylum', class_label, 'exact')) = {'\itDitylum'};
class_label(strmatch('Entomoneis', class_label, 'exact')) = {'\itEntomoneis'};
class_label(strmatch('Eucampia', class_label, 'exact')) = {'\itEucampia'};
class_label(strmatch('Guin_Dact', class_label, 'exact')) = {'\itGuin_Dact'};
class_label(strmatch('Gyrosigma', class_label, 'exact')) = {'\itGyrosigma'};
class_label(strmatch('Hemiaulus', class_label, 'exact')) = {'\itHemiaulus'};
class_label(strmatch('Helicotheca', class_label, 'exact')) = {'\itHelicotheca'};
class_label(strmatch('Lio_Thal', class_label, 'exact')) = {'\itLio_Thal'};
class_label(strmatch('Leptocylindrus', class_label, 'exact')) = {'\itLeptocylindrus'};
class_label(strmatch('Licmophora', class_label, 'exact')) = {'\itLicmophora'};
class_label(strmatch('Lithodesmium', class_label, 'exact')) = {'\itLithodesmium'};
class_label(strmatch('Odontella', class_label, 'exact')) = {'\itOdontella'};
class_label(strmatch('Paralia', class_label, 'exact')) = {'\itParalia'};
class_label(strmatch('Pennate', class_label, 'exact')) = {'\itPennate'};
class_label(strmatch('Pleurosigma', class_label, 'exact')) = {'\itPleurosigma'};
class_label(strmatch('Pseudo-nitzschia', class_label, 'exact')) = {'\itPseudo-nitzschia'};
class_label(strmatch('Rhiz_Prob', class_label, 'exact')) = {'\itRhiz_Prob'};
class_label(strmatch('Skeletonema', class_label, 'exact')) = {'\itSkeletonema'};
class_label(strmatch('Steph_Melo', class_label, 'exact')) = {'\itSteph_Melo'};
class_label(strmatch('Thalassionema', class_label, 'exact')) = {'\itThalassionema'};
class_label(strmatch('Thalassiosira', class_label, 'exact')) = {'\itThalassiosira'};
class_label(strmatch('Tropidoneis', class_label, 'exact')) = {'\itTropidoneis'};

end

