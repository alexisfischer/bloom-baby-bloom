function [] = summarize_biovol_from_classifier(summarydir_base,summaryfolder,classpath_generic,feapath_generic,roibasepath_generic,adhocthresh,yrrange)
%function [] = summarize_biovol_from_classifier(summarydir,classpath_generic,feapath_generic,roibasepath_generic,adhocthresh,yr)
%
% Inputs automatic classified results and outputs a summary file of counts and biovolume
% Alexis D. Fischer, University of California - Santa Cruz, June 2018

%% %Example inputs
% clear
% summarydir_base='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
% summaryfolder='IFCB-Data\BuddInlet\class\';
% classpath_generic = 'D:\test\class\classxxxx_v1\';
% feapath_generic = 'D:\test\features\xxxx\'; %Put in your featurepath byyear
% roibasepath_generic = 'D:\test\data\xxxx\'; %location of raw data
% yrrange = 2021:2022;
% adhocthresh = 0.5;

classfiles = [];
filelist = [];
feafiles = [];
hdrname = [];

for i = 1:length(yrrange)
    yr = yrrange(i);  
    classpath = regexprep(classpath_generic, 'xxxx', num2str(yr));
    feapath = regexprep(feapath_generic, 'xxxx', num2str(yr));
    roibasepath = regexprep(roibasepath_generic, 'xxxx', num2str(yr));

    addpath(genpath([summarydir_base summaryfolder]));
    addpath(genpath(classpath));
    addpath(genpath(feapath));
    addpath(genpath(roibasepath));

    temp = dir([classpath 'D*.mat']);
    if ~isempty(temp) 
        names = char(temp.name);
        filelist = [filelist; cellstr(names(:,1:24))];    
        
        pathall = repmat(roibasepath, length(temp),1);
        xall = repmat('.hdr', size(names,1),1);      
        fall = repmat('\', size(names,1),1);            
        hdrname = [hdrname; cellstr([pathall names(:,1:9) fall names(:,1:24) xall])];

        pathall = repmat(classpath, length(temp),1);
        classfiles = [classfiles; cellstr([pathall names])];
        
        pathall = repmat(feapath, length(temp),1);
        xall = repmat('_fea_v2.csv', length(temp),1);
        feafiles = [feafiles; cellstr([pathall names(:,1:24) xall])];   
    end
   clearvars temp names pathall classpath feapath roibasepath xall fall yr
end

mdate = IFCB_file2date(filelist);
ml_analyzed = IFCB_volume_analyzed(hdrname); 

temp = load(classfiles{1}, 'class2useTB');
class2use = temp.class2useTB; clear temp classfilestr
classcount = NaN(length(classfiles),length(class2use));
classbiovol = classcount;
runtypeTB=filelist;
filecommentTB=filelist;
%classcount_above_optthresh = classcount;
num2dostr = num2str(length(classfiles));

clearvars feapath_generic classpath_generic roibasepath_generic i

for i = 1:length(classfiles)
    if ~rem(i,10), disp(['reading ' num2str(i) ' of ' num2dostr]), end
  %  [classcount(i,:), classbiovol(i,:), class2useTB] = summarize_biovol_TBclassMVCO(classfiles{i}, feafiles{i});
  [classcount(i,:),classbiovol(i,:),classC(i,:), classcount_above_optthresh(i,:),...
        classbiovol_above_optthresh(i,:),classC_above_optthresh(i,:),classcount_above_adhocthresh(i,:),...
        classbiovol_above_adhocthresh(i,:),classC_above_adhocthresh(i,:),class2useTB]...
        = summarize_biovol_TBclassNOAA(classfiles{i},feafiles{i},adhocthresh,summarydir_base);
    
        hdr=IFCBxxx_readhdr2(hdrname{i});
        runtypeTB{i}=hdr.runtype;
        filecommentTB{i}=hdr.filecomment;
end


classcountTB = classcount;
classcountTB_above_optthresh = classcount_above_optthresh;
classcountTB_above_adhocthresh = classcount_above_adhocthresh;
classbiovolTB = classbiovol;
classbiovolTB_above_optthresh = classbiovol_above_optthresh;
classbiovolTB_above_adhocthresh = classbiovol_above_adhocthresh;
classC_TB = classC;
classC_TB_above_optthresh = classC_above_optthresh;
classC_TB_above_adhocthresh = classC_above_adhocthresh;

ml_analyzedTB = ml_analyzed;
mdateTB = mdate;
filelistTB = filelist;
%     if ~exist(resultpath, 'dir')
%         mkdir(resultpath)
%     end

yrrangestr = num2str(yrrange(1));
if length(yrrange) > 1
    yrrangestr = [yrrangestr '-' num2str(yrrange(end))];
end

save([summarydir_base summaryfolder 'summary_biovol_allTB_' yrrangestr] ,'runtypeTB','filecommentTB',...
    'class2useTB', 'classC_TB*', 'classcountTB*', 'classbiovolTB*', 'ml_analyzedTB', 'mdateTB', 'filelistTB')
%    save([resultpath 'summary_biovol_allTB'] , 'class2useTB', 'classcountTB*', 'classbiovolTB*', 'classC_TB*', 'ml_analyzedTB', 'mdateTB', 'filelistTB', 'classpath_generic', 'feapath_generic')
clear *files* classcount* classbiovol* classC* 
