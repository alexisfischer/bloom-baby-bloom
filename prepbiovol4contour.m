function [f] = prepbiovol4contour(filelist,eqdiam,biovol,sfb)

[filelist] = affix_metadata(filelist);

% preallocate memory
eqdiam_ave = zeros(size(eqdiam))';
eqdiam_std = eqdiam_ave;
biovol_ave = eqdiam_ave;
biovol_std = eqdiam_ave;

for i=1:length(eqdiam)
    eqdiam_ave(i)= average(eqdiam{i});
    eqdiam_std(i)= std(eqdiam{i});
    biovol_ave(i)= average(biovol{i});
    biovol_std(i)= std(biovol{i});
end 

%link average biovolume with  phys and chem data, c is the overlap
[~,b,c] = intersect({filelist.newname},sfb.ifcb');
sfb(:).eqdiam_ave=nan*(sfb(:).st);
sfb(:).eqdiam_std=sfb(:).eqdiam_ave;
sfb(:).biovol_ave=sfb(:).eqdiam_ave;
sfb(:).biovol_std=sfb(:).eqdiam_ave;
sfb(:).latt=sfb(:).eqdiam_ave;
sfb(:).longg=sfb(:).eqdiam_ave;

for i=1:length(eqdiam_ave)
    sfb.eqdiam_ave(c(i)) = eqdiam_ave(i);
    sfb.eqdiam_std(c(i)) = eqdiam_std(i);
    sfb.biovol_ave(c(i)) = biovol_ave(i);
    sfb.biovol_std(c(i)) = biovol_std(i); 
    sfb.latt(c(i)) = sfb.lat(c(i));
    sfb.longg(c(i)) = sfb.long(c(i));
end

%% convert sfb into date structure
%put in matrix
M =[sfb.dn, sfb.st, sfb.latt, sfb.longg, sfb.chl, sfb.oxg, sfb.sal,...
    sfb.temp,sfb.obs, sfb.spm, sfb.ext, sfb.nit, sfb.nina, sfb.amm,...
    sfb.phos, sfb.sil, sfb.eqdiam_ave, sfb.eqdiam_std, ...
    sfb.biovol_ave, sfb.biovol_std];

%sfb = sortrows(sfb,1); %sort by dates
% organize by dates
f(1).a = M((M(:,1) == datenum('31-Jul-2017')),:);
f(2).a = M((M(:,1) == datenum('22-Aug-2017')),:);
f(3).a = M((M(:,1) == datenum('30-Aug-2017')),:);
f(4).a = M((M(:,1) == datenum('19-Sep-2017')),:);
f(5).a = M((M(:,1) == datenum('28-Sep-2017')),:);
f(6).a = M((M(:,1) == datenum('18-Oct-2017')),:);
%f(7).a = M((M(:,1) == datenum('27-Oct-2017')),:);
%f(7).a = M((M(:,1) == datenum('14-Nov-2017')),:);
f(7).a = M((M(:,1) == datenum('06-Dec-2017')),:);

% organize station data into structures
for i=1:length(f)
    f(i).dn=f(i).a(:,1); % date  
    f(i).st=f(i).a(:,2); % station #
    f(i).lat=f(i).a(:,3); % lat
    f(i).long=f(i).a(:,4); % long
    f(i).chl=f(i).a(:,5); % chl
    f(i).oxg=f(i).a(:,6); % oxygen
    f(i).sal=f(i).a(:,7); % salinity
    f(i).temp=f(i).a(:,8); % temp
    f(i).obs=f(i).a(:,9); % optical backscatter sensor
    f(i).spm=f(i).a(:,10); % suspended particulate material
    f(i).ext=f(i).a(:,11); % measured light extinction coefficient
    f(i).ni=f(i).a(:,12); %nitrite
    f(i).nina=f(i).a(:,13); %nitrite +nitrate
    f(i).amm=f(i).a(:,14); % ammonium
    f(i).phos=f(i).a(:,15); % phosphate
    f(i).sil=f(i).a(:,16);  % silicate
    f(i).eqdiam_ave=f(i).a(:,17); %
    f(i).eqdiam_std=f(i).a(:,18); % 
    f(i).biovol_ave=f(i).a(:,19); % 
    f(i).biovol_std=f(i).a(:,20); %     
end

f=rmfield(f,'a');

save('C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Data\list_st_filename.mat', 'f');