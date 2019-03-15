%% Import SFB microscopy data
%addpath(genpath('~/Documents/UCSC_research/SanFranciscoBay/Microscopy/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

filepath = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SFB/';

opts = spreadsheetImportOptions("NumVariables", 13);
opts.Sheet = "all";
opts.DataRange = "A2:M17375";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Genus", "PhylumClass", "Date", "Var6", "Var7", "StationID", "Var9", "Var10", "DensitycellsmL", "BiovolumecubicmicrometersmL", "CellVolumecubicmicrometerscell"];
opts.SelectedVariableNames = ["Genus", "PhylumClass", "Date", "StationID", "DensitycellsmL", "BiovolumecubicmicrometersmL", "CellVolumecubicmicrometerscell"];
opts.VariableTypes = ["string", "string", "string", "string", "datetime", "string", "string", "double", "string", "string", "double", "double", "double"];
opts = setvaropts(opts, [1, 2, 3, 4, 6, 7, 9, 10], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 2, 3, 4, 6, 7, 9, 10], "EmptyFieldRule", "auto");
tbl = readtable("~/Documents/UCSC_research/SanFranciscoBay/Microscopy/Microscopy_SFB_2013-2018.xlsx", opts, "UseExcel", false);

% Convert to output type
genus = tbl.Genus;
phylum = tbl.PhylumClass;
dn = datenum(tbl.Date);
st = tbl.StationID;
cellsmL = tbl.DensitycellsmL;
biovol = tbl.BiovolumecubicmicrometersmL;
cellvol = tbl.CellVolumecubicmicrometerscell;
clear opts tbl

[lat,lon] = match_st_lat_lon(st);

%% Species of interest
%Thalassiosira (representative marine species)
%Entomoneis (representative freshwater species)
species=["Entomoneis"; "Thalassiosira"];

for ii=1:length(species)   
    id = contains(genus,species(ii));
    DN=dn(id); ST=st(id); CM=cellsmL(id); BV=biovol(id); LAT=lat(id); LON=lon(id);
    [C,IA,~] = unique(DN);

    % organize data into structure by dates
    for i=1:length(C)
        if i<length(C)
            MM(i).a=(IA(i):(IA(i+1)-1));        
            MM(i).dn=C(i);
            else
            MM(i).a=(IA(i):length(DN));        
            MM(i).dn=C(i);        
        end
    end 

    for i=1:length(MM)
        MM(i).st = ST(MM(i).a);            
        MM(i).lat = LAT(MM(i).a);            
        MM(i).lon = LON(MM(i).a);            
        MM(i).cellsmL = CM(MM(i).a);        
        MM(i).biovol = BV(MM(i).a);        
    end

    % eliminate surveys without delta datapoints
    for i=1:length(MM)
        suisun=ismember(MM(i).st,6);
        MM(i).suisun=sum(suisun);
    end
    [row,~]=find([MM.suisun]');
    M=MM(row);
    M=rmfield(M,'suisun');

    % sum if at same station
    for i=1:length(M)
        for j=1:length(M(i).st)
            [C,IA,IC] = unique(M(i).st);
            M(i).cellsmL = accumarray(IC,M(i).cellsmL); 
            M(i).biovol = accumarray(IC,M(i).biovol);
            M(i).st = C;
            M(i).lat = M(i).lat(IA);
            M(i).lon = M(i).lon(IA);
        end
    end
    M=rmfield(M,'a');
    
    if contains(species(ii),"Thalassiosira")
        tha=M;
    elseif contains(species(ii),"Entomoneis")
        ent=M;
    end

    clearvars MM M C IA IC id DN ST CM BV LAT LON;
    
end

%% Phylum of interest

P=unique(phylum);

for ii=1:length(P)   
    id = contains(phylum,P(ii));
    DN=dn(id); ST=st(id); CM=cellsmL(id); BV=biovol(id); LAT=lat(id); LON=lon(id);
    [C,IA,~] = unique(DN);

    % organize data into structure by dates
    for i=1:length(C)
        if i<length(C)
            MM(i).a=(IA(i):(IA(i+1)-1));        
            MM(i).dn=C(i);
            else
            MM(i).a=(IA(i):length(DN));        
            MM(i).dn=C(i);        
        end
    end 

    for i=1:length(MM)
        MM(i).st = ST(MM(i).a);
        MM(i).lat = LAT(MM(i).a);            
        MM(i).lon = LON(MM(i).a);           
        MM(i).cellsmL = CM(MM(i).a);        
        MM(i).biovol = BV(MM(i).a);        
    end

    % eliminate surveys without delta datapoints
    for i=1:length(MM)
        suisun=ismember(MM(i).st,[3,6]) ;
        MM(i).suisun=sum(suisun);
    end
    [row,~]=find([MM.suisun]');
    M=MM(row);
    M=rmfield(M,'suisun');
    
    % sum if at same station
    for i=1:length(M)
        for j=1:length(M(i).st)
            [C,IA,IC] = unique(M(i).st);
            M(i).cellsmL = accumarray(IC,M(i).cellsmL); 
            M(i).biovol = accumarray(IC,M(i).biovol);
            M(i).st = C;
            M(i).lat = M(i).lat(IA);
            M(i).lon = M(i).lon(IA);            
        end
    end
    M=rmfield(M,'a');
    
    if contains(P(ii),"BACILLARIOPHYTA")
        BACI=M;
    elseif contains(P(ii),"CHLOROPHYTA")
        CHLO=M;
    elseif contains(P(ii),"CHRYSOPHYCEAE")
        CHRY=M;
    elseif contains(P(ii),"CILIOPHORA")
        CILI=M;
    elseif contains(P(ii),"CRYPTOPHYTA")
        CRYP=M;        
    elseif contains(P(ii),"CYANOPHYCEAE")
        CYAN=M;
    elseif contains(P(ii),"DINOPHYCEAE")
        DINO=M;        
    elseif contains(P(ii),"EUGLENOPHYTA")
        EUGL=M;
    elseif contains(P(ii),"EUSTIGMATOPHYCEAE")
        EUST=M;        
    elseif contains(P(ii),"HAPTOPHYTA")
        HAPT=M;
    elseif contains(P(ii),"RAPHIDOPHYCEAE")
        RAPH=M;          
        
    end
    clearvars MM M C IA IC id DN ST CM BV LAT LON;

end

%% organize data into structure by dates
[C,IA,~] = unique(dn);

% organize data into structure by dates
for i=1:length(C)
    if i<length(C)
        MM(i).a=(IA(i):(IA(i+1)-1));        
        MM(i).dn=C(i);
        else
        MM(i).a=(IA(i):length(dn));        
        MM(i).dn=C(i);        
    end
end    
   
for i=1:length(MM)
    MM(i).st = st(MM(i).a); 
    MM(i).lat = lat(MM(i).a);            
    MM(i).lon = lon(MM(i).a);         
    MM(i).biovol = biovol(MM(i).a);        
end

% eliminate surveys without delta datapoints
for i=1:length(MM)
    suisun=ismember(MM(i).st,6);
    MM(i).suisun=sum(suisun);
end
[row,~]=find([MM.suisun]');
M=MM(row);
M=rmfield(M,'suisun');
    
% sum if at same station
for i=1:length(M)
    for j=1:length(M(i).st)
        [C,IA,IC] = unique(M(i).st);
        M(i).biovol = accumarray(IC,M(i).biovol);
        M(i).st = C;
        M(i).lat = M(i).lat(IA);
        M(i).lon = M(i).lon(IA);           
    end
end

M=rmfield(M,'a');

clearvars MMBV CM C DN IA IC id i ii j ST species biovol cellsmL...
    cellvol dn genus phylum st lat LAT lon LON;

%% interpolate Diatoms
load([filepath 'Data/st_d18_d19_lat_lon'],'d18','st','lat','lon');

var=BACI;
% fill in gaps w NaNs so stations of interest are represented (facilitate pcolor)
for i=1:length(var)
    B(i).dn=var(i).dn;
    B(i).st=st; %longest component
    B(i).d18=d18;
    B(i).lat=lat;
    B(i).lon=lon;
    B(i).cellsmL=NaN*st;
    B(i).biovol=NaN*st;
end

%insert existing data into new structure
for i=1:length(var)
    [~,id]=ismember(var(i).st,B(i).st);
    B(i).cellsmL(id)=var(i).cellsmL;
    B(i).biovol(id)=var(i).biovol;
end

%only select specific stations
[id,~]=find(B(1).st ==[4,6,12,13,18,649,657]);
for i=1:length(B)
    B(i).st=B(i).st(id); 
    B(i).d18=B(i).d18(id); 
    B(i).lat=B(i).lat(id); 
    B(i).lon=B(i).lon(id); 
    B(i).cellsmL=B(i).cellsmL(id); 
    B(i).biovol=B(i).biovol(id); 
end

%sort in ascending d18
for i=1:length(B) 
    TF=issorted(B(i).d18); 
    if TF == 0   
        [~,idx]=sort(B(i).d18);
        B(i).st=B(i).st(idx);
        B(i).d18=B(i).d18(idx);
        B(i).lat=B(i).lat(idx);
        B(i).lon=B(i).lon(idx);
        B(i).cellsmL=B(i).cellsmL(idx);
        B(i).biovol=B(i).biovol(idx);
    else
    end
end  

BAi=B;
for i=1:length(B)
    BAi(i).cellsmL=fillmissing([B(i).cellsmL],'movmean',3);
    BAi(i).biovol=fillmissing([B(i).biovol],'movmean',3);
end

%% interpolate Cyanos
clearvars B

var=CYAN;
% fill in gaps w NaNs so stations of interest are represented (facilitate pcolor)
for i=1:length(var)
    B(i).dn=var(i).dn;
    B(i).st=st; %longest component
    B(i).d18=d18;
    B(i).lat=lat;
    B(i).lon=lon;
    B(i).cellsmL=NaN*st;
    B(i).biovol=NaN*st;
end

%insert existing data into new structure
for i=1:length(var)
    [~,id]=ismember(var(i).st,B(i).st);
    B(i).cellsmL(id)=var(i).cellsmL;
    B(i).biovol(id)=var(i).biovol;
end

%only select specific stations
[id,~]=find(B(1).st ==[4,6,12,13,18,649,657]);
for i=1:length(B)
    B(i).st=B(i).st(id); 
    B(i).d18=B(i).d18(id); 
    B(i).lat=B(i).lat(id); 
    B(i).lon=B(i).lon(id); 
    B(i).cellsmL=B(i).cellsmL(id); 
    B(i).biovol=B(i).biovol(id); 
end

%sort in ascending d18
for i=1:length(B) 
    TF=issorted(B(i).d18); 
    if TF == 0   
        [~,idx]=sort(B(i).d18);
        B(i).st=B(i).st(idx);
        B(i).d18=B(i).d18(idx);
        B(i).lat=B(i).lat(idx);
        B(i).lon=B(i).lon(idx);
        B(i).cellsmL=B(i).cellsmL(idx);
        B(i).biovol=B(i).biovol(idx);
    else
    end
end  

CYi=B;
for i=1:length(B)
    CYi(i).cellsmL=fillmissing([B(i).cellsmL],'movmean',3);
    CYi(i).biovol=fillmissing([B(i).biovol],'movmean',3);
end

%% interpolate Cryp
clearvars B

var=CRYP;
% fill in gaps w NaNs so stations of interest are represented (facilitate pcolor)
for i=1:length(var)
    B(i).dn=var(i).dn;
    B(i).st=st; %longest component
    B(i).d18=d18;
    B(i).lat=lat;
    B(i).lon=lon;
    B(i).cellsmL=NaN*st;
    B(i).biovol=NaN*st;
end

%insert existing data into new structure
for i=1:length(var)
    [~,id]=ismember(var(i).st,B(i).st);
    B(i).cellsmL(id)=var(i).cellsmL;
    B(i).biovol(id)=var(i).biovol;
end

%only select specific stations
[id,~]=find(B(1).st ==[4,6,12,13,18,649,657]);
for i=1:length(B)
    B(i).st=B(i).st(id); 
    B(i).d18=B(i).d18(id); 
    B(i).lat=B(i).lat(id); 
    B(i).lon=B(i).lon(id); 
    B(i).cellsmL=B(i).cellsmL(id); 
    B(i).biovol=B(i).biovol(id); 
end

%sort in ascending d18
for i=1:length(B) 
    TF=issorted(B(i).d18); 
    if TF == 0   
        [~,idx]=sort(B(i).d18);
        B(i).st=B(i).st(idx);
        B(i).d18=B(i).d18(idx);
        B(i).lat=B(i).lat(idx);
        B(i).lon=B(i).lon(idx);
        B(i).cellsmL=B(i).cellsmL(idx);
        B(i).biovol=B(i).biovol(idx);
    else
    end
end  

CRi=B;
for i=1:length(B)
    CRi(i).cellsmL=fillmissing([B(i).cellsmL],'movmean',3);
    CRi(i).biovol=fillmissing([B(i).biovol],'movmean',3);
end

%% interpolate Dino
clearvars B

var=DINO;
% fill in gaps w NaNs so stations of interest are represented (facilitate pcolor)
for i=1:length(var)
    B(i).dn=var(i).dn;
    B(i).st=st; %longest component
    B(i).d18=d18;
    B(i).lat=lat;
    B(i).lon=lon;
    B(i).cellsmL=NaN*st;
    B(i).biovol=NaN*st;
end

%insert existing data into new structure
for i=1:length(var)
    [~,id]=ismember(var(i).st,B(i).st);
    B(i).cellsmL(id)=var(i).cellsmL;
    B(i).biovol(id)=var(i).biovol;
end

%only select specific stations
[id,~]=find(B(1).st ==[4,6,12,13,18,649,657]);
for i=1:length(B)
    B(i).st=B(i).st(id); 
    B(i).d18=B(i).d18(id); 
    B(i).lat=B(i).lat(id); 
    B(i).lon=B(i).lon(id); 
    B(i).cellsmL=B(i).cellsmL(id); 
    B(i).biovol=B(i).biovol(id); 
end

%sort in ascending d18
for i=1:length(B) 
    TF=issorted(B(i).d18); 
    if TF == 0   
        [~,idx]=sort(B(i).d18);
        B(i).st=B(i).st(idx);
        B(i).d18=B(i).d18(idx);
        B(i).lat=B(i).lat(idx);
        B(i).lon=B(i).lon(idx);
        B(i).cellsmL=B(i).cellsmL(idx);
        B(i).biovol=B(i).biovol(idx);
    else
    end
end  

DIi=B;
for i=1:length(B)
    DIi(i).cellsmL=fillmissing([B(i).cellsmL],'movmean',3);
    DIi(i).biovol=fillmissing([B(i).biovol],'movmean',3);
end

%%
save([filepath 'Data/microscopy_SFB'],'BACI','CHLO','CHRY','CILI','CRYP',...
    'CYAN','DINO','ent','EUGL','EUST','HAPT','M','RAPH','tha',...
    'BAi','CYi','CRi','DIi');

%%
% note1 = 'Density (cells/mL)';	
% note2 = 'Biovolume (cubic micrometers/mL)';
% note3 = 'Cell Volume (cubic micrometers/cell)';

%% currently not using
%originally wrote with the intention of making a massive structure
% for i=1:length(s)
%     s(i).dn=datenum(s(i).dn);
% end
% 
% 
% for i=1:length(s)
%     for j=1:length(m)
%         if m(j).dn == s(i).dn
%             s(i).genus = genus(m(j).a);        
%             s(i).cellsmL = cellsmL(m(j).a);        
%             s(i).biovol = biovol(m(j).a);        
%             s(i).cellvol = cellvol(m(j).a);              
%         else
%         end
%     end
% end
