clear

resultpath = 'F:\IFCB113\class\'; %Where you want the summary file to go
roibasepath = 'F:\IFCB113\data\2017ok\'; %Where you raw data is
feapath = 'F:\IFCB113\features\2017ok\'; %Put in your featurepath byyear
micron_factor = 1/3.4; %USER PUT YOUR OWN microns per pixel conversion
filelist = dir([feapath 'D*.csv']);

for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

%calculate date
matdate = IFCB_file2date({filelist.newname});

%initialize ml_analyzed variable
ml_analyzed = NaN(length(filelist),1);

%Loops over each file and pulls out, the parameters you want
for filecount = 1:length(filelist) % If you want to do the whole filelist
    %for filecount= 1:3; %If you want to use it on only a subset, look at the filelist variable and find what numbers your files of interest are
    filename = filelist(filecount).newname;
    disp(filename)
    %clear matdate_subset 
    %matdate_subset(filecount)=matdate(filecount); %the dates for if you only run a subset of the data
    hdrname = [roibasepath filename(1:9) filesep [filename '.hdr']];   
%    hdrname = [roibasepath filesep filename(2:5) filesep filename(1:9) filesep [filename '.hdr']];
    ml_analyzed(filecount) = IFCB_volume_analyzed(hdrname); %calculates ml_analyzed for each file
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
    
    biovol(filecount) = {targets.Biovolume*micron_factor.^3}; %Takes all the biovolumes for that file and makes it a cell array. It then takes each cell array and puts it into a  larger vector ('biovol')....
    %This vector is populated by a cell array from each file once this loop
    %is done. The same is done for each variable below...
    %To access per say the first cell array you would type biovol{1}. 
    eqdiam(filecount) = {targets.EquivDiameter*micron_factor};
    majaxis(filecount) = {targets.majaxislength*micron_factor};
    minaxis(filecount) = {targets.minaxislength*micron_factor};
end


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
    'matdate', 'ml_analyzed', 'biovol', 'filelist','eqdiam',...
    'majaxis', 'minaxis', 'notes1', 'notes2');