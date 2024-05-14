%% create cell count summary files for seascapes
clear;

filepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
addpath(genpath(filepath)); 
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\')); 
load([filepath 'NOAA/SeascapesProject/Data/SeascapeSummary_NOAA-OSU-UCSC'],'S');

manualpath = 'D:\general\classifier\manual_merged_ungrouped\'; % manual annotation file location
result_path = [filepath 'NOAA\SeascapesProject\Data\']; 

% get class2use
filelist = dir([manualpath 'D*.mat']);
load([manualpath filelist(1).name],'class2use_manual') %read first file to get classes
numclass = length(class2use_manual);
class2use_manual_first = class2use_manual; 

% match seascapes with cell abundance from manual files
filelistSS=S.filename;
classcount = NaN(length(filelistSS),numclass);  %initialize output
ml_analyzed = NaN(length(filelistSS),1); %initialize output
for filecount = 1:length(filelistSS)   
    filename=char(filelistSS(filecount));     

    if contains(filename,{'IFCB777','IFCB117'})
        datapath = 'D:\Shimada\data\';                
        hdrname = [datapath filename(2:5) filesep filename(1:9) filesep regexprep(filename, 'mat', 'hdr')]; 
        ml_analyzed(filecount) = IFCB_volume_analyzed(hdrname);         
    elseif contains(filename,'IFCB150')
        datapath = 'D:\BuddInlet\data\';          
        hdrname = [datapath filename(2:5) filesep filename(1:9) filesep regexprep(filename, 'mat', 'hdr')]; 
        ml_analyzed(filecount) = IFCB_volume_analyzed(hdrname); 
    elseif contains(filename,'IFCB122')
        datapath = 'D:\OSU\data\';          
        hdrname = [datapath filename(2:5) filesep filename(1:9) filesep regexprep(filename, 'mat', 'hdr')]; 
        ml_analyzed(filecount) = IFCB_volume_analyzed(hdrname);     
    else
        ml_analyzed(filecount)=5; %temporary fix until get OSU and UCSC data           
    end

    [~,~,idx]=intersect(filename,({filelist.name})');        
    if ~isempty(idx)
        S.manual(filecount)=1;     
        load([manualpath char(filename)],'class2use_manual','classlist')
        if ~isequal(class2use_manual, class2use_manual_first)
            [t,ii] = min([length(class2use_manual_first), length(class2use_manual)]);
            if ~isequal(class2use_manual(1:t), class2use_manual_first(1:t))
                disp('class2use_manual does not match previous files!!!')
                keyboard
            else
                if ii == 1, class2use_manual_first = class2use_manual; end %new longest list
            end
        end
        for classnum = 1:numclass
            classcount(filecount,classnum) = size(find(classlist(:,2) == classnum),1); %manual only
        end
        clear class2use_manual classlist

    else
        disp([(filename) ' NO matching file']);
        S.manual(filecount)=0;
    end

end

matdate=S.dt;
seascape=S.ss;
class2use = class2use_manual_first;
filelist=filelistSS;

%% tally of files with different seascapes across dataset
%NOAA 
id1=find(S.manual==1 & S.ifcb==117);
id2=find(S.manual==1 & S.ifcb==777);
id3=find(S.manual==1 & S.ifcb==150);

N.total=length(dir('D:\Shimada\data\**\*.hdr'));
N.ss=length(find(S.ifcb==117 | S.ifcb==777 | S.ifcb==150));
N.manual=length(dir('D:\Shimada\manual\*.mat'));
N.manualss=length([id1;id2;id3]);

%OSU
O.manual=length(dir('D:\OSU\manual\*.mat'));
O.manualss=length(find(S.manual==1 & S.ifcb==122));

%UCSC
U.manual=length(dir('D:\SCW\manual\*.mat'));
U.manualss=length(find(S.manual==1 & S.ifcb==104));

save([result_path 'seascape_count_class_manual'],'seascape',...
    'ml_analyzed','classcount','filelist','class2use','N','O','U')