function [class2use,classcount,classbiovol,ml_analyzed,matdate,filelist]=excludebiovolACIDD(filepath,filename,remove)
% Eliminates the files that you don't want
% Alexis Fischer
% UCSC Sep 2018
% 
% example input
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/ACIDD2017/Data/IFCB_summary/manual/'; 
% filename = 'count_biovol_manual_23Aug2018';
% remove = [1:3,51:56,69:78,85:90,97:98,111:122,147:156];

load([filepath filename],'class2use', 'classcount','classbiovol', 'ml_analyzed', 'matdate', 'filelist');

classbiovol(remove,:)=[];
classcount(remove,:)=[];
filelist(remove,:)=[];
matdate(remove,:)=[];
ml_analyzed(remove,:)=[];


save([filepath filename '_select'], 'class2use', 'classcount','classbiovol', 'ml_analyzed', 'matdate', 'filelist')

end

