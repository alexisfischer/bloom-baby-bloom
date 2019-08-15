function[class2useTB,classcountTB,classbiovolTB,ml_analyzedTB,mdateTB,filelistTB]=merge_2yrs_IFCBbiovol(filepath,yr1,yr2)

%Example inputs
%filepath = '~/MATLAB/bloom-baby-bloom/SCW/Data/IFCB_summary/class/';
%yr1='2018';
%yr2='2019';

S1 = load([filepath 'summary_biovol_allTB' yr1],'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');
S2 = load([filepath 'summary_biovol_allTB' yr2],'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

%merge
class2useTB = S1.class2useTB;
classcountTB = [S1.classcountTB; S2.classcountTB];
classbiovolTB = [S1.classbiovolTB; S2.classbiovolTB];
ml_analyzedTB = [S1.ml_analyzedTB; S2.ml_analyzedTB];
mdateTB = [S1.mdateTB; S2.mdateTB];
filelistTB = [S1.filelistTB; S2.filelistTB];

save([filepath 'summary_biovol_TB' yr1 '_' yr2],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

end




