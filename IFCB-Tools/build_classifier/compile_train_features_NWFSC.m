function [  ] = compile_train_features_NWFSC( manualpath , feapath_base, outpath, maxn, minn, classifiername, class2useName, varargin)
%% function [  ] = compile_train_features_user_training( manualpath , feapath_base, maxn, minn, class2skip, class2group)
% class2skip and class2merge are optional inputs
% For example:
%compile_train_features_user_training('C:\work\IFCB\user_training_test_data\manual\', 'C:\work\IFCB\user_training_test_data\features\', 100, 30, {'other'}, {'misc_nano' 'Karenia'})
%IFCB classifier production: get training features from pre-computed bin feature files
%   Alexis D. Fischer, NOAA NWFSC, September 2021
%
% %Example inputs: 
% %manualpath = 'D:\general\classifier\manual_merged\'; % manual annotation file location
% %feapath_base = 'D:\general\classifier\features_merged\'; %feature file location, assumes \yyyy\ organization
% %manualpath = '~/Downloads/classifier/test_manual/'; % manual annotation file location
% %feapath_base = '~/Downloads/classifier/test_features/'; %feature file location, assumes \yyyy\ organization
% %outpath = '~/Documents/MATLAB/bloom-baby-bloom/'; % location to save training set
% %maxn = 1000; %maximum number of images per class to include
% %minn = 500; %minimum number for inclusion
% %class2useName = '~/Downloads/classifier/class2use_11'; %classlist
% %class2useName = 'D:\general\config\class2use_11'; %classlist
% varargin{1}={'Actiniscus','Actinoptychus','Amphidinium','Amylax','Asteromphalus','Attheya','Aulacodiscus','Azadinium','Bacillaria','Bacteriastrum','Boreadinium','Chaetoceros_external_pennate','Chaetoceros_setae','Chaetoceros_socialis','Clusterflagellate','Corethron','Coscinodiscus','Cylindrotheca','Dictyocha','Dinobryon','Dinophyceae_pointed','Dinophyceae_round','Dissodinium','Ebria','Entomoneis','Ephemera','Euglenoids','Fibrocapsa','Fragilaria','Gonyaulux','Gyrodinium','Helicotheca','Hemiaulus','Heterocapsa_triquetra','Karenia','Katodinium','Laboea_strobila','Licmophora','Lingulodinium','Lioloma','Lithodesmium','Margalefidinium','Melosira','Meringosphaera','Mesodinium','Nematodinium','Nitzschia','Noctiluca','Oxyphysis','Paralia','Phaeocystis','Plagiogrammopsis','Pleuronema','Pleurosigma','Polykrikos','Proterythropsis','Protoperidinium','Pseudo-nitzschia','Pseudo-nitzschia_external_parasite','Pyrophacus','Scrippsiella','Sea_Urchin_larvae','Striatella','Strombidium','Thalassionema','Tiarina_fusus','Tintinnida','Tontonia','Torodinium','Tropidoneis','bead','bubble','centric','ciliate','coccolithophorid','cyanobacteria','cyst','detritus','flagellate','nanoplankton','nauplii','pollen','unclassified','veliger','zooplankton'};
% varargin{2}={{'Dinophysis' 'Dinophysis_acuminata' 'Dinophysis_fortii'...
%     'Dinophysis_norvegica' 'Dinophysis_acuta' 'Dinophysis_rotundata' ...
%     'Dinophysis_parva' 'Dinophysis_caudata' 'Dinophysis_odiosa' 'Dinophysis_tripos'}...
%     {'Pseudo-nitzschia_large_narrow' 'Pseudo-nitzschia_large_wide' ...
%     'Pseudo-nitzschia_small' 'Pseudo-nitzschia'}};
%varargin{2}=[]; %class2group with nothing to group

% varargin{1}=class2skip;
% varargin{2}=class2group;
% varargin{3}=IFCB;

class2skip = []; %initialize
class2group = {[]};
if length(varargin) >= 1
    class2skip = varargin{1};
end
if length(varargin) > 1
    class2group = varargin(2);
end

if length(class2group{1}) > 1 && ischar(class2group{1}{1}) %input of one group without outer cell 
    class2group = {class2group};
end

if strcmp(varargin{3},'UCSC')
    manual_files = dir([manualpath 'D*IFCB104.mat']);
else
    manual_files = dir([manualpath 'D*.mat']);
end
manual_files = {manual_files.name}';
fea_files = regexprep(manual_files, '.mat', '_fea_v2.csv');
manual_files = regexprep(manual_files, '.mat', '');    

load([class2useName '.mat'],'class2use');

if ~(manualpath(end) == filesep), manualpath = [manualpath filesep]; end

fea_all = [];
class_all = [];
files_all = [];
%test for feapath format
feapath_flag = 0;
feapath=[feapath_base manual_files{1}(2:5) filesep];
if ~exist([feapath fea_files{1}], 'file')
    feapath=[feapath_base 'features' manual_files{1}(2:5) '_v2' filesep]
    feapath_flag = 1;
    if ~exist([feapath fea_files{1}], 'file')
        disp('Error: First feature file not found; Check input path')
        return
    end
end
    
for filecount = 1:length(manual_files) %looping over the manual files
    if feapath_flag
        feapath=[feapath_base 'features' manual_files{filecount}(2:5) '_v2' filesep];
    else
        feapath=[feapath_base manual_files{filecount}(2:5) filesep];
    end
    
    disp(['file ' num2str(filecount) ' of ' num2str(length(manual_files)) ': ' manual_files{filecount}])
    manual_temp = load([manualpath manual_files{filecount}]);
    
    fea_temp = importdata([feapath fea_files{filecount}]); %import data from the feature files
    
    if ~isequal(manual_temp.class2use_manual, class2use)
        class2use_min = min([length(manual_temp.class2use_manual) length(class2use)]);
        disp('class2use_manual does not match previous files!!!')
        if isequal(manual_temp.class2use_manual(1:class2use_min), class2use(1:class2use_min))
            disp('class2use missing entries on end')
            if length(class2use) < class2use_min %if the loaded file has more entries update class2use
                class2use = manual_temp.class2use_manual;
            end
        else
            disp('error here: class2use entries do not match')
            keyboard
        end
    end
    %ind_nan=isnan(manual_temp.classlist(fea_temp.data(:,1),2));
    class_temp = manual_temp.classlist(fea_temp.data(:,1),2);
    ind_nan = find(isnan(class_temp));
    class_temp(ind_nan) = manual_temp.classlist(fea_temp.data(ind_nan,1),3);
    ind_nan = find(isnan(class_temp));
    class_temp(ind_nan) = [];
    fea_temp.data(ind_nan,:) = [];
    class_all = [class_all; class_temp];%This assume you have only manual annotations not classifier pre classified classes
    fea_all = [fea_all; fea_temp.data];
    files_all = [files_all; repmat(manual_files(filecount),size(fea_temp.data,1),1)];

end

featitles = fea_temp.textdata;
[~,i] = setdiff(featitles, {'FilledArea' 'summedFilledArea' 'Area' 'ConvexArea' 'MajorAxisLength' 'MinorAxisLength' 'Perimeter', 'roi_number'}');
featitles = featitles(i);
roinum = fea_all(:,1);
fea_all = fea_all(:,i);

clear *temp

[n, class_all, varargout] = handle_train_maxn_subsample( class2use, maxn, class_all, fea_all, files_all, roinum );
fea_all = varargout{1};
files_all = varargout{2};
roinum = varargout{3};

[ n, class_all, varargout ] = handle_train_class2skip( class2use, class2skip, n, class_all, fea_all, files_all, roinum );
fea_all = varargout{1};
files_all = varargout{2};
roinum = varargout{3};

[ n, class_all, class2use, varargout ] = handle_train_class2group( class2use, class2group, maxn, n, class_all, fea_all, files_all, roinum );
fea_all = varargout{1};
files_all = varargout{2};
roinum = varargout{3};

[ n, class_all, varargout ] = handle_train_minn( minn, n, class_all, fea_all, files_all, roinum );
fea_all = varargout{1};
files_all = varargout{2};
roinum = varargout{3};

train = fea_all;
class_vector = class_all;
targets = cellstr([char(files_all) repmat('_', length(class_vector),1) num2str(roinum, '%05.0f')]);
nclass = n;


datestring = datestr(now, 'ddmmmyyyy');

save([outpath 'Train_' classifiername], 'train', 'class_vector', 'targets', 'class2use', 'nclass', 'featitles');
disp('Training set feature file stored here:')
disp([outpath 'Train_' datestring])