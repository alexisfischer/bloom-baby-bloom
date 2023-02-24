%% Find topclasses for each seascape
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; 
addpath(genpath(filepath)); 
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   

load([filepath 'NOAA/Shimada/Data/seascape_count_class_manual'],'seascape',...
    'ml_analyzed','classcount','filelist','class2use');

%find top seascapes, 100 file occurences
[gc,ss]=groupcounts(seascape);
topSS=ss(gc>100); 

% remove files without annotations
idx=isnan(classcount(:,1));
classcount(idx,:)=[]; filelist(idx)=[]; seascape(idx)=[]; ml_analyzed(idx)=[];

% Exclude nonliving, larvae, zooplankton, centric, unclassified
classcount(:,get_class_ind(class2use,'nonliving',class_indices_path))=NaN;
classcount(:,get_class_ind(class2use,'larvae',class_indices_path))=NaN;
classcount(:,get_class_ind(class2use,'zooplankton',class_indices_path))=NaN;
classcount(:,strcmp('unclassified',class2use))=NaN;
classcount(:,strcmp('flagellate',class2use))=NaN;
classcount(:,strcmp('Dinophyceae_pointed',class2use))=NaN;
classcount(:,strcmp('Dinophyceae_round',class2use))=NaN;
classcount(:,strcmp('centric',class2use))=NaN;

% merge species of Pseudo-nitzschia, Dinophysis, Chaetoceros, Thalassiosira classes,
idx=contains(class2use,'Dinophysis');
temp=sum(classcount(:,idx),2,'omitnan'); classcount(:,idx)=NaN;
classcount(:,strcmp('Dinophysis',class2use))=temp;

idx=contains(class2use,'Pseudo');
temp=sum(classcount(:,idx),2,'omitnan'); classcount(:,idx)=NaN;
classcount(:,strcmp('Pseudo-nitzschia',class2use))=temp;

idx=contains(class2use,'Chaetoceros');
temp=sum(classcount(:,idx),2,'omitnan'); classcount(:,idx)=NaN;
classcount(:,strcmp('Chaetoceros_chain',class2use))=temp;

idx=contains(class2use,'Thalassiosira');
temp=sum(classcount(:,idx),2,'omitnan'); classcount(:,idx)=NaN;
classcount(:,strcmp('Thalassiosira_chain',class2use))=temp;

% find top classes and summarize each seascape
num=30;
for i=1:length(topSS)
    idx=find(seascape==topSS(i)); %indices of a particular ss
    counttemp=classcount(idx,:);
    sstotal=sum(counttemp,1,'omitnan');
    id2=find(sstotal>0);
    if length(id2)>=num
        [~,id_top]=maxk(sstotal,num); %find top cellcount classes
    else
        id_top=id2;
    end
    SS(i).ss=topSS(i); %SS(i).ss=num2str(topSS(i));
    SS(i).topclasses=(class2use(id_top));
    SS(i).filename=filelist(idx);
    SS(i).classcount=counttemp;
    SS(i).MCnum=sum(sum(counttemp,'omitnan'),'omitnan');
end

% add summmary
SS(end+1).ss=[];
sstotal=sum(classcount,1,'omitnan');
[~,id_top]=maxk(sstotal,num); %find top cellcount classes
SS(end).topclasses=sort(class2use(id_top));
SS(end).filename=filelist;
SS(end).classcount=classcount;
SS(end).MCnum=sum(sum(classcount,'omitnan'),'omitnan');

clearvars i idx id_top ss gc sstotal counttemp temp id_t topSS id2 temp

%% plot # annotated files
label={SS.ss};label(end)=[];
figure('Units','inches','Position',[1 1 3 3],'PaperPositionMode','auto');   
bar([SS(1:end-1).MCnum],'Barwidth',.5,'linestyle','none'); hold on
set(gca,'xtick',1:length([SS.MCnum])-1,'xticklabel',label,'tickdir','out'); hold on
ylabel('number of annotated images')
xlabel('seascape')

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/AnnotatedImagesperSeascape.png']);
hold off 

%% plot top classes using cells/ml
label={SS.ss};label(end)={'all'};
%remove classes that are not present for plotting
id=NaN*ones(length(SS),length(class2use));
for i=1:length(SS)
    [~,temp]=(ismember(class2use,SS(i).topclasses));
    id(i,:)=double(temp);
end
class2useTop=class2use(sum(id)>0);

id=NaN*ones(length(SS),length(class2useTop));
for i=1:length(SS)
    temp=contains(class2useTop,SS(i).topclasses);  
    id(i,:)=double(temp);
end
[~,class_label ] = get_class_ind(class2useTop,'all', class_indices_path);

figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');   
plot(1:length(class_label),transpose(id).*(1:length(SS)),'*'); hold on
set(gca,'ycolor','k','ylim',[.8 7.2],'ytick',1:length(SS),'yticklabel',label,...
    'xlim',[0 (length(class_label)+1)],'xtick', 1:length(class_label),'xticklabel', class_label,'tickdir','out'); hold on
