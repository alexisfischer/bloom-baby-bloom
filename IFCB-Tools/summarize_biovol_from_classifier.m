function [] = summarize_biovol_from_classifier(summarydir,classpath_generic,feapath_generic,roibasepath_generic,adhocthresh,yrrange)
%function [] = summarize_biovol_from_classifier(summarydir,classpath_generic,feapath_generic,roibasepath_generic,adhocthresh,yrrange)
%
% Inputs automatic classified results and outputs a summary file of counts and biovolume
% Alexis D. Fischer, University of California - Santa Cruz, June 2018
%
%Example inputs
% summarydir='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\BuddInlet\';
% classpath_generic = 'D:\BuddInlet\class\classxxxx_v1\';
% feapath_generic = 'D:\BuddInlet\features\xxxx\'; %Put in your featurepath byyear
% roibasepath_generic = 'D:\Buddinlet\data\xxxx\'; %location of raw data
% yrrange = 2022;
% adhocthresh = 0.9;

for i = 1:length(yrrange) 
    yr=yrrange(i);

    classpath = regexprep(classpath_generic, 'xxxx', num2str(yr));
    feapath = regexprep(feapath_generic, 'xxxx', num2str(yr));
    roibasepath = regexprep(roibasepath_generic, 'xxxx', num2str(yr));
        
    temp = dir([classpath 'D*.mat']);
    pathall = repmat(classpath, length(temp),1);
    names = char(temp.name);
    classfiles = cellstr([pathall names]);
    pathall = repmat(feapath, length(temp),1);
    xall = repmat('_fea_v2.csv', length(temp),1);
    feafiles = cellstr([pathall names(:,1:24) xall]);
    clear temp pathall classpath xall

    temp = char(classfiles);
    ind = length(classpath_generic)+1;
    filelist = cellstr(temp(:,ind:ind+23));
    mdate = IFCB_file2date(filelist);
    
    pathall = repmat(roibasepath, length(temp),1);
   % pathall = repmat(hdrpath, size(temp,1),1);   
    xall = repmat('.hdr', size(temp,1),1);
  %  temp = cellstr([pathall temp(:,ind:ind+23) xall]);
    temp = cellstr([temp(:,ind:ind+23) xall]);
    ml_analyzed = IFCB_volume_analyzed(temp); 
    
    temp = load(classfiles{1}, 'class2useTB');
    class2use = temp.class2useTB; clear temp classfilestr
    classcount = NaN(length(classfiles),length(class2use));
    classbiovol = classcount;
    runtypeTB=NaN*filelist;
    filecommentTB=NaN*filelist;
       
    %classcount_above_optthresh = classcount;
    num2dostr = num2str(length(classfiles));
   
    for filecount = 1:length(classfiles)
        if ~rem(filecount,10), disp(['reading ' num2str(filecount) ' of ' num2dostr]), end;
      %  [classcount(filecount,:), classbiovol(filecount,:), class2useTB] = summarize_biovol_TBclassMVCO(classfiles{filecount}, feafiles{filecount});
        [classcount(filecount,:), classbiovol(filecount,:), classC(filecount,:),...
            classcount_above_optthresh(filecount,:), classbiovol_above_optthresh(filecount,:),...
            classC_above_optthresh(filecount,:), classcount_above_adhocthresh(filecount,:),...
            classbiovol_above_adhocthresh(filecount,:), classC_above_adhocthresh(filecount,:), class2useTB]...
            = summarize_biovol_TBclassNOAA(classfiles{filecount}, feafiles{filecount}, adhocthresh);
       
            filename = filelist(filecount).name;
            hdrname = ([basepath regexprep(filename, 'mat', 'hdr')]);%for when there is no dashboard url
            hdr=IFCBxxx_readhdr2(hdrname);
            runtypeTB{filecount}=hdr.runtype;
            filecommentTB{filecount}=hdr.filecomment;
    end;
    
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
    save([summarydir 'summary_biovol_allTB' num2str(yr)] ,'runtypeTB','filecommentTB',...
        'class2useTB', 'classC_TB*', 'classcountTB*', 'classbiovolTB*', 'ml_analyzedTB', 'mdateTB', 'filelistTB')
%    save([resultpath 'summary_biovol_allTB'] , 'class2useTB', 'classcountTB*', 'classbiovolTB*', 'classC_TB*', 'ml_analyzedTB', 'mdateTB', 'filelistTB', 'classpath_generic', 'feapath_generic')
    clear *files* classcount* classbiovol* classC* 
end
