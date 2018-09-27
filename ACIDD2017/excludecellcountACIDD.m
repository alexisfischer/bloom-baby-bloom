function [class]=excludecellcountACIDD(in_dir,class_sum,class2do_string,Thr_sum,biovol_sum,remove)
%% Eliminates the files that you don't want
%Alexis Fischer
%UCSC Sep 2018

% example input
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% class_sum = 'ACIDD2017/Data/IFCB_summary/class/summary_allTB_bythre_'; 
% class2do_string = 'Prorocentrum'; 
% Thr_sum = 'SCW/Data/IFCB_summary/Coeff_';
% biovol_sum = 'ACIDD2017/Data/IFCB_summary/manual/count_biovol_manual_23Aug2018';
% remove = [1:3,51:56,69:78,85:90,97:98,111:122,147:156];

%load in class count data
load([in_dir class_sum class2do_string],'class2do','class2useTB',...
    'classcountTB_above_thre','classpath_generic','filelistTB','mdateTB',...
    'ml_analyzedTB','threlist');

%load in threshold for particular class
load([in_dir Thr_sum class2do_string],'bin','chosen_threshold','class2do_string','slope')

%load in manual files
load([in_dir biovol_sum],'class2use','classbiovol','classcount','filelist','matdate','ml_analyzed')

%% remove the bad pre-specificed values
classcountTB_above_thre(remove,:)=[];
filelistTB(remove,:)=[];
mdateTB(remove,:)=[];
ml_analyzedTB(remove,:)=[];

classbiovol(remove,:)=[];
classcount(remove,:)=[];
filelist(remove,:)=[];
matdate(remove,:)=[];
ml_analyzed(remove,:)=[];

%% find the matched files between automated and manually classified files
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end
[~,im,it] = intersect({filelist.newname}, filelistTB); 

%%

y_mat=classcountTB_above_thre(it,bin)./ml_analyzedTB(it);
y_mat((y_mat<0)) = 0; % cannot have negative numbers 
mdateTB=mdateTB(it);

ind2 = strmatch(class2do_string, class2use); 
y_mat_manual=classcount(im,ind2)./ml_analyzedTB(im);
mdate_mat_manual=matdate(im);

%%

class(1).name = class2do_string;
class(1).chosen_threshold=chosen_threshold;
class(1).bin=bin;
class(1).slope=slope;
class(1).y_mat=y_mat;
class(1).y_mat_manual=y_mat_manual;
class(1).mdateTB=mdateTB;
class(1).mdate_mat_manual=mdate_mat_manual;
class(1).filelist=string(filelistTB);

save([in_dir 'ACIDD2017/Data/IFCB_summary/class/' num2str(class2do_string) '_summary'],'class');

end

