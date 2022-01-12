function [B,Bi] = format_IFCB_SFBcoordinates(BiEq_path,SFBcruise_path,outdir)

%Example inputs
% BiEq_path = '~/MATLAB/bloom-baby-bloom/SFB/Data/summary_biovol_2017-2019';
% SFBcruise_path = '~/MATLAB/bloom-baby-bloom/SFB/Data/parameters';
% outdir = '~/MATLAB/bloom-baby-bloom/SFB/Data/';

%%%% load in data
load(BiEq_path,'filelist','matdate','ml_analyzed','BiEq');
load(SFBcruise_path,'phys');

%% (1) find where SF Bay cruises intersect with IFCB dataset
ST=[phys.st]'; filename=[phys.filename]';
id=find(~cellfun(@isempty,filename)); %find non-empty indices
filename=filename(id); ST=ST(id);

[FL,other,id] = intersect(filename,filelist);
ST=ST(other);
DN=matdate(id);
ML=ml_analyzed(id);
BiEq=BiEq(id);

%represent 07-08Feb2018 cruise under just 07Feb2018
id=find(DN>=datenum('07-Feb-2018') & DN<= datenum('08-Feb-2018'));
DN(id)=datenum('07-Feb-2018');

% create summary structure
for i=1:length(DN)
    B(i).matdate=DN(i);    
    B(i).filename=FL(i);
    B(i).st=ST(i);
    B(i).ml_analyzed=ML(i);    
    B(i).eqdiam=BiEq(i).eqdiam;
    B(i).biovol=BiEq(i).biovol;
    B(i).carbon=BiEq(i).carbon;
end

clearvars filename id i BiEq other filelist matdate ml_analyzed phys...
    SFBcruise_path BiEq_path DN FL ML ST

%% (2) bin ESD data
edges=[0,10,20,60];
binCount=NaN(length(B),length(edges)-1); % cells per ml in each of the bins (counts/mL)
binCar=NaN(length(B),length(edges)-1); %carbon biomass per ml in each of the bins (picogram/mL)

for i=1:length(B)
    [d,edges,bin]=histcounts(B(i).eqdiam,edges); %This looks at equivalent spherical diameter, change this if you want to look at something else
    binCount(i,:)=d./B(i).ml_analyzed;  
    for j=1:size(binCount,2)
        idx=find(bin==j);
        binCar(i,j)=nansum(B(i).carbon(idx))./B(i).ml_analyzed;        
    end
end

binCar=binCar./1e6; %convert picogram/mL to microgram/mL
clearvars i j idx d bin

% format data
for i=1:length(B)
    B(i).cell0_10=binCount(i,1);
    B(i).cell10_20=binCount(i,2);
    B(i).cell20_60=binCount(i,3);
    B(i).car0_10=binCar(i,1);
    B(i).car10_20=binCar(i,2);
    B(i).car20_60=binCar(i,3);    
end

idx=find([B.cell0_10]==Inf);
B(idx)=[];

note1='cell = cells/mL';
note2='car = microgram/mL';

clearvars idx binCar binCount edges i

%% (3) sort data by cruise
[ia,ib,~] = unique([B.matdate]);
for i=1:length(ia)
    if i<length(ia)
        b(i).a=(ib(i):(ib(i+1)-1));        
        b(i).dn=ia(i);
        else
        b(i).a=(ib(i):length(B));        
        b(i).dn=ia(i);        
    end
end

% organize station data into structures based on survey date
for i=1:length(b)
    b(i).st=[B(b(i).a).st]';  
    b(i).cell0_10=[B(b(i).a).cell0_10]';
    b(i).cell10_20=[B(b(i).a).cell10_20]';
    b(i).cell20_60=[B(b(i).a).cell20_60]';
    b(i).car0_10=[B(b(i).a).car0_10]';    
    b(i).car10_20=[B(b(i).a).car10_20]';
    b(i).car20_60=[B(b(i).a).car20_60]';
end
b=rmfield(b,'a');

clearvars ia ib i

%% (4) match ifcb data with coordinates
load([outdir 'distance_st18'],'st','d18','d36','lat','lon')

ST=[36;34;32;27;22;18;15;13;9;6;3;649;657]; %ifcb stations

D18=NaN*ST;
D36=NaN*ST;
LAT=NaN*ST;
LON=NaN*ST;
for i=1:length(ST)
    id=find(ST(i)==st);
    D18(i)=d18(id);
    D36(i)=d36(id);
    LAT(i)=lat(id);
    LON(i)=lon(id);    
end

for i=1:length(b)
    Bi(i).dn=b(i).dn;
    Bi(i).st=ST;
    Bi(i).lat=LAT;
    Bi(i).lon=LON;
    Bi(i).d36=D36;
    Bi(i).d18=D18;
    Bi(i).cell0_10=NaN*ST; %prefill w nans
    Bi(i).cell10_20=NaN*ST;
    Bi(i).cell20_60=NaN*ST;
    Bi(i).car0_10=NaN*ST;
    Bi(i).car10_20=NaN*ST;
    Bi(i).car20_60=NaN*ST;       
end

clearvars d18 d36 lat lon i id D18 D36 st LAT LON

% fill in w correct coordinates
for i=1:length(b)    
    [~,j,k]=intersect(ST,b(i).st);
    Bi(i).cell0_10(j)=b(i).cell0_10(k);
    Bi(i).cell10_20(j)=b(i).cell10_20(k);
    Bi(i).cell20_60(j)=b(i).cell20_60(k);
    Bi(i).car0_10(j)=b(i).car0_10(k);
    Bi(i).car10_20(j)=b(i).car10_20(k);
    Bi(i).car20_60(j)=b(i).car20_60(k);
end

clearvars j k i ST

%%
save([outdir 'SFB_eqdiam_biovol_2017-2019'],'B','Bi','note1','note2');

end

