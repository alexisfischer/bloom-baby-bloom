%% Find topclasses for each seascape
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; 
addpath(genpath(filepath)); 

load([filepath 'NOAA/SeascapesProject/Data/seascape_count_class_manual'],'seascape',...
    'ml_analyzed','classcount','filelist','class2use');

%find top seascapes, 100 file occurences
[gc,ss]=groupcounts(seascape);
topSS=ss(gc>100); 

% remove files without annotations
idx=isnan(classcount(:,1));
classcount(idx,:)=[]; filelist(idx)=[]; seascape(idx)=[]; ml_analyzed(idx)=[];

% Exclude nonliving, larvae, zooplankton, and unclassified
classcount(:,get_class_ind(class2use,'nonliving',filepath))=NaN;
classcount(:,get_class_ind(class2use,'larvae',filepath))=NaN;
classcount(:,get_class_ind(class2use,'zooplankton',filepath))=NaN;
classcount(:,strcmp('unclassified',class2use))=NaN;
classcount(:,strcmp('flagellate',class2use))=NaN;
classcount(:,strcmp('Dinophyceae_pointed',class2use))=NaN;
classcount(:,strcmp('Dinophyceae_round',class2use))=NaN;

% merge species of Pseudo-nitzschia, Dinophysis, Chaetoceros, Thalassiosira classes,
idx=contains(class2use,'Dinophysis');
temp=sum(classcount(:,idx),2,'omitnan'); classcount(:,idx)=NaN;
classcount(:,strcmp('Dinophysis',class2use))=temp;

idx=contains(class2use,'Pseudo-nitzschia');
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
    SS(i).ss=num2str(topSS(i));
    SS(i).topclasses=(class2use(id_top));
    SS(i).filename=filelist(idx);
    SS(i).classcount=counttemp;
    SS(i).MCnum=sum(sum(counttemp,'omitnan'),'omitnan');
end

% add summmary
SS(end+1).ss='all';
sstotal=sum(classcount,1,'omitnan');
[~,id_top]=maxk(sstotal,num); %find top cellcount classes
SS(end).topclasses=sort(class2use(id_top));
SS(end).filename=filelist;
SS(end).classcount=classcount;
SS(end).MCnum=sum(sum(classcount,'omitnan'),'omitnan');

clearvars i idx id_top ss gc sstotal counttemp temp id_t topSS id2 temp

%% plot # annotated files
figure('Units','inches','Position',[1 1 3 3],'PaperPositionMode','auto');   
bar([SS.MCnum],'Barwidth',.5,'linestyle','none'); hold on
set(gca,'xtick',1:length([SS.MCnum]),'xticklabel', {SS.ss},'tickdir','out'); hold on
ylabel('number of annotated images')
xlabel('seascape')

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/SeascapesProject/Figs/AnnotatedImagesperSeascape.png']);
hold off 

%% plot top classes using cells/ml
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
[~,class_label ] = get_class_ind(class2useTop,'all', filepath);

figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');   
plot(1:length(class_label),transpose(id).*(1:length(SS)),'*'); hold on
set(gca,'ycolor','k','ylim',[.8 7.2],'ytick',1:length(SS),'yticklabel',{SS.ss},...
    'xlim',[0 (length(class_label)+1)],'xtick', 1:length(class_label),'xticklabel', class_label,'tickdir','out'); hold on
ylabel('seascape')
title(['Top ' num2str(num) ' classes for each seascape']);

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/SeascapesProject/Figs/topclass_CCS_cellcount_Seascape.png']);
hold off 

%% produce classlists for classifier making
%add back in species for Pseudo-nitzschia, Dinophysis, Chaetoceros, Thalassiosira classes

for i=1:length(SS)
    idx=contains(SS(i).topclasses,'Dinophysis');
    if ~isempty(idx)
        temp={'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata'...
            'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' ...
            'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'};
        SS(i).topclasses=[SS(i).topclasses,temp];
    else
    end
    idx=contains(SS(i).topclasses,'Pseudo-nitzschia');
    if ~isempty(idx)
        temp={'Pseudo-nitzschia_large_narrow' 'Pseudo-nitzschia_large_wide' 'Pseudo-nitzschia_small'};
        SS(i).topclasses=[SS(i).topclasses,temp];
    else
    end
    idx=contains(SS(i).topclasses,'Thalassiosira');
    if ~isempty(idx)
        temp={'Thalassiosira_chain' 'Thalassiosira_single'};
        SS(i).topclasses=[SS(i).topclasses,temp];
    else
    end
    idx=contains(SS(i).topclasses,'Chaetoceros');
    if ~isempty(idx)
        temp={'Chaetoceros_chain' 'Chaetoceros_single'};
        SS(i).topclasses=[SS(i).topclasses,temp];
    else
    end
    [SS(i).topclasses,idx]=unique(SS(i).topclasses,'stable');
end

save([filepath 'seascape_topclasses'],'SS','class2use');

