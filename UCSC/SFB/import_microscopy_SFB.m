function [] = import_microscopy_SFB(filepath,microscopy,distance)
%% Import SFB microscopy data
% note1 = 'Density (cells/mL)';	
% note2 = 'Biovolume (cubic micrometers/mL)';
addpath(genpath('~/Documents/UCSC_research/SanFranciscoBay/Data/Microscopy')); % add new data to search path

% filepath = '~/MATLAB/bloom-baby-bloom/SFB/';
% microscopy = "/Users/afischer/Documents/UCSC_research/SanFranciscoBay/Data/Microscopy/Microscopy_SFB_1992_present.xlsx";
% distance = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/st_lat_lon_distance';

opts = spreadsheetImportOptions("NumVariables", 13);
opts.Sheet = "all";
opts.DataRange = "A2:M34416";
opts.VariableNames = ["Var1", "Var2", "Genus", "PhylumClass", "Date", "Var6", "Var7", "StationID", "Var9", "Var10", "DensitycellsmL", "BiovolumecubicmicrometersmL", "CellVolumecubicmicrometerscell"];
opts.SelectedVariableNames = ["Genus", "PhylumClass", "Date", "StationID", "DensitycellsmL", "BiovolumecubicmicrometersmL", "CellVolumecubicmicrometerscell"];
opts.VariableTypes = ["string", "string", "string", "string", "datetime", "string", "string", "double", "string", "string", "double", "double", "double"];
opts = setvaropts(opts, [1, 2, 3, 4, 6, 7, 9, 10], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 6, 7, 9, 10], "EmptyFieldRule", "auto");
T = readtable(microscopy, opts, "UseExcel", false);

GENUS = T.Genus;
PHYLUM = T.PhylumClass;
DN = datenum(T.Date);
ST = T.StationID;
BIOVOL = T.BiovolumecubicmicrometersmL;

phylum_names=unique(PHYLUM); 
diatom_names=["Actinoptychus";"Aulacoseira";"Cocconeis";"Coscinodiscus";"Cyclotella";...
    "Ditylum";"Entomoneis";"Gyrosigma";"Melosira";"Navicula";"Nitzschia";"Odontella";...
    "Paralia";"Pleurosigma";"Skeletonema";"Thalassiosira";"Ulnaria";"Unknown"];  

%% partition dataset into just diatoms and find ids of genus of interest
[C,id,~] = unique(DN);     
bb=struct('dn',NaN*ones(length(C),1)); %preallocate 

for i=1:length(C) % organize data into structure by dates   
    if i<length(C)
        bb(i).a=id(i):(id(i+1)-1); 
        bb(i).dn=C(i);
    elseif i==length(C) 
        bb(i).a=id(i):length(DN);  
        bb(i).dn=C(i);        
    end
end 

for i=1:length(bb)
    bb(i).st = ST(bb(i).a);              
    bb(i).diatom = GENUS(bb(i).a);                  
    bb(i).phylum = PHYLUM(bb(i).a);                      
    bb(i).biovol = BIOVOL(bb(i).a);                  
end

