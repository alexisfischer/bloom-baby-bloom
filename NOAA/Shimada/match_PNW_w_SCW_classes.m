function [ class2use, classcount ] = match_PNW_w_SCW_classes( class2use,class2useTB,classcount )
%function [ class2use, classcount ] = match_PNW_w_SCW_classes( class2use, classcount )
% modify Brian Bill's class list so matches SCW classifer
%  Alexis D. Fischer, NOAA NWFSC March 2021

%renaming
class2use(strcmp('Alexandrium',class2use))={'Alexandrium_singlet'};
class2use(strcmp('Centric_diatom',class2use))={'Centric'};
class2use(strcmp('Pennate_diatom',class2use))={'Pennate'};

% merge Chaetoceros, Chaetoceros setae
idx = strcmp('Chaetoceros',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Chaetoceros',class2use)),...
    classcount(:,strcmp('Chaetoceros setae',class2use))],2);
classcount(:,strcmp('Chaetoceros setae',class2use))=[]; class2use(strcmp('Chaetoceros setae',class2use))=[];

% merge Amylax Gonyaulax Protoceratium
idx = strcmp('Amylax',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Amylax',class2use)),...
    classcount(:,strcmp('Gonyaulux',class2use)),...
    classcount(:,strcmp('Protoceratium',class2use))],2);
class2use(idx)={'Amy_Gony_Protoc'};
classcount(:,strcmp('Gonyaulux',class2use))=[]; class2use(strcmp('Gonyaulux',class2use))=[];
classcount(:,strcmp('Protoceratium',class2use))=[]; class2use(strcmp('Protoceratium',class2use))=[];

% merge Asterionellopsis, Asterioplanus
idx = strcmp('Asterionellopsis',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Asterionellopsis',class2use)),...
    classcount(:,strcmp('Asterioplanus',class2use))],2);
classcount(:,strcmp('Asterioplanus',class2use))=[]; class2use(strcmp('Asterioplanus',class2use))=[];

% merge Cryptophyte, NanoP_less10
idx = strcmp('Cryptophyte',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Cryptophyte',class2use)),...
    classcount(:,strcmp('Nanoplankton_<10',class2use))],2);
class2use(idx)={'Cryptophyte,NanoP_less10,small_misc'};
classcount(:,strcmp('Nanoplankton_<10',class2use))=[]; class2use(strcmp('Nanoplankton_<10',class2use))=[];

% merge Cylindrotheca, Nitzschia
idx = strcmp('Cylindrotheca',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Cylindrotheca',class2use)),...
    classcount(:,strcmp('Nitzschia',class2use))],2);
class2use(idx)={'Cyl_Nitz'};
classcount(:,strcmp('Nitzschia',class2use))=[]; class2use(strcmp('Nitzschia',class2use))=[];

% merge Detonula, Cerataulina, Lauderia
idx = strcmp('Detonula',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Detonula',class2use)),...
    classcount(:,strcmp('Cerataulina',class2use))...
    classcount(:,strcmp('Lauderia',class2use))],2);
class2use(idx)={'Det_Cer_Lau'};
classcount(:,strcmp('Cerataulina',class2use))=[]; class2use(strcmp('Cerataulina',class2use))=[];
classcount(:,strcmp('Lauderia',class2use))=[]; class2use(strcmp('Lauderia',class2use))=[];

% merge Guinardia, Dactyliosolen
idx = strcmp('Guinardia',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Guinardia',class2use)),...
    classcount(:,strcmp('Dactyliosolen',class2use))],2);
class2use(idx)={'Guin_Dact'};
classcount(:,strcmp('Dactyliosolen',class2use))=[]; class2use(strcmp('Dactyliosolen',class2use))=[];

% merge Gymnodinium, Peridinium
idx = strcmp('Gymnodinium',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Gymnodinium',class2use)),...
    classcount(:,strcmp('Peridinium',class2use))],2);
class2use(idx)={'Gymnodinium,Peridinium'};
classcount(:,strcmp('Peridinium',class2use))=[]; class2use(strcmp('Peridinium',class2use))=[];

% merge Scrippsiella, Heterocapsa
idx = strcmp('Scrippsiella',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Scrippsiella',class2use)),...
    classcount(:,strcmp('Heterocapsa',class2use))],2);
class2use(idx)={'Scrip_Het'};
classcount(:,strcmp('Heterocapsa',class2use))=[]; class2use(strcmp('Heterocapsa',class2use))=[];

% merge Centric
idx = strcmp('Centric',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Centric',class2use)),...
    classcount(:,strcmp('Actinoptychus',class2use)),...
    classcount(:,strcmp('Asteromphalus',class2use)),...
    classcount(:,strcmp('Attheya',class2use)),...
    classcount(:,strcmp('Aulacodiscus',class2use)),...
    classcount(:,strcmp('Coscinodiscus',class2use))],2);
classcount(:,strcmp('Actinoptychus',class2use))=[]; class2use(strcmp('Actinoptychus',class2use))=[];
classcount(:,strcmp('Asteromphalus',class2use))=[]; class2use(strcmp('Asteromphalus',class2use))=[];
classcount(:,strcmp('Attheya',class2use))=[]; class2use(strcmp('Attheya',class2use))=[];
classcount(:,strcmp('Aulacodiscus',class2use))=[]; class2use(strcmp('Aulacodiscus',class2use))=[];
classcount(:,strcmp('Coscinodiscus',class2use))=[]; class2use(strcmp('Coscinodiscus',class2use))=[];

% merge Pennate
idx = strcmp('Pennate',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Pennate',class2use)),...
    classcount(:,strcmp('Actiniscus',class2use)),...
    classcount(:,strcmp('Bacillaria',class2use)),...
    classcount(:,strcmp('Corethron',class2use)),...
    classcount(:,strcmp('Gyrosigma',class2use)),...
    classcount(:,strcmp('Rhizosolenia',class2use))],2);
classcount(:,strcmp('Actiniscus',class2use))=[]; class2use(strcmp('Actiniscus',class2use))=[];
classcount(:,strcmp('Bacillaria',class2use))=[]; class2use(strcmp('Bacillaria',class2use))=[];
classcount(:,strcmp('Corethron',class2use))=[]; class2use(strcmp('Corethron',class2use))=[];
classcount(:,strcmp('Gyrosigma',class2use))=[]; class2use(strcmp('Gyrosigma',class2use))=[];
classcount(:,strcmp('Rhizosolenia',class2use))=[]; class2use(strcmp('Rhizosolenia',class2use))=[];

% create other diatom category
idx = strcmp('Bacteriastrum',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Bacteriastrum',class2use)),...
    classcount(:,strcmp('Entomoneis',class2use)),...
    classcount(:,strcmp('Ditylum',class2use)),...
    classcount(:,strcmp('Flagilaria',class2use)),...
    classcount(:,strcmp('Helicotheca',class2use)),...
    classcount(:,strcmp('Hemiaulus',class2use)),...
    classcount(:,strcmp('Leptocylindrus',class2use)),...
    classcount(:,strcmp('Licmophora',class2use)),...
    classcount(:,strcmp('Lioloma',class2use)),...
    classcount(:,strcmp('Lithodesmium',class2use)),...
    classcount(:,strcmp('Melosira',class2use)),...
    classcount(:,strcmp('Odontella',class2use)),...
    classcount(:,strcmp('Paralia',class2use)),...
    classcount(:,strcmp('Plagiogrammopsis',class2use)),...
    classcount(:,strcmp('Plagiolemma',class2use)),... 
    classcount(:,strcmp('Pleurosigma',class2use)),...
    classcount(:,strcmp('Proboscia',class2use)),...
    classcount(:,strcmp('Striatella',class2use)),...
    classcount(:,strcmp('Tropidoneis',class2use))],2);
