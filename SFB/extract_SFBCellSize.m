%% extract SFB cell size from Angel Island to Delta
%2017?2019
clear;

%%%% (1): Load in data
addpath(genpath('~/MATLAB/bloom-baby-bloom/'));
addpath(genpath('~/MATLAB/ifcb-analysis/'));
filepath = '~/MATLAB/bloom-baby-bloom/SFB/'; 
load([filepath 'Data/IFCB_summary/eqdiam_biovol_2018'],...
    'BiEq','note1','note2');

%%%% (2) Bin data
edges=[0 5 10 20 60]; %set bin size
bincount=NaN(length(BiEq),length(edges)-1);
for i=1:length(BiEq)
	[N,~]=histcounts(BiEq(i).eqdiam,edges); %This looks at equivalent spherical diameter, change this if you want to look at something else   
    bincount(i,:)=N./BiEq(i).ml_analyzed;
end
clearvars N i

%%%% (3) match dates with stations
filename=BiEq(1).filename{1:20}

%%

targets=BiEq(nt).targets;
count=BiEq(nt).count;
eqdiam=BiEq(nt).eqdiam;
biovol=BiEq(nt).biovol;
ml=ml_analyzed(ww,:);
carbon=volC(ww,:);

numclass=(1:length(class2use))';
class=cell(size(count));
for i=1:length(count)
    for j=1:length(numclass)
        if numclass(j) == count(i)            
            class(i)=class2use(j);      
        else
        end
    end
end