ylabel('seascape')
title(['Top ' num2str(num) ' classes for each seascape']);

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/topclass_CCS_cellcount_Seascape.png']);
hold off 

%% produce classlists to allow for grouped classes in classifier
%add back in species for Pseudo-nitzschia, Dinophysis, Chaetoceros, Thalassiosira classes

for i=1:length(SS)
    if ~isempty(contains(SS(i).topclasses,'Dinophysis'))
        temp={'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata'...
            'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' ...
            'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'};
        SS(i).topclasses=[SS(i).topclasses,temp];
    end

    if ~isempty(contains(SS(i).topclasses,'Pseudo-nitzschia'))
        temp={'Pseudo-nitzschia_small_1cell' 'Pseudo-nitzschia_small_2cell' 'Pseudo-nitzschia_small_3cell' 'Pseudo-nitzschia_small_4cell' 'Pseudo-nitzschia_small_5cell' 'Pseudo-nitzschia_small_6cell' ...
            'Pseudo-nitzschia_large_1cell' 'Pseudo-nitzschia_large_2cell' 'Pseudo-nitzschia_large_3cell' 'Pseudo-nitzschia_large_4cell' 'Pseudo-nitzschia_large_5cell' 'Pseudo-nitzschia_large_6cell'};
        SS(i).topclasses=[SS(i).topclasses,temp];    
    end

    if ~isempty(contains(SS(i).topclasses,'Thalassiosira'))
        SS(i).topclasses=[SS(i).topclasses,{'Thalassiosira_chain' 'Thalassiosira_single'}];   
    end

    if ~isempty(contains(SS(i).topclasses,'Chaetoceros'))
        SS(i).topclasses=[SS(i).topclasses,{'Chaetoceros_chain' 'Chaetoceros_single'}];   
    end

    if ~isempty(contains(SS(i).topclasses,'Guinardia'))
        SS(i).topclasses=[SS(i).topclasses,{'Dactyliosolen'}];    
    end
    if ~isempty(contains(SS(i).topclasses,'Dactyliosolen'))
        SS(i).topclasses=[SS(i).topclasses,{'Guinardia'}];  
    end

    if ~isempty(contains(SS(i).topclasses,'Detonula'))
        SS(i).topclasses=[SS(i).topclasses,{'Cerataulina' 'Lauderia'}];    
    end
    if ~isempty(contains(SS(i).topclasses,'Cerataulina'))
        SS(i).topclasses=[SS(i).topclasses,{'Detonula' 'Lauderia'}];    
    end
    if ~isempty(contains(SS(i).topclasses,'Lauderia'))
        SS(i).topclasses=[SS(i).topclasses,{'Detonula' 'Cerataulina'}];    
    end

    if ~isempty(contains(SS(i).topclasses,'Cylindrotheca'))
        SS(i).topclasses=[SS(i).topclasses,{'Nitzschia'}];    
    end
    if ~isempty(contains(SS(i).topclasses,'Nitzschia'))
        SS(i).topclasses=[SS(i).topclasses,{'Cylindrotheca'}];    
    end    
 
    if ~isempty(contains(SS(i).topclasses,'Rhizosolenia'))
        SS(i).topclasses=[SS(i).topclasses,{'Proboscia'}];
    end    
    if ~isempty(contains(SS(i).topclasses,'Proboscia'))
        SS(i).topclasses=[SS(i).topclasses,{'Rhizosolenia'}];   
    end    

    if ~isempty(contains(SS(i).topclasses,'Scrippsiella'))
        SS(i).topclasses=[SS(i).topclasses,{'Heterocapsa'}];
    end   

    if ~isempty(contains(SS(i).topclasses,'Heterocapsa'))
        SS(i).topclasses=[SS(i).topclasses,{'Scrippsiella'}];
    end   

    if ~isempty(contains(SS(i).topclasses,'Stephanopyxis'))
        SS(i).topclasses=[SS(i).topclasses,{'Melosira'}];    
    end  
    if ~isempty(contains(SS(i).topclasses,'Melosira'))
        SS(i).topclasses=[SS(i).topclasses,{'Stephanopyxis'}];   
    end     

    if ~isempty(contains(SS(i).topclasses,'Amylax'))
        SS(i).topclasses=[SS(i).topclasses,{'Protoceratium' 'Gonyaulax'}];  
    end     
    if ~isempty(contains(SS(i).topclasses,'Gonyaulax'))
        SS(i).topclasses=[SS(i).topclasses,{'Amylax' 'Protoceratium'}];
    end     
    if ~isempty(contains(SS(i).topclasses,'Protoceratium'))
        SS(i).topclasses=[SS(i).topclasses,{'Amylax' 'Gonyaulax'}];    
    end         


    [SS(i).topclasses,idx]=unique(SS(i).topclasses);
end

save([filepath 'NOAA/Shimada/Data/seascape_topclasses'],'SS','class2use');