for i=1:length(bb)
    id=strcmp(diatom_names(1),bb(i).diatom); bb(i).ACT=bb(i).biovol(id); bb(i).ACT_st=bb(i).st(id);      
    id=strcmp(diatom_names(2),bb(i).diatom); bb(i).AUL=bb(i).biovol(id); bb(i).AUL_st=bb(i).st(id);   
    id=strcmp(diatom_names(3),bb(i).diatom); bb(i).COC=bb(i).biovol(id); bb(i).COC_st=bb(i).st(id);   
    id=strcmp(diatom_names(4),bb(i).diatom); bb(i).COS=bb(i).biovol(id); bb(i).COS_st=bb(i).st(id);      
    id=strcmp(diatom_names(5),bb(i).diatom); bb(i).CYC=bb(i).biovol(id); bb(i).CYC_st=bb(i).st(id);   
    id=strcmp(diatom_names(6),bb(i).diatom); bb(i).DIT=bb(i).biovol(id); bb(i).DIT_st=bb(i).st(id);   
    id=strcmp(diatom_names(7),bb(i).diatom); bb(i).ENT=bb(i).biovol(id); bb(i).ENT_st=bb(i).st(id);   
    id=strcmp(diatom_names(8),bb(i).diatom); bb(i).GYR=bb(i).biovol(id); bb(i).GYR_st=bb(i).st(id);   
    id=strcmp(diatom_names(9),bb(i).diatom); bb(i).MEL=bb(i).biovol(id); bb(i).MEL_st=bb(i).st(id);   
    id=strcmp(diatom_names(10),bb(i).diatom); bb(i).NAV=bb(i).biovol(id); bb(i).NAV_st=bb(i).st(id);   
    id=strcmp(diatom_names(11),bb(i).diatom); bb(i).NIT=bb(i).biovol(id); bb(i).NIT_st=bb(i).st(id);   
    id=strcmp(diatom_names(12),bb(i).diatom); bb(i).ODO=bb(i).biovol(id); bb(i).ODO_st=bb(i).st(id);   
    id=strcmp(diatom_names(13),bb(i).diatom); bb(i).PAR=bb(i).biovol(id); bb(i).PAR_st=bb(i).st(id);       
    id=strcmp(diatom_names(14),bb(i).diatom); bb(i).PLE=bb(i).biovol(id); bb(i).PLE_st=bb(i).st(id);   
    id=strcmp(diatom_names(15),bb(i).diatom); bb(i).SKE=bb(i).biovol(id); bb(i).SKE_st=bb(i).st(id);   
    id=strcmp(diatom_names(16),bb(i).diatom); bb(i).THA=bb(i).biovol(id); bb(i).THA_st=bb(i).st(id);   
    id=strcmp(diatom_names(17),bb(i).diatom); bb(i).ULN=bb(i).biovol(id); bb(i).ULN_st=bb(i).st(id);   
    id=strcmp(diatom_names(18),bb(i).diatom); bb(i).U_D=bb(i).biovol(id); bb(i).U_D_st=bb(i).st(id); 
    
    id=strcmp(phylum_names(1),bb(i).phylum); bb(i).BACI=bb(i).biovol(id); bb(i).BACI_st=bb(i).st(id);    
    id=strcmp(phylum_names(2),bb(i).phylum); bb(i).CHLO=bb(i).biovol(id); bb(i).CHLO_st=bb(i).st(id);    
    id=strcmp(phylum_names(3),bb(i).phylum); bb(i).CHRY=bb(i).biovol(id); bb(i).CHRY_st=bb(i).st(id);    
    id=strcmp(phylum_names(4),bb(i).phylum); bb(i).CILI=bb(i).biovol(id); bb(i).CILI_st=bb(i).st(id);    
    id=strcmp(phylum_names(5),bb(i).phylum); bb(i).CRYP=bb(i).biovol(id); bb(i).CRYP_st=bb(i).st(id);    
    id=strcmp(phylum_names(6),bb(i).phylum); bb(i).CYAN=bb(i).biovol(id); bb(i).CYAN_st=bb(i).st(id);    
    id=strcmp(phylum_names(7),bb(i).phylum); bb(i).DINO=bb(i).biovol(id); bb(i).DINO_st=bb(i).st(id);    
    id=strcmp(phylum_names(8),bb(i).phylum); bb(i).EUGL=bb(i).biovol(id); bb(i).EUGL_st=bb(i).st(id);    
    id=strcmp(phylum_names(9),bb(i).phylum); bb(i).EUST=bb(i).biovol(id); bb(i).EUST_st=bb(i).st(id);    
    id=strcmp(phylum_names(10),bb(i).phylum); bb(i).HAPT=bb(i).biovol(id); bb(i).HAPT_st=bb(i).st(id);    
    id=strcmp(phylum_names(11),bb(i).phylum); bb(i).RAPH=bb(i).biovol(id); bb(i).RAPH_st=bb(i).st(id);    
