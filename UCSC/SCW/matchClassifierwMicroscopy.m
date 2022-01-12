function [class2do_string,mdate,y_mat,iraicar,iraifx,fish,mcrpy,RAI] = matchClassifierwMicroscopy(filepath1,filepath2,class2do_string,chain,error,yr)
%% matches IFCB classifier data with weekly microscopy data from Utermohls, FISH, and RAI

% %example inputs
% filepath1 = '~/MATLAB/bloom-baby-bloom/IFCB-Data/SCW/class/';
% filepath2 = '~/MATLAB/UCSC/SCW/Data/';
% class2do_string = 'Pseudo-nitzschia'; 
% chain=4;
% error=.7;
% yr='2018';

[cellsmL,~,mdate] = extract_daily_cellsml([filepath1 'summary_allTB_' yr]);
[phytoTotal,~,~,~,~,carbonml,~,class2useTB,~] = extract_daily_carbon_SCW([filepath1 'summary_biovol_allTB' yr]);

id=strcmp('Alexandrium_singlet',class2do_string); 
if id==1
    class2useTB(id)={'Alexandrium'}; 
    class2do_string='Alexandrium';
else
end

%%%% (1) extract Classifier data for class of interest
y_mat=cellsmL(:,strcmp(class2do_string, class2useTB)).*chain; %class
[rai_car,rai_fx] = convertIFCBtoRAI(phytoTotal,carbonml);
    iraifx=rai_fx(:,strcmp(class2do_string,class2useTB));
    iraicar=rai_car(:,strcmp(class2do_string,class2useTB));
idx=isnan(cellsmL(:,1)); y_mat(idx)=[]; mdate(idx)=[]; iraifx(idx)=[]; iraicar(idx)=[];
clearvars phytoTotal carbonml rai_car rai_fx idx cellsmL chain id
   
%%%% (2) extract Microscopy data for class of interest
load([filepath2 'Microscopy_SCW'],'micro','genus','dnM','err');
m=micro(:,strcmp(class2do_string,genus)); errM=err(:,strcmp(class2do_string,genus)).*m;
idx=(errM>=error); errM(idx)=[]; m(idx)=[]; dnM(idx)=[];
idx=isnan(m); m(idx)=[]; errM(idx)=[]; dnM(idx)=[];
[~,idx,~]=intersect(dnM,mdate); m=m(idx); dnM=dnM(idx); errM=errM(idx); %microscopy   
mcrpy.dn=dnM; mcrpy.cells=m; mcrpy.err=errM.*m;
clearvars dnM m errM idx genus micro err

%%%% (3) extract RAI data for class of interest
load([filepath2 'RAI'],'DN','class','RAI','FX');
id=strcmp(class2do_string,class); rai=RAI(:,id); fx=FX(:,id); clearvars RAI;
id=isnan(rai); rai(id)=[]; DN(id)=[]; fx(id)=[];
[~,iD,~] = intersect(DN, mdate); RAI.dn=DN(iD); RAI.chlrai=rai(iD); RAI.fx=fx(iD);
clearvars iD class id FX DN rai fx

%%%% (4) extract FISH data for class of interest and calculate errors
load([filepath2 'SCW_master'],'SC');
idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
if idx == 1
    dnF=SC.dn;
    iPn = strcmp(class2do_string,'Pseudo-nitzschia'); %classifier index
    iAlex = strcmp(class2do_string,'Alexandrium'); %classifier index
    iDphy = strcmp(class2do_string,'Dinophysis'); %classifier index
    if iPn == 1  
        F=SC.Pn*.001; n=F*10; %convert from cells/L to cells/mL and how many cells in 10mLs?
    elseif iAlex == 1
        F=SC.Alex*.001; n=F*100; %how many cells in 100mLs?
    elseif iDphy == 1
        F=SC.dinophysis*.001; n=F*100; %how many cells in 100mLs?
    end
    iD=isnan(F); dnF(iD)=[]; F(iD)=[]; n(iD)=[]; %eliminate NaNs
    errF=2./sqrt(n); % percent error for each species (Willen, 1976, Lund et al. 1958)    
    errF=errF.*F;
else
end

idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
if idx == 1
    [~,iD,~] = intersect(dnF, mdate); F=F(iD); dnF=dnF(iD); errF=errF(iD); %microscopy
    fish.dn=dnF; fish.cells=F; fish.err=errF;
else
    fish=[];
end

id=strcmp('Cochlodinium',class2do_string); 
if id==1
    class2do_string='Margalefidinium';
else
end

clearvars id idx iD iPn iAlex iDphy n errR dnF errF F SC chain error yr class2useTB error filepath1 filepath2

end

