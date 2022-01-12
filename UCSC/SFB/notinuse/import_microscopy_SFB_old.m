function [] = import_microscopy_SFB(filepath,microscopy,physical)
%% Import SFB microscopy data
% note1 = 'Density (cells/mL)';	
% note2 = 'Biovolume (cubic micrometers/mL)';
% note3 = 'Cell Volume (cubic micrometers/cell)';
clear;
 filepath = '~/MATLAB/bloom-baby-bloom/SFB/';
 microscopy = "/Users/afischer/Documents/UCSC_research/SanFranciscoBay/Data/Microscopy/Microscopy_SFB_2013-2019.xlsx";
 physical='~/MATLAB/bloom-baby-bloom/SFB/Data/physical_param';

opts = spreadsheetImportOptions("NumVariables", 13);
opts.Sheet = "all";
opts.DataRange = "A2:M18756";
opts.VariableNames = ["Var1", "Var2", "Genus", "PhylumClass", "Date", "Var6", "Var7", "StationID", "Var9", "Var10", "DensitycellsmL", "BiovolumecubicmicrometersmL", "CellVolumecubicmicrometerscell"];
opts.SelectedVariableNames = ["Genus", "PhylumClass", "Date", "StationID", "DensitycellsmL", "BiovolumecubicmicrometersmL", "CellVolumecubicmicrometerscell"];
opts.VariableTypes = ["string", "string", "string", "string", "datetime", "string", "string", "double", "string", "string", "double", "double", "double"];
opts = setvaropts(opts, [1, 2, 3, 4, 6, 7, 9, 10], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 6, 7, 9, 10], "EmptyFieldRule", "auto");
tbl = readtable(microscopy, opts, "UseExcel", false);

genus = tbl.Genus;
phylum = tbl.PhylumClass;
dn = datenum(tbl.Date);
st = tbl.StationID;
cellsmL = tbl.DensitycellsmL;
biovol = tbl.BiovolumecubicmicrometersmL;
clear opts tbl

%find the most abundant diatoms
id = contains(phylum,"BACILLARIOPHYTA");                 
diatoms=genus(id);
names = unique(diatoms);
count=NaN*ones(length(names),1);
biomass=count;
for i=1:length(names)
    id=strcmp(diatoms,names(i));
    biomass(i)=nansum(biovol(id));
end

%[~,ib]=sort(biomass,'descend'); biomass=biomass(ib); names=names(ib);

clearvars opts T id i microscopy;

%%
% Class of interest
P=unique(phylum); 
Sp=["Entomoneis";"Thalassiosira";"Skeletonema";"Paralia";"Cyclotella";...
    "Coscinodiscus";"Gyrosigma";"Ditylum";"Nitzschia";"Pleurosigma";...
    "Melosira";"Navicula";"Odontella";"Synedra";"Cocconeis";...
    "Ulnaria";"Aulacoseira";"Actinoptychus";"Unknown"];

classname=[P;Sp];
classID=[ones(size(P));zeros(size(Sp))]; %1s=phylum, 0s=species

for j=1:length(classID)
    
    if classID(j)==1 %if phylum
        classname(j)
        id = contains(phylum,classname(j));        
    elseif classID(j)==0 %if species   
        classname(j)
        id = contains(genus,classname(j));             
    end
    
    DN=dn(id); ST=st(id); CM=cellsmL(id); BV=biovol(id);
    [C,IA,~] = unique(DN);     
    M=struct('dn',NaN*ones(length(C),1)); %preallocate 
    
    for i=1:length(C) % organize data into structure by dates
        if i<length(C)
            M(i).a=(IA(i):(IA(i+1)-1));        
            M(i).dn=C(i);
        else
            M(i).a=(IA(i):length(DN));        
            M(i).dn=C(i);        
        end
    end 

    for i=1:length(M)
        M(i).st = ST(M(i).a);          
        M(i).cellsmL = CM(M(i).a);        
        M(i).biovol = BV(M(i).a);        
    end
    
    for i=1:length(M) % sum if at same station
        [C,~,IC] = unique(M(i).st);
        M(i).cellsmL = accumarray(IC,M(i).cellsmL,[],@(x) nansum(x)); 
        M(i).biovol = accumarray(IC,M(i).biovol,[],@(x) nansum(x));
        M(i).st = C;       
    end
    M=rmfield(M,'a');
      
    if contains(classname(j),"BACILLARIOPHYTA")
        BACI=M;
    elseif contains(classname(j),"CHLOROPHYTA")
        CHLO=M;
    elseif contains(classname(j),"CHRYSOPHYCEAE")
        CHRY=M;
    elseif contains(classname(j),"CILIOPHORA")
        CILI=M;
    elseif contains(classname(j),"CRYPTOPHYTA")
        CRYP=M;        
    elseif contains(classname(j),"CYANOPHYCEAE")
        CYAN=M;
    elseif contains(classname(j),"DINOPHYCEAE")
        DINO=M;        
    elseif contains(classname(j),"EUGLENOPHYTA")
        EUGL=M;
    elseif contains(classname(j),"EUSTIGMATOPHYCEAE")
        EUST=M;        
    elseif contains(classname(j),"HAPTOPHYTA")
        HAPT=M;
    elseif contains(classname(j),"RAPHIDOPHYCEAE")
        RAPH=M;   
    elseif contains(classname(j),"Thalassiosira")
        tha=M;
    elseif contains(classname(j),"Entomoneis")
        ent=M; 
    elseif contains(classname(j),"Skeletonema")
        ske=M;
    elseif contains(classname(j),"Paralia")
        par=M;      
    elseif contains(classname(j),"Cyclotella")
        cyc=M;             
    elseif contains(classname(j),"Coscinodiscus")
        cos=M;        
    elseif contains(classname(j),"Gyrosigma")
        gyr=M;             
    elseif contains(classname(j),"Ditylum")
        dit=M;  
    elseif contains(classname(j),"Nitzschia")
        nit=M;          
    elseif contains(classname(j),"Pleurosigma")
        ple=M;   
    elseif contains(classname(j),"Melosira")
        mel=M; 
    elseif contains(classname(j),"Navicula")
        nav=M;  
    elseif contains(classname(j),"Odontella")
        odo=M; 
    elseif contains(classname(j),"Synedra")
        syn=M;   
    elseif contains(classname(j),"Cocconeis")
        coc=M;   
    elseif contains(classname(j),"Ulnaria")
        uln=M;  
    elseif contains(classname(j),"Aulacoseira")
        aul=M;  
    elseif contains(classname(j),"Actinoptychus")
        act=M;          
        
    elseif contains(classname(j),"Unknown")
        unk=M;                  
    end
    clearvars M C IA IC id DN ST CM BV;
end

% put everything in one structure based on date and station
load(physical,'S'); st=S(1).st;

%% build large structure for biovolume
B=struct('dn',NaN*ones(length(dn),1)); %preallocate 

for i=1:length(S) % 
    B(i).dn=S(i).dn;
    B(i).st=S(i).st; 
    B(i).d18=S(i).d18;
    B(i).lat=S(i).lat;
    B(i).lon=S(i).lon;
    B(i).BACI=NaN*st;
    B(i).CHLO=NaN*st;
    B(i).CHRY=NaN*st;     
    B(i).CILI=NaN*st;     
    B(i).CYAN=NaN*st;
    B(i).CRYP=NaN*st;
    B(i).DINO=NaN*st;
    B(i).EUGL=NaN*st;
    B(i).EUST=NaN*st;
    B(i).HAPT=NaN*st;
    B(i).RAPH=NaN*st;    
    B(i).ent=NaN*st;
    B(i).tha=NaN*st;   
    B(i).ske=NaN*st;    
    B(i).par=NaN*st;
    B(i).cyc=NaN*st;      
    B(i).cos=NaN*st;      
    B(i).gyr=NaN*st;      
    B(i).dit=NaN*st;       
    B(i).nit=NaN*st;       
    B(i).ple=NaN*st;       
    B(i).mel=NaN*st;       
    B(i).nav=NaN*st;   
    B(i).syn=NaN*st;       
    B(i).odo=NaN*st;       
    B(i).coc=NaN*st;       
    B(i).uln=NaN*st;           
    B(i).aul=NaN*st;           
    B(i).act=NaN*st;           
    
    B(i).unk=NaN*st;       
    
end

C=B; %build large structure for cells/mL

% BACILLARIOPHYTA (diatoms)
for i=1:length(B)
    for j=1:length(BACI) 
        if BACI(j).dn == B(i).dn
            [~,id]=ismember(BACI(j).st,B(i).st);
            B(i).BACI(id)=BACI(j).biovol;
            C(i).BACI(id)=BACI(j).cellsmL;
        else
        end
    end
end

% CHLOROPHYTA
for i=1:length(B)
    for j=1:length(CHLO) 
        if CHLO(j).dn == B(i).dn
            [~,id]=ismember(CHLO(j).st,B(i).st);
            B(i).CHLO(id)=CHLO(j).biovol;
            C(i).CHLO(id)=CHLO(j).cellsmL;
        else
        end
    end
end

% CHRYSOPHYCEAE
for i=1:length(B)
    for j=1:length(CHRY) 
        if CHRY(j).dn == B(i).dn
            [~,id]=ismember(CHRY(j).st,B(i).st);
            B(i).CHRY(id)=CHRY(j).biovol;
            C(i).CHRY(id)=CHRY(j).cellsmL;
        else
        end
    end