end

clearvars id C i GENUS BIOVOL DN opts T PHYLUM ST;

%% remove all rows with less than one station represented
del=zeros(length(bb),1);
for i=1:length(bb)
    [ia,~,~] = unique(bb(i).st);    
    val=length(ia);
    if val>1
    else
        del(i)=i;        
    end
end
del(del==0)=[]; bb(del)=[];

bb=rmfield(bb,'a'); bb=rmfield(bb,'diatom'); bb=rmfield(bb,'phylum'); bb=rmfield(bb,'biovol'); bb=rmfield(bb,'st');

% sum if at same station
for i=1:length(bb)
    [bb(i).ACT_st,~,ic]=unique(bb(i).ACT_st); bb(i).ACT=accumarray(ic,bb(i).ACT,[],@(x) nansum(x));  
    [bb(i).AUL_st,~,ic]=unique(bb(i).AUL_st); bb(i).AUL=accumarray(ic,bb(i).AUL,[],@(x) nansum(x));  
    [bb(i).COC_st,~,ic]=unique(bb(i).COC_st); bb(i).COC=accumarray(ic,bb(i).COC,[],@(x) nansum(x));  
    [bb(i).COS_st,~,ic]=unique(bb(i).COS_st); bb(i).COS=accumarray(ic,bb(i).COS,[],@(x) nansum(x));  
    [bb(i).CYC_st,~,ic]=unique(bb(i).CYC_st); bb(i).CYC=accumarray(ic,bb(i).CYC,[],@(x) nansum(x));  
    [bb(i).DIT_st,~,ic]=unique(bb(i).DIT_st); bb(i).DIT=accumarray(ic,bb(i).DIT,[],@(x) nansum(x));  
    [bb(i).ENT_st,~,ic]=unique(bb(i).ENT_st); bb(i).ENT=accumarray(ic,bb(i).ENT,[],@(x) nansum(x));  
    [bb(i).GYR_st,~,ic]=unique(bb(i).GYR_st); bb(i).GYR=accumarray(ic,bb(i).GYR,[],@(x) nansum(x));  
    [bb(i).MEL_st,~,ic]=unique(bb(i).MEL_st); bb(i).MEL=accumarray(ic,bb(i).MEL,[],@(x) nansum(x));  
    [bb(i).NAV_st,~,ic]=unique(bb(i).NAV_st); bb(i).NAV=accumarray(ic,bb(i).NAV,[],@(x) nansum(x));  
    [bb(i).NIT_st,~,ic]=unique(bb(i).NIT_st); bb(i).NIT=accumarray(ic,bb(i).NIT,[],@(x) nansum(x));  
    [bb(i).ODO_st,~,ic]=unique(bb(i).ODO_st); bb(i).ODO=accumarray(ic,bb(i).ODO,[],@(x) nansum(x));  
    [bb(i).PAR_st,~,ic]=unique(bb(i).PAR_st); bb(i).PAR=accumarray(ic,bb(i).PAR,[],@(x) nansum(x));  
    [bb(i).PLE_st,~,ic]=unique(bb(i).PLE_st); bb(i).PLE=accumarray(ic,bb(i).PLE,[],@(x) nansum(x));  
    [bb(i).SKE_st,~,ic]=unique(bb(i).SKE_st); bb(i).SKE=accumarray(ic,bb(i).SKE,[],@(x) nansum(x));  
    [bb(i).THA_st,~,ic]=unique(bb(i).THA_st); bb(i).THA=accumarray(ic,bb(i).THA,[],@(x) nansum(x));  
    [bb(i).ULN_st,~,ic]=unique(bb(i).ULN_st); bb(i).ULN=accumarray(ic,bb(i).ULN,[],@(x) nansum(x));  
    [bb(i).U_D_st,~,ic]=unique(bb(i).U_D_st); bb(i).U_D=accumarray(ic,bb(i).U_D,[],@(x) nansum(x));  

    [bb(i).BACI_st,~,ic]=unique(bb(i).BACI_st); bb(i).BACI=accumarray(ic,bb(i).BACI,[],@(x) nansum(x));  
    [bb(i).CHLO_st,~,ic]=unique(bb(i).CHLO_st); bb(i).CHLO=accumarray(ic,bb(i).CHLO,[],@(x) nansum(x));  
    [bb(i).CHRY_st,~,ic]=unique(bb(i).CHRY_st); bb(i).CHRY=accumarray(ic,bb(i).CHRY,[],@(x) nansum(x));  
    [bb(i).CILI_st,~,ic]=unique(bb(i).CILI_st); bb(i).CILI=accumarray(ic,bb(i).CILI,[],@(x) nansum(x));  
    [bb(i).CRYP_st,~,ic]=unique(bb(i).CRYP_st); bb(i).CRYP=accumarray(ic,bb(i).CRYP,[],@(x) nansum(x));  
    [bb(i).CYAN_st,~,ic]=unique(bb(i).CYAN_st); bb(i).CYAN=accumarray(ic,bb(i).CYAN,[],@(x) nansum(x));  
    [bb(i).DINO_st,~,ic]=unique(bb(i).DINO_st); bb(i).DINO=accumarray(ic,bb(i).DINO,[],@(x) nansum(x));  
    [bb(i).EUGL_st,~,ic]=unique(bb(i).EUGL_st); bb(i).EUGL=accumarray(ic,bb(i).EUGL,[],@(x) nansum(x));  
    [bb(i).EUST_st,~,ic]=unique(bb(i).EUST_st); bb(i).EUST=accumarray(ic,bb(i).EUST,[],@(x) nansum(x));  
    [bb(i).HAPT_st,~,ic]=unique(bb(i).HAPT_st); bb(i).HAPT=accumarray(ic,bb(i).HAPT,[],@(x) nansum(x));  
    [bb(i).RAPH_st,~,ic]=unique(bb(i).RAPH_st); bb(i).RAPH=accumarray(ic,bb(i).RAPH,[],@(x) nansum(x));  
