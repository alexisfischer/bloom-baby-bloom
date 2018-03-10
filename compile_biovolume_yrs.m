%% compile biovolume multiple years
path = 'F:\IFCB113\class\summary\'; %Where you want the summary file to go

biovol_sum = [];
ml_analyzed = [];
matdate = [];
filelist = [];

for yr = 2017:2018
    disp(yr)
    temp = load([path 'summary_biovol_allcells' num2str(yr)]);
    biovol_sum = [biovol_sum; temp.biovol_sum];
    ml_analyzed = [ ml_analyzed; temp.ml_analyzed];
    matdate = [ matdate; temp.matdate];
    filelist = [ filelist; temp.filelist];
    clear temp
end

matdate=datenum(datestr(matdate),'dd-mm-yyyy');

%% find overlap between official IFCB stations --> c 
path = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\';
[st,filename] = import_IFCB_stations([path 'st_filename_raw.csv']);

[~,b,c] = intersect(filename,{filelist.newname});
matdate=matdate(c);
ml_analyzed=ml_analyzed(c);
biovol_sum=biovol_sum(c);

for i=1:length(filename)
    phyto(i).filename=filename(i);
    phyto(i).st=st(i);
    phyto(i).matdate=matdate(i);
    phyto(i).ml_analyzed=ml_analyzed(i);
    phyto(i).biovol_sum=biovol_sum(i);
end

save([path 'biovol_param'],'phyto');

%% sort data by date
p(1).a=find([phyto.matdate]==datenum('31-Jul-2017'));
p(2).a=find([phyto.matdate]==datenum('22-Aug-2017'));
p(3).a=find([phyto.matdate]==datenum('30-Aug-2017'));
p(4).a=find([phyto.matdate]==datenum('19-Sep-2017'));
p(5).a=find([phyto.matdate]==datenum('28-Sep-2017'));
p(6).a=find([phyto.matdate]==datenum('18-Oct-2017'));
p(7).a=find([phyto.matdate]==datenum('27-Oct-2017'));
p(8).a=find([phyto.matdate]==datenum('14-Nov-2017'));
p(9).a=find([phyto.matdate]==datenum('06-Dec-2017'));
p(10).a=find([phyto.matdate]==datenum('07-Feb-2018') & [phyto.matdate]== datenum('08-Feb-2018'));
p(11).a=find([phyto.matdate]==datenum('23-Feb-2018'));

% organize station data into structures
for i=1:length(p)
    p(i).filename=[phyto(p(i).a).filename]'; 
    p(i).st=[phyto(p(i).a).st]'; 
    p(i).matdate=[phyto(p(i).a).matdate]'; 
    p(i).ml_analyzed=[phyto(p(i).a).ml_analyzed]'; 
    p(i).biovol_sum=[phyto(p(i).a).biovol_sum]'; 
end
p=rmfield(p,'a');
save([path 'biovol_param'],'phyto','p');


figure;

for i=1:length(p)
    plot(p(i).st, p(i).biovol_sum);
    hold on
    
end


%% attach parameters to structure 
%[sfb,s]=loadSFBparameters([path 'sfb_raw.csv']);
load('sfb.mat');

% link ifcb timepoints with  phys and chem data, c is the overlap
[~,b,c] = intersect([phyto.filename],[sfb.ifcb]); %need to add 27 october data to sfb.ifcb
lat = sfb.lat(c);
long = sfb.long(c);
chl = sfb.chl(c);
sal = sfb.sal(c);
obs = sfb.obs(c);
spm = sfb.spm(c);
ext = sfb.ext(c);

filename=filename(b);
st=st(b);
matdate=matdate(b);
ml_analyzed(b);
biovol_sum(b);

phyto = rmfield(phyto,{'filename','st','matdate','ml_analyzed','biovol_sum'});
for i=1:length(filename)
    phyto(i).filename=filename(i);
    phyto(i).st=st(i);
    phyto(i).matdate=matdate(i);
    phyto(i).ml_analyzed=ml_analyzed(i);
    phyto(i).biovol_sum=biovol_sum(i);
    phyto(i).lat = lat(i);
    phyto(i).long = long(i);
    phyto(i).chl = chl(i);
    phyto(i).sal = sal(i);
    phyto(i).obs = obs(i);
    phyto(i).spm = spm(i);
    phyto(i).ext = ext(i);    
end