class2use(idx)={'other_diatom'};
classcount(:,strcmp('Entomoneis',class2use))=[]; class2use(strcmp('Entomoneis',class2use))=[];
classcount(:,strcmp('Ditylum',class2use))=[]; class2use(strcmp('Ditylum',class2use))=[];
classcount(:,strcmp('Flagilaria',class2use))=[]; class2use(strcmp('Flagilaria',class2use))=[];
classcount(:,strcmp('Helicotheca',class2use))=[]; class2use(strcmp('Helicotheca',class2use))=[];
classcount(:,strcmp('Hemiaulus',class2use))=[]; class2use(strcmp('Hemiaulus',class2use))=[];
classcount(:,strcmp('Leptocylindrus',class2use))=[]; class2use(strcmp('Leptocylindrus',class2use))=[];
classcount(:,strcmp('Licmophora',class2use))=[]; class2use(strcmp('Licmophora',class2use))=[];
classcount(:,strcmp('Lioloma',class2use))=[]; class2use(strcmp('Lioloma',class2use))=[];
classcount(:,strcmp('Lithodesmium',class2use))=[]; class2use(strcmp('Lithodesmium',class2use))=[];
classcount(:,strcmp('Melosira',class2use))=[]; class2use(strcmp('Melosira',class2use))=[];
classcount(:,strcmp('Odontella',class2use))=[]; class2use(strcmp('Odontella',class2use))=[];
classcount(:,strcmp('Paralia',class2use))=[]; class2use(strcmp('Paralia',class2use))=[];
classcount(:,strcmp('Plagiogrammopsis',class2use))=[]; class2use(strcmp('Plagiogrammopsis',class2use))=[];
classcount(:,strcmp('Plagiolemma',class2use))=[]; class2use(strcmp('Plagiolemma',class2use))=[];
classcount(:,strcmp('Pleurosigma',class2use))=[]; class2use(strcmp('Pleurosigma',class2use))=[];
classcount(:,strcmp('Proboscia',class2use))=[]; class2use(strcmp('Proboscia',class2use))=[];
classcount(:,strcmp('Striatella',class2use))=[]; class2use(strcmp('Striatella',class2use))=[];
classcount(:,strcmp('Tropidoneis',class2use))=[]; class2use(strcmp('Tropidoneis',class2use))=[];

% merge Zooplankton
idx = strcmp('Zooplankton',class2use);
classcount(:,idx)=nansum([classcount(:,strcmp('Zooplankton',class2use)),...
    classcount(:,strcmp('Ciliate',class2use)),...
    classcount(:,strcmp('Mesodinium',class2use)),...
    classcount(:,strcmp('Sea_Urchin_larvae',class2use)),...
    classcount(:,strcmp('Tiarina',class2use)),...
    classcount(:,strcmp('Tintinnid',class2use)),...   
    classcount(:,strcmp('Tontonia',class2use)),...
    classcount(:,strcmp('Veliger',class2use))],2);
classcount(:,strcmp('Ciliate',class2use))=[]; class2use(strcmp('Ciliate',class2use))=[];
classcount(:,strcmp('Mesodinium',class2use))=[]; class2use(strcmp('Mesodinium',class2use))=[];
classcount(:,strcmp('Sea_Urchin_larvae',class2use))=[]; class2use(strcmp('Sea_Urchin_larvae',class2use))=[];
classcount(:,strcmp('Tiarina',class2use))=[]; class2use(strcmp('Tiarina',class2use))=[];
classcount(:,strcmp('Tintinnid',class2use))=[]; class2use(strcmp('Tintinnid',class2use))=[];
classcount(:,strcmp('Tontonia',class2use))=[]; class2use(strcmp('Tontonia',class2use))=[];
classcount(:,strcmp('Veliger',class2use))=[]; class2use(strcmp('Veliger',class2use))=[];

% add all categories not in SCW classifier to unclassified
[~,ia]=setdiff(class2use,class2useTB);
idx = strcmp('unclassified',class2use);
classcount(:,idx)=nansum([classcount(:,idx),classcount(:,ia)],2);
classcount(:,ia)=[]; class2use(ia)=[];


end
