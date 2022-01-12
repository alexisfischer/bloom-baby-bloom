%% Plot biomass composition from classifier
clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
filepath = '/Users/afischer/MATLAB/';
s19=load([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/class/summary_biovol_allTB2019']);
s21=load([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/class/summary_biovol_allTB2021']);

fprint=0;

%%%% set class names
class2useTB=s19.class2useTB;
id=strcmp(class2useTB,'D_acuminata,D_acuta,D_caudata,D_fortii,D_norvegica,D_odiosa,D_parva,D_rotundata,D_tripos,Dinophysis');
class2useTB{id}='Dinophysis';
id=find(strcmp(class2useTB,'Pn_large_narrow,Pn_large_wide'));
class2useTB{id}='Pn_large';

%%%% merge datasets
classcountTB=[s19.classcountTB;s21.classcountTB];
%classbiovolTB=[s19.classbiovolTB_above_optthresh;s21.classbiovolTB_above_optthresh];
classbiovolTB=[s19.classbiovolTB;s21.classbiovolTB];
ml_analyzedTB=[s19.ml_analyzedTB;s21.ml_analyzedTB];
mdateTB=[s19.mdateTB;s21.mdateTB];

%%%% find fx biomass unclassified
total_ind=sum(classbiovolTB,1);
total=sum(total_ind);
unclassifed=total_ind(strcmp(class2useTB,'unclassified'));
fx_un=unclassifed./total;
clearvars s19 s21;

%%%% Convert Biovolume (cubic microns/cell) to ug carbon/ml
ind_diatom = get_diatom_ind_PNW(class2useTB);
[pgCcell] = biovol2carbon(classbiovolTB,ind_diatom); 
ugCml=NaN*pgCcell;
for i=1:length(pgCcell)
    ugCml(i,:)=.001*(pgCcell(i,:)./ml_analyzedTB(i)); %convert from pg/cell to pg/mL to ug/L 
end  

%%%% Find fraction of each group
[ind_dino,label_dino] = get_dino_ind_PNW(class2useTB); 
[ind_diatom,label_diatom] = get_diatom_ind_PNW(class2useTB); 
[ind_nano,label_nano] = get_nano_ind_PNW(class2useTB);
[ind_otherphyto,label_otherphyto] = get_otherphyto_ind_PNW(class2useTB);
[ind_phyto,~] = get_phyto_ind_PNW(class2useTB); 

dino = (ugCml(:,ind_dino));
diat = (ugCml(:,ind_diatom));
nano = (ugCml(:,ind_nano));
otherphyto = (ugCml(:,ind_otherphyto));
phytoTotal = sum(ugCml(:,ind_phyto),2);

fx_dino=dino./phytoTotal;
fx_diat=diat./phytoTotal;
fx_nano=nano./phytoTotal; 
fx_otherphyto=otherphyto./phytoTotal;

% plot
figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.06 0.04], [0.08 0.3]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1); %2019
xax1=datenum('2019-06-28'); xax2=datenum('2019-10-01'); %USER enter plot time interval
h = bar(mdateTB,[fx_dino fx_diat fx_otherphyto fx_nano],'stack','Barwidth',4);
c=brewermap(length(class2useTB)-2,'Spectral');
%    col=[c(1:9,:);c(12:23,:);[.8 .8 .8];[.1 .1 .1]];
    col=[c;[.8 .8 .8];[.1 .1 .1]];
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end      
    ylabel('2019 Fx total Carbon','fontsize',12);
    datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'},'xticklabel',{});    
    
    lh=legend([label_dino;label_diatom;label_otherphyto;label_nano]);
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[1.7*hp(1) .02*hp(2) hp(3) hp(4)]; hold on    
        
subplot(2,1,2);
xax1=datenum('2021-06-28'); xax2=datenum('2021-10-01'); %USER enter plot time interval
h = bar(mdateTB,[fx_dino fx_diat fx_otherphyto fx_nano],'stack','Barwidth',4);
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
    print(gcf,'-dtiff','-r300',[filepath 'NOAA/Shimada/Figs/FxCarbonBiomass_Shimada_class_2019-2021_unclass.tif']);
    hold off
end
