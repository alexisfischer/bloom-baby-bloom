function [filelist] = affix_metadata(filelist)

[sfb,s]=loadSFBparameters('C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\sfb_raw.csv');
%load('sfb.mat');

%link ifcb timepoints with  phys and chem data, c is the overlap
[~,b,c] = intersect({filelist.newname},sfb.ifcb');
st = sfb.st(c);
lat = sfb.lat(c);
long = sfb.long(c);
chl = sfb.chl(c);
sal = sfb.sal(c);
obs = sfb.obs(c);
spm = sfb.spm(c);
ext = sfb.ext(c);

for i=1:length(filelist)
    filelist(i).st = st(i);
    filelist(i).lat = lat(i);
    filelist(i).long = long(i);
    filelist(i).chl = chl(i);
    filelist(i).sal = sal(i);
    filelist(i).obs = obs(i);
    filelist(i).spm = spm(i);
    filelist(i).ext = ext(i);    
end