end

% CILIOPHORA
for i=1:length(B)
    for j=1:length(CILI) 
        if CILI(j).dn == B(i).dn
            [~,id]=ismember(CILI(j).st,B(i).st);
            B(i).CILI(id)=CILI(j).biovol;
            C(i).CILI(id)=CILI(j).cellsmL;
        else
        end
    end
end

% CRYPTOPHYTA
for i=1:length(B)
    for j=1:length(CRYP) 
        if CRYP(j).dn == B(i).dn
            [~,id]=ismember(CRYP(j).st,B(i).st);
            B(i).CRYP(id)=CRYP(j).biovol;
            C(i).CRYP(id)=CRYP(j).cellsmL;
        else
        end
    end
end

% CYANOPHYCEAE
for i=1:length(B)
    for j=1:length(CYAN) 
        if CYAN(j).dn == B(i).dn
            [~,id]=ismember(CYAN(j).st,B(i).st);
            B(i).CYAN(id)=CYAN(j).biovol;
            C(i).CYAN(id)=CYAN(j).cellsmL;
        else
        end
    end
end

% DINOPHYCEAE
for i=1:length(B)
    for j=1:length(DINO) 
        if DINO(j).dn == B(i).dn
            [~,id]=ismember(DINO(j).st,B(i).st);
            B(i).DINO(id)=DINO(j).biovol;
            C(i).DINO(id)=DINO(j).cellsmL;
        else
        end
    end
end

% EUGLENOPHYTA
for i=1:length(B)
    for j=1:length(EUGL) 
        if EUGL(j).dn == B(i).dn
            [~,id]=ismember(EUGL(j).st,B(i).st);
            B(i).EUGL(id)=EUGL(j).biovol;
            C(i).EUGL(id)=EUGL(j).cellsmL;
        else
        end
    end
end

% EUSTIGMATOPHYCEAE
for i=1:length(B)
    for j=1:length(EUST) 
        if EUST(j).dn == B(i).dn
            [~,id]=ismember(EUST(j).st,B(i).st);
            B(i).EUST(id)=EUST(j).biovol;
            C(i).EUST(id)=EUST(j).cellsmL;
        else
        end
    end
end

% HAPTOPHYTA
for i=1:length(B)
    for j=1:length(HAPT) 
        if HAPT(j).dn == B(i).dn
            [~,id]=ismember(HAPT(j).st,B(i).st);
            B(i).HAPT(id)=HAPT(j).biovol;
            C(i).HAPT(id)=HAPT(j).cellsmL;
        else
        end
    end
end

% RAPHIDOPHYCEAE
for i=1:length(B)
    for j=1:length(RAPH) 
        if RAPH(j).dn == B(i).dn
            [~,id]=ismember(RAPH(j).st,B(i).st);
            B(i).RAPH(id)=RAPH(j).biovol;
            C(i).RAPH(id)=RAPH(j).cellsmL;
        else
        end
    end
end

% Entomoneis
for i=1:length(B)
    for j=1:length(ent) 
        if ent(j).dn == B(i).dn
            [~,id]=ismember(ent(j).st,B(i).st);
            B(i).ent(id)=ent(j).biovol;
            C(i).ent(id)=ent(j).cellsmL;
        else
        end
    end
end

% Thalassiosira
for i=1:length(B)
    for j=1:length(tha) 
        if tha(j).dn == B(i).dn
            [~,id]=ismember(tha(j).st,B(i).st);
            B(i).tha(id)=tha(j).biovol;
            C(i).tha(id)=tha(j).cellsmL;
        else
        end
    end
end

% Skeletonema
for i=1:length(B)
    for j=1:length(ske) 
        if ske(j).dn == B(i).dn
            [~,id]=ismember(ske(j).st,B(i).st);
            B(i).ske(id)=ske(j).biovol;
            C(i).ske(id)=ske(j).cellsmL;
        else
        end
    end
end

% Paralia
for i=1:length(B)
    for j=1:length(par) 
        if par(j).dn == B(i).dn
            [~,id]=ismember(par(j).st,B(i).st);
            B(i).par(id)=par(j).biovol;
            C(i).par(id)=par(j).cellsmL;
        else
        end
    end
end

% Cyclotella
for i=1:length(B)
    for j=1:length(cyc) 
        if cyc(j).dn == B(i).dn
            [~,id]=ismember(cyc(j).st,B(i).st);
            B(i).cyc(id)=cyc(j).biovol;
            C(i).cyc(id)=cyc(j).cellsmL;
        else
        end
    end
end 