end

clearvars i id ic del val ia;

%% APPLY zeros where no phytoplankton were observed
for i=1:length(bb)
    bb(i).st=unique([bb(i).BACI_st;bb(i).CHLO_st;bb(i).CHRY_st;bb(i).CILI_st;bb(i).CRYP_st;...
        bb(i).CYAN_st;bb(i).EUGL_st;bb(i).EUST_st;bb(i).HAPT_st;bb(i).RAPH_st]);
end

g=struct('dn',NaN*ones(length(bb),1)); %preallocate 
for i=1:length(bb)
    g(i).dn=bb(i).dn;
    g(i).st=bb(i).st;    
    g(i).ACT=0*bb(i).st; 
    g(i).AUL=0*bb(i).st; 
    g(i).COC=0*bb(i).st; 
    g(i).COS=0*bb(i).st; 
    g(i).CYC=0*bb(i).st; 
    g(i).DIT=0*bb(i).st; 
    g(i).ENT=0*bb(i).st; 
    g(i).GYR=0*bb(i).st; 
    g(i).MEL=0*bb(i).st;    
    g(i).NAV=0*bb(i).st; 
    g(i).NIT=0*bb(i).st; 
    g(i).ODO=0*bb(i).st; 
    g(i).PAR=0*bb(i).st; 
    g(i).PLE=0*bb(i).st; 
    g(i).SKE=0*bb(i).st; 
    g(i).THA=0*bb(i).st; 
    g(i).ULN=0*bb(i).st;     
    g(i).U_D=0*bb(i).st;    
end
    
