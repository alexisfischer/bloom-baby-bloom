%merge ifcb data from 2017 and 2018
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';

load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB2017'],...
    'class2useTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

classbiovol1=classbiovolTB;
ml_analyzed1=ml_analyzedTB;
mdate1=mdateTB;
filelist1=filelistTB;

load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018'],...
    'classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

classbiovol2=classbiovolTB;
ml_analyzed2=ml_analyzedTB;
mdate2=mdateTB;
filelist2=filelistTB;

classbiovolTB=[classbiovol1;classbiovol2];
ml_analyzedTB=[ml_analyzed1;ml_analyzed2];
mdateTB=[mdate1;mdate2];
filelistTB=[filelist1;filelist2];

clearvars classbiovol1 classbiovol2 ml_analyzed1 ml_analyzed2 mdate1 mdate2...
    filelist1 filelist2;

save([filepath 'Data/IFCB_summary/class/summary_biovol_allTB'],...
    'class2useTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');





