%% Plot biomass composition from classifier
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path
s19=load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB2019']);
s21=load([filepath 'IFCB-Data/Shimada/class/summary_biovol_allTB2021']);

fprint=1;
un=1;
class2useTB=s19.class2useTB;

%%%% merge datasets
classbiovolTB=[s19.classbiovolTB;s21.classbiovolTB];
ml_analyzedTB=[s19.ml_analyzedTB;s21.ml_analyzedTB];
mdateTB=[s19.mdateTB;s21.mdateTB];

un_ind=strcmp(class2useTB,'unclassified');
if un==1 
    classbiovolTB=[s19.classbiovolTB_above_optthresh;s21.classbiovolTB_above_optthresh];
    total_ind=sum(classbiovolTB./ml_analyzedTB,1);
    total=sum(total_ind);
    unclassifed=total_ind(un_ind);
    fx_un=unclassifed./total; % find fx biomass unclassified
    col=[brewermap(length(class2useTB)-1,'Spectral');[.8 .8 .8]];        
else
    classbiovolTB(:,un_ind)=[];
    class2useTB(un_ind)=[];
    col=brewermap(length(class2useTB),'Spectral');
    
end
clearvars s19 s21;

%%%% Convert Biovolume (cubic microns/cell) to ug carbon/ml
ind_diatom = get_diatom_ind_PNW(class2useTB);
[pgCcell] = biovol2carbon(classbiovolTB,ind_diatom); 
ugCml=NaN*pgCcell;
for i=1:length(pgCcell)
    ugCml(i,:)=.001*(pgCcell(i,:)./ml_analyzedTB(i)); %convert from pg/cell to pg/mL to ug/L 
end  

%%%% Find fraction of each group
[ind_phyto,label] = get_phyto_ind_PNW(class2useTB); 
phytoTotal = sum(ugCml(:,ind_phyto),2);
classfx = ugCml(:,ind_phyto)./phytoTotal;

%%%% organize
[i_dino,label_dino] = get_dino_ind_PNW(class2useTB); 
[i_diat,label_diatom] = get_diatom_ind_PNW(class2useTB); 
i_other=setdiff(ind_phyto,[i_dino;i_diat]);

% plot
figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.06 0.04], [0.08 0.27]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1); %2019
xax1=datenum('2019-06-28'); xax2=datenum('2019-10-01'); %USER enter plot time interval
h = bar(mdateTB,[classfx(:,i_dino) classfx(:,i_diat) classfx(:,i_other)],'stack','Barwidth',4);

    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end      
    ylabel('2019 Fx total Carbon','fontsize',12);
    datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'},'xticklabel',{});    
    
    lh=legend(label([i_dino;i_diat;i_other]));
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[1.6*hp(1) hp(2) hp(3) hp(4)]; hold on    
        
subplot(2,1,2);
xax1=datenum('2021-06-28'); xax2=datenum('2021-10-01'); %USER enter plot time interval
h = bar(mdateTB,[classfx(:,i_dino) classfx(:,i_diat) classfx(:,i_other)],'stack','Barwidth',4);
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end  
    ylabel('2021 Fx total Carbon','fontsize',12);
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'});    
    datetick('x', 'mm/dd', 'keeplimits');    

if fprint
    set(gcf,'color','w');
    if un
    print(gcf,'-dtiff','-r300',[filepath 'NOAA/Shimada/Figs/FxCarbonBiomass_Shimada_class_2019-2021_above_optthresh.tif']);
    else
    print(gcf,'-dtiff','-r300',[filepath 'NOAA/Shimada/Figs/FxCarbonBiomass_Shimada_class_2019-2021.tif']);        
    end
    hold off
end
