% Use MC files to find who is representing the biomass to determine which classes should be used in classifier
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

filepath = '/Users/afischer/MATLAB/';

load([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/manual/class_eqdiam_biovol_manual_2019'])

% concatenate biovolume for each class in each sample
volB=NaN*ones(length(BiEq),length(class2use_manual)); %preset biovolume matrix
volC=(volB); %preset carbon matrix
ind_diatom = get_diatom_ind_PNW(class2use_manual);
for i=1:length(class2use_manual)
    for j=1:length(BiEq)
        idx=find([BiEq(j).class]==i); %find indices of a particular class
        b=nansum(BiEq(j).biovol(idx)); %match and sum biovolume
        volB(j,i)=b./BiEq(j).ml_analyzed; %convert to um^3/mL
    end
end

% convert from biovolume to carbon
for i=1:length(volB)    
    volC(i,:)=biovol2carbon(volB(i,:),ind_diatom)./1000; %convert from pg/cell to ug/L 
end

% Exclude nonliving and zooplankton
idx=get_nonliving_ind_PNW(class2use_manual); volC(:,idx)=NaN;
idx=get_zoop_ind_PNW(class2use_manual); volC(:,idx)=NaN;

clearvars i j idx b note1 note2 ind_diatom volB

% find highest biomass cells
sampletotal=repmat(nansum(volC,2),1,size(volC,2));
fxC_all=volC./sampletotal;
classtotal=nansum(volC,1);
[~,idx]=maxk(classtotal,45); %find top carbon highest classes
fxC=fxC_all(:,idx);
class=class2use_manual(idx);
label=class;
%[~,label] = get_all_ind_PNW(class);   

% % find files with >70% of biomass classified
% un=1-volC(:,1)./sampletotal(:,1); 
% filename={BiEq.filename}';
% idx=(un>.7)
% filename_unclassified=filename(idx);

clearvars fxC_all sampletotal classtotal un filename BiEq idx;

TopClasses=(sort(class))';

save([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/manual/TopClasses'],'TopClasses');

%%
figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.1 0.04], [0.08 0.25]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

mdate=[BiEq.matdate]';
xax1=datenum('2019-07-20'); xax2=datenum('2019-08-20');     

subplot(2,1,1);
h = bar(mdate,fxC,'stack','Barwidth',4);
    ylabel('Fx total C','fontsize',12);
    datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'},'xticklabel',{});    
    col=brewermap(length(label),'Spectral'); col(1,:)=[.8 .8 .8];
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end   
    lh=legend(label,'location','EastOutside'); lh.Title.String={'Classes in';'order of biomass'};
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
%    lh.Position=[hp(1)+.25 hp(2)+.04 hp(3) hp(4)]; hold on    
    lh.Position=[hp(1)+.25 hp(2)+.04 hp(3) hp(4)]; hold on    
 
subplot(2,1,2);
    % exlude unclassified
    idx=get_unclassified_ind_PNW(class2use_manual); volC(:,idx)=NaN;    
    sampletotal=repmat(nansum(volC,2),1,size(volC,2));
    fxC_all=volC./sampletotal;

    classtotal=nansum(volC,1);
    [~,idx]=maxk(classtotal,28); %find top carbon highest classes
    fxC=fxC_all(:,idx);
        
h = bar(mdate,fxC,'stack','Barwidth',10);
    ylabel('Fx total C (excluding unclassified)','fontsize',12);
    datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'});    
    col(1,:)=[];
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end   
%%
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'NOAA/Shimada/Figs/FxCarbonBiomass_Shimada.tif']);
hold off