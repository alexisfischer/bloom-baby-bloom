clear

resultpath = 'F:\IFCB104\manual\'; %Where you want the summary file to go
roibasepath = 'F:\IFCB104\data\'; %Where you raw data is
feapath = 'F:\IFCB104\features\2017\'; %Put in your featurepath byyear
micron_factor = 1/3.4; %USER PUT YOUR OWN microns per pixel conversion
filelist = dir([resultpath 'D*.mat']);

% filelist = dir([feapath 'D*.csv']);
% 
% for i=1:length(filelist)
%     filelist(i).newname=filelist(i).name(1:24);
% end

% %calculate date
% matdate = IFCB_file2date({filelist.newname});

matdate = IFCB_file2date({filelist.name});

% load([resultpath filelist(1).newname]) %read first file to get classes
load([resultpath filelist(1).name]) %read first file to get classes
numclass = length(class2use_manual);
class2use_manual_first = class2use_manual;
classcount = NaN(length(filelist),numclass);  %initialize output
classbiovol = classcount;
eqdiam = classcount;
majaxis = classcount;
minaxis = classcount;
ml_analyzed = NaN(length(filelist),1);

%Loops over each file and pulls out, the parameters you want
for filecount = 1:length(filelist) % If you want to do the whole filelist
%for filecount = 112:317 %If you want to use it on only a subset, look at the filelist variable and find what numbers your files of interest are
%    filename = filelist(filecount).newname;

    filename = filelist(filecount).name;
    disp(filename)
%    hdrname = [roibasepath filename(1:9) filesep [filename '.hdr']];  
    
    hdrname = [roibasepath filesep filename(2:5) filesep filename(1:9) filesep regexprep(filename, 'mat', 'hdr')]; 
    ml_analyzed(filecount) = IFCB_volume_analyzed(hdrname);
     
    load([resultpath filename])
    clear targets
    
    [~,file] = fileparts(filename);
    feastruct = importdata([feapath file '_fea_v2.csv'], ','); %imports feature file
    ind = strmatch('Biovolume', feastruct.colheaders); %indexes which column is Biovolume, so on and so forth for each parameter below
    targets.Biovolume = feastruct.data(:,ind); %pulls out all Biovolume values, so on and so forth for each parameter below
    ind = strmatch('roi_number', feastruct.colheaders);
    tind = feastruct.data(:,ind);
    ind = strmatch('EquivDiameter', feastruct.colheaders);
    targets.EquivDiameter = feastruct.data(:,ind);
    ind = strmatch('MajorAxisLength', feastruct.colheaders);
    targets.majaxislength = feastruct.data(:,ind);
    ind = strmatch('MinorAxisLength', feastruct.colheaders);
    targets.minaxislength = feastruct.data(:,ind);
        
    classlist = classlist(tind,:);
    if ~isequal(class2use_manual, class2use_manual_first)
        disp('class2use_manual does not match previous files!!!')
        %     keyboard
    end;
    temp = zeros(1,numclass); %init as zeros for case of subdivide checked but none found, classcount will only be zero if in class_cat, else NaN
    tempvol = temp;
    temp2 = temp;
    temp3 = temp;
    temp4 = temp;
    for classnum = 1:numclass,
        cind = find(classlist(:,2) == classnum | (isnan(classlist(:,2)) & classlist(:,3) == classnum));
        temp(classnum) = length(cind);
        tempvol(classnum) = nansum(targets.Biovolume(cind)*micron_factor.^3);
    	temp2(classnum) = (targets.EquivDiameter(cind)*micron_factor);
        temp3(classnum) = (targets.majaxislength(cind)*micron_factor);
        temp4(classnum) = (targets.minaxislength(cind)*micron_factor);        
    end;
    
    classcount(filecount,:) = temp;
    classbiovol(filecount,:) = tempvol;  
    eqdiam(filecount,:) = temp2;  
    majaxis(filecount,:) = temp3;  
    minaxis(filecount,:) = temp4;  

    clear class2use_manual class2use_auto class2use_sub* classlist    
    
end

class2use = class2use_manual_first;

%Makes a summary folder within the resultpath
if ~exist([resultpath 'summary'], 'dir')
    mkdir([resultpath 'summary']);
end
datestr = date; datestr = regexprep(datestr,'-','');
notes1 = 'Biovolume in units of cubed micrometers';
notes2= 'Eqdiam and axis lengths in micrometers';
%
%saves the result file in the summary folder with a name that will be used 
%every time this is run, but with the date you ran it ammended on the end
save([resultpath 'summary/biovol_size_allcells_' datestr],...
    'matdate','ml_analyzed','classcount','classbiovol','filelist',...
    'class2use','eqdiam','majaxis','minaxis','notes1','notes2');