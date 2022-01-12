function[class2useTB,classcountTB,classbiovolTB,ml_analyzedTB,mdateTB]=merge_IFCBbiovol_files(filepath,varargin)

%example inputs
% filepath = '~/MATLAB/bloom-baby-bloom/SCW/Data/IFCB_summary/class/';
% varargin={2016,2017,2018,2019};

yr=cell2mat(varargin);

for i=1:length(yr)
    S(i) = load([filepath 'summary_biovol_allTB' num2str(yr(i)) ''],'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB');
    t(i)=length(S(i).classcountTB);
end

%preallocate
class2useTB = S(1).class2useTB;
classcountTB=NaN*ones(sum(t),length(class2useTB));
classbiovolTB=classcountTB;
ml_analyzedTB=NaN*ones(sum(t),1);
mdateTB=ml_analyzedTB;

c=cumsum(t);
for i=1:length(c)
    if i==1
        classcountTB(1:c(i),:)=S(i).classcountTB;
        classbiovolTB(1:c(i),:)=S(i).classbiovolTB;
        ml_analyzedTB(1:c(i))=S(i).ml_analyzedTB;
        mdateTB(1:c(i))=S(i).mdateTB;
    else
        classcountTB(c(i-1)+1:c(i),:)=S(i).classcountTB;
        classbiovolTB(c(i-1)+1:c(i),:)=S(i).classbiovolTB;
        ml_analyzedTB(c(i-1)+1:c(i))=S(i).ml_analyzedTB;
        mdateTB(c(i-1)+1:c(i))=S(i).mdateTB;
    end 
end

clearvars t c i S varargin

%%
save([filepath 'summary_biovol_TB' num2str(yr(1)) '-' num2str(yr(end)) ''],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB');

end