for i=1:length(g)
    [~,ia,ib]=intersect(bb(i).st,bb(i).ACT_st); g(i).ACT(ia)=bb(i).ACT(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).AUL_st); g(i).AUL(ia)=bb(i).AUL(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).COC_st); g(i).COC(ia)=bb(i).COC(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).COS_st); g(i).COS(ia)=bb(i).COS(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).CYC_st); g(i).CYC(ia)=bb(i).CYC(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).DIT_st); g(i).DIT(ia)=bb(i).DIT(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).ENT_st); g(i).ENT(ia)=bb(i).ENT(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).GYR_st); g(i).GYR(ia)=bb(i).GYR(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).MEL_st); g(i).MEL(ia)=bb(i).MEL(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).NAV_st); g(i).NAV(ia)=bb(i).NAV(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).NIT_st); g(i).NIT(ia)=bb(i).NIT(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).ODO_st); g(i).ODO(ia)=bb(i).ODO(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).PAR_st); g(i).PAR(ia)=bb(i).PAR(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).PLE_st); g(i).PLE(ia)=bb(i).PLE(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).SKE_st); g(i).SKE(ia)=bb(i).SKE(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).THA_st); g(i).THA(ia)=bb(i).THA(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).ULN_st); g(i).ULN(ia)=bb(i).ULN(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).U_D_st); g(i).U_D(ia)=bb(i).U_D(ib);   
end

p=struct('dn',NaN*ones(length(bb),1)); %preallocate
for i=1:length(bb)
    p(i).dn=bb(i).dn;
    p(i).st=bb(i).st;    
    p(i).BACI=0*bb(i).st; 
    p(i).CHLO=0*bb(i).st; 
    p(i).CHRY=0*bb(i).st; 
    p(i).CILI=0*bb(i).st; 
    p(i).CRYP=0*bb(i).st; 
    p(i).CYAN=0*bb(i).st; 
    p(i).DINO=0*bb(i).st; 
    p(i).EUGL=0*bb(i).st; 
    p(i).EUST=0*bb(i).st; 
    p(i).HAPT=0*bb(i).st; 
    p(i).RAPH=0*bb(i).st; 
end

for i=1:length(p)    
    [~,ia,ib]=intersect(bb(i).st,bb(i).BACI_st); p(i).BACI(ia)=bb(i).BACI(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).CHLO_st); p(i).CHLO(ia)=bb(i).CHLO(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).CHRY_st); p(i).CHRY(ia)=bb(i).CHRY(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).CILI_st); p(i).CILI(ia)=bb(i).CILI(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).CRYP_st); p(i).CRYP(ia)=bb(i).CRYP(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).CYAN_st); p(i).CYAN(ia)=bb(i).CYAN(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).DINO_st); p(i).DINO(ia)=bb(i).DINO(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).EUGL_st); p(i).EUGL(ia)=bb(i).EUGL(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).EUST_st); p(i).EUST(ia)=bb(i).EUST(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).HAPT_st); p(i).HAPT(ia)=bb(i).HAPT(ib); 
    [~,ia,ib]=intersect(bb(i).st,bb(i).RAPH_st); p(i).RAPH(ia)=bb(i).RAPH(ib);     
end

clearvars ia ib i bb

%% allocate stations
load(distance,'d19','st','lat','lon');
id=find(d19>0,1); d19(1:id-1)=[]; lat(1:id-1)=[]; lon(1:id-1)=[]; st(1:id-1)=[];

%% DIATOM: insert existing data into new structure to facilitate pcolor
G=struct('dn',NaN*ones(length(g),1)); %preallocate 
for i=1:length(g)
    G(i).dn=g(i).dn;
    G(i).st=st;
    G(i).d19=d19;    
    G(i).lat=lat;
    G(i).lon=lon;   
    G(i).ACT=NaN*st; 
    G(i).AUL=NaN*st; 
    G(i).COC=NaN*st;  
    G(i).COS=NaN*st; 
    G(i).CYC=NaN*st; 
    G(i).DIT=NaN*st; 
    G(i).ENT=NaN*st; 
    G(i).GYR=NaN*st; 
    G(i).MEL=NaN*st;    
    G(i).NAV=NaN*st; 
    G(i).NIT=NaN*st; 
    G(i).ODO=NaN*st; 
    G(i).PAR=NaN*st; 
    G(i).PLE=NaN*st; 
    G(i).SKE=NaN*st; 
    G(i).THA=NaN*st; 
    G(i).ULN=NaN*st;     
    G(i).U_D=NaN*st;    