% Coscinodiscus
for i=1:length(B)
    for j=1:length(cos) 
        if cos(j).dn == B(i).dn
            [~,id]=ismember(cos(j).st,B(i).st);
            B(i).cos(id)=cos(j).biovol;
            C(i).cos(id)=cos(j).cellsmL;
        else
        end
    end
end 

% Gyrosigma
for i=1:length(B)
    for j=1:length(gyr) 
        if gyr(j).dn == B(i).dn
            [~,id]=ismember(gyr(j).st,B(i).st);
            B(i).gyr(id)=gyr(j).biovol;
            C(i).gyr(id)=gyr(j).cellsmL;
        else
        end
    end
end 

% Ditylum
for i=1:length(B)
    for j=1:length(dit) 
        if dit(j).dn == B(i).dn
            [~,id]=ismember(dit(j).st,B(i).st);
            B(i).dit(id)=dit(j).biovol;
            C(i).dit(id)=dit(j).cellsmL;
        else
        end
    end
end 

% Nitzschia
for i=1:length(B)
    for j=1:length(nit) 
        if nit(j).dn == B(i).dn
            [~,id]=ismember(nit(j).st,B(i).st);
            B(i).nit(id)=nit(j).biovol;
            C(i).nit(id)=nit(j).cellsmL;
        else
        end
    end
end 

% Pleurosigma
for i=1:length(B)
    for j=1:length(ple) 
        if ple(j).dn == B(i).dn
            [~,id]=ismember(ple(j).st,B(i).st);
            B(i).ple(id)=ple(j).biovol;
            C(i).ple(id)=ple(j).cellsmL;
        else
        end
    end
end 

% Melosira
for i=1:length(B)
    for j=1:length(mel) 
        if mel(j).dn == B(i).dn
            [~,id]=ismember(mel(j).st,B(i).st);
            B(i).mel(id)=mel(j).biovol;
            C(i).mel(id)=mel(j).cellsmL;
        else
        end
    end
end 

% Navicula
for i=1:length(B)
    for j=1:length(nav) 
        if nav(j).dn == B(i).dn
            [~,id]=ismember(nav(j).st,B(i).st);
            B(i).nav(id)=nav(j).biovol;
            C(i).nav(id)=nav(j).cellsmL;
        else
        end
    end
end 

% Odontella
for i=1:length(B)
    for j=1:length(odo) 
        if odo(j).dn == B(i).dn
            [~,id]=ismember(odo(j).st,B(i).st);
            B(i).odo(id)=odo(j).biovol;
            C(i).odo(id)=odo(j).cellsmL;
        else
        end
    end
end 

% Synedra
for i=1:length(B)
    for j=1:length(syn) 
        if syn(j).dn == B(i).dn
            [~,id]=ismember(syn(j).st,B(i).st);
            B(i).syn(id)=syn(j).biovol;
            C(i).syn(id)=syn(j).cellsmL;
        else
        end
    end
end 

% Cocconeis
for i=1:length(B)
    for j=1:length(coc) 
        if coc(j).dn == B(i).dn
            [~,id]=ismember(coc(j).st,B(i).st);
            B(i).coc(id)=coc(j).biovol;
            C(i).coc(id)=coc(j).cellsmL;
        else
        end
    end
end 

% Ulnaria
for i=1:length(B)
    for j=1:length(uln) 
        if uln(j).dn == B(i).dn
            [~,id]=ismember(uln(j).st,B(i).st);
            B(i).uln(id)=uln(j).biovol;
            C(i).uln(id)=uln(j).cellsmL;
        else
        end
    end
end 

% Aulacoseira
for i=1:length(B)
    for j=1:length(aul) 
        if aul(j).dn == B(i).dn
            [~,id]=ismember(aul(j).st,B(i).st);
            B(i).aul(id)=aul(j).biovol;
            C(i).aul(id)=aul(j).cellsmL;
        else
        end
    end
end 

% Actinoptychus
for i=1:length(B)
    for j=1:length(act) 
        if act(j).dn == B(i).dn
            [~,id]=ismember(act(j).st,B(i).st);
            B(i).act(id)=act(j).biovol;
            C(i).act(id)=act(j).cellsmL;
        else
        end
    end
end 


% Unknown
for i=1:length(B)
    for j=1:length(unk) 
        if unk(j).dn == B(i).dn
            [~,id]=ismember(unk(j).st,B(i).st);
            B(i).unk(id)=unk(j).biovol;
            C(i).unk(id)=unk(j).cellsmL;
        else
        end
    end
end 


clearvars BACI CRYP CYAN DINO CHLO CILI CHRY EUGL EUST HAPT M RAPH tha ent i ...
    var id d18 lat lon id idx st TB var P row TF MM ii j phylum S species suisun file;

%
save([filepath 'Data/microscopy_SFB'],'B','C','classname');

end
