function [phyto,p] = compile_biovolume_yrs(biovolume,cruisetime,parameters)

% biovolume= 'F:\IFCB113\class\summary\summary_biovol_allcells';
% cruisetime = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\st_filename_raw.csv';
% parameters= 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\sfb_raw.csv';

%% compile biovolume multiple years SFB

biovol_sum = [];
ml_analyzed = [];
matdate = [];
filelist = [];

for yr = 2017:2018
    disp(yr)
    temp = load([biovolume num2str(yr)]);
    biovol_sum = [biovol_sum; temp.biovol_sum];
    ml_analyzed = [ ml_analyzed; temp.ml_analyzed];
    matdate = [ matdate; temp.matdate];
    filelist = [ filelist; temp.filelist];
    clear temp
end

matdate=datenum(datestr(matdate),'dd-mm-yyyy');

%% find overlap between official IFCB stations --> c 

[st,filename] = import_IFCB_stations(cruisetime);

[~,~,c] = intersect(filename,{filelist.newname});
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


%% add sfb parameters to IFCB dataset

[phys]=loadSFBparameters(parameters);

[~,~,c] = intersect([phyto.filename],[phys.filename]);

for i=1:length(c)
    phyto(i).lat=phys(c(i)).lat;
    phyto(i).lon=phys(c(i)).lon;
    phyto(i).chl=phys(c(i)).chl;
    phyto(i).d36=phys(c(i)).d36;
    phyto(i).temp=phys(c(i)).temp;
    phyto(i).sal=phys(c(i)).sal;    
    phyto(i).obs=phys(c(i)).obs;
    phyto(i).spm=phys(c(i)).spm;
    phyto(i).ni=phys(c(i)).ni;
    phyto(i).nina=phys(c(i)).nina;
    phyto(i).amm=phys(c(i)).amm;
    phyto(i).phos=phys(c(i)).phos;
    phyto(i).sil=phys(c(i)).sil;        
end

%% sort data by survey dates
p(1).a=find([phyto.matdate]==datenum('31-Jul-2017'));
p(2).a=find([phyto.matdate]==datenum('22-Aug-2017'));
p(3).a=find([phyto.matdate]==datenum('30-Aug-2017'));
p(4).a=find([phyto.matdate]==datenum('19-Sep-2017'));
p(5).a=find([phyto.matdate]==datenum('28-Sep-2017'));
p(6).a=find([phyto.matdate]==datenum('18-Oct-2017'));
p(7).a=find([phyto.matdate]==datenum('27-Oct-2017'));
p(8).a=find([phyto.matdate]==datenum('06-Dec-2017'));
p(9).a=find([phyto.matdate]>=datenum('07-Feb-2018') & [phyto.matdate]<= datenum('08-Feb-2018'));
p(10).a=find([phyto.matdate]==datenum('23-Feb-2018'));

% organize station data into structures based on survey date
for i=1:length(p)
    p(i).filename=[phyto(p(i).a).filename]'; 
    p(i).matdate=[phyto(p(i).a).matdate]'; 
    p(i).dn=datestr(p(i).matdate(1));    
    p(i).st=[phyto(p(i).a).st]'; 
    p(i).lat=[phyto(p(i).a).lat]'; 
    p(i).lon=[phyto(p(i).a).lon]';     
    p(i).ml_analyzed=[phyto(p(i).a).ml_analyzed]'; 
    p(i).biovol_sum=[phyto(p(i).a).biovol_sum]'; 
    p(i).chl=[phyto(p(i).a).chl]';
    p(i).d36=[phyto(p(i).a).d36]';    
    p(i).temp=[phyto(p(i).a).temp]';
    p(i).sal=[phyto(p(i).a).sal]';  
    p(i).obs=[phyto(p(i).a).obs]';
    p(i).spm=[phyto(p(i).a).spm]';
    p(i).ni=[phyto(p(i).a).ni]';
    p(i).nina=[phyto(p(i).a).nina]';
    p(i).amm=[phyto(p(i).a).amm]';
    p(i).phos=[phyto(p(i).a).phos]';
    p(i).sil=[phyto(p(i).a).sil]';    
end
p=rmfield(p,'a');

save('F:\IFCB113\class\summary\biovol_param','phyto','p');

end

