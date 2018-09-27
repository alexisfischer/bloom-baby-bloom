function [class2useTB,classcountTB,classbiovolTB,ml_analyzedTB,mdateTB,filelistTB]=excludebiovolACIDD(filepath,filename,remove)
%% Eliminates the files that you don't want
%Alexis Fischer
%UCSC Sep 2018

% example input
%filepath = '~/Documents/MATLAB/bloom-baby-bloom/ACIDD2017/Data/IFCB_summary/class/'; 
%filename = 'summary_biovol_allTB2017';
%remove = [1:3,51:56,69:78,85:90,97:98,111:122,147:156];

load([filepath filename],'class2useTB', 'classcountTB','classbiovolTB', 'ml_analyzedTB', 'mdateTB', 'filelistTB');

classbiovolTB(remove,:)=[];
classcountTB(remove,:)=[];
filelistTB(remove,:)=[];
mdateTB(remove,:)=[];
ml_analyzedTB(remove,:)=[];


save([filepath filename '_select'], 'class2useTB', 'classcountTB','classbiovolTB', 'ml_analyzedTB', 'mdateTB', 'filelistTB')

end

