function [class2skip] = find_class2skip(class,manualpath)
%find_class2skip Finds class2skip from an input of the classes that you
%want in your training set
%   can use before compile_train_features_PNW

% % Example inputs
% load([filepath 'GitHub\bloom-baby-bloom\IFCB-Data\Shimada\manual\TopClasses'],'class');
% manualpath = 'D:\Shimada\manual\'; %classlist to subtract "class" from

manual_files = dir([manualpath 'D*.mat']);
manual_files = {manual_files.name}';
class2use = load([manualpath manual_files{1}], 'class2use_manual'); %load in first PNW manual file
class2use = class2use.class2use_manual;

class=sort(class)';
[~,~,ib] = intersect(class,class2use,'stable'); %find difference
num=(1:1:length(class2use))';
ia=setdiff(num,ib);
class2skip_all=(class2use(ia));
class2skip=unique(class2skip_all); %remove extra unclassified

clearvars ia ib num class2use manual_files manualpath class2skip_all

end