end
    
for i=1:length(G)
    [~,ia,ib]=intersect(st,g(i).st); 
    G(i).ACT(ia)=g(i).ACT(ib); 
    G(i).AUL(ia)=g(i).AUL(ib); 
    G(i).COC(ia)=g(i).COC(ib); 
    G(i).COS(ia)=g(i).COS(ib); 
    G(i).CYC(ia)=g(i).CYC(ib); 
    G(i).DIT(ia)=g(i).DIT(ib); 
    G(i).ENT(ia)=g(i).ENT(ib); 
    G(i).GYR(ia)=g(i).GYR(ib); 
    G(i).MEL(ia)=g(i).MEL(ib); 
    G(i).NAV(ia)=g(i).NAV(ib); 
    G(i).NIT(ia)=g(i).NIT(ib); 
    G(i).ODO(ia)=g(i).ODO(ib); 
    G(i).PAR(ia)=g(i).PAR(ib); 
    G(i).PLE(ia)=g(i).PLE(ib); 
    G(i).SKE(ia)=g(i).SKE(ib); 
    G(i).THA(ia)=g(i).THA(ib); 
    G(i).ULN(ia)=g(i).ULN(ib); 
    G(i).U_D(ia)=g(i).U_D(ib);   
end

%% PHYLUM: insert existing data into new structure to facilitate pcolor
P=struct('dn',NaN*ones(length(p),1)); %preallocate 
for i=1:length(p)
    P(i).dn=datenum(p(i).dn);
    P(i).st=st;
    P(i).d19=d19;    
    P(i).lat=lat;
    P(i).lon=lon;   
    P(i).BACI=NaN*st; 
    P(i).CHLO=NaN*st; 
    P(i).CHRY=NaN*st; 
    P(i).CILI=NaN*st; 
    P(i).CRYP=NaN*st; 
    P(i).CYAN=NaN*st; 
    P(i).DINO=NaN*st; 
    P(i).EUGL=NaN*st; 
    P(i).EUST=NaN*st;    
    P(i).HAPT=NaN*st; 
    P(i).RAPH=NaN*st;    
end
            
for i=1:length(P) 
    [~,ia,ib]=intersect(st,p(i).st); 
    P(i).BACI(ia)=p(i).BACI(ib); 
    P(i).CHLO(ia)=p(i).CHLO(ib); 
    P(i).CHRY(ia)=p(i).CHRY(ib); 
    P(i).CILI(ia)=p(i).CILI(ib); 
    P(i).CRYP(ia)=p(i).CRYP(ib); 
    P(i).CYAN(ia)=p(i).CYAN(ib); 
    P(i).DINO(ia)=p(i).DINO(ib); 
    P(i).EUGL(ia)=p(i).EUGL(ib); 
    P(i).EUST(ia)=p(i).EUST(ib); 
    P(i).HAPT(ia)=p(i).HAPT(ib); 
    P(i).RAPH(ia)=p(i).RAPH(ib); 
end
    
clearvars LAT LON lat lon d19 ST st D19 id i distance_st18 ia ib st g p;

%% eliminate surveys without North Bay datapoints
del=zeros(length(P),1);
for i=1:length(P)
    if nansum(P(i).BACI)==0
        del(i)=i;
    else
    end
end
del(del==0)=[]; G(del)=[]; P(del)=[]; %remove all points that don't match

%% remove all rows with less than one datapoint
del=zeros(length(P),1);
for i=1:length(P)
    val=sum(~isnan(P(i).BACI));
    if val>1
    else
        del(i)=i;        
    end
end
del(del==0)=[]; G(del)=[]; P(del)=[];

%%
save([filepath 'Data/microscopy_SFB_v2'],'G','P','diatom_names','phylum_names');
    
end