filepath = '~/MATLAB/bloom-baby-bloom/ACIDD2017/'; 

%%%% Step 1: Load in data
% % 2017 classified data
% [class2useTB,classcountTB,classbiovolTB,ml_analyzedTB,matdate,filelistTB]=...
%     excludeclassbiovolACIDD(...
%     '~/Documents/MATLAB/bloom-baby-bloom/ACIDD2017/Data/IFCB_summary/class/',...
%     'summary_biovol_allTB2017',[1:3,51:56,69:78,85:90,97:98,111:122,147:156]);

% 2018 classified data
load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018'],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

    class2use=class2useTB;
    classbiovol=classbiovolTB;
    classcount=classcountTB;
    ml_analyzed=ml_analyzedTB;
    matdate=mdateTB;
    filelist=filelistTB;
    
clear class2useTB classbiovolTB classcountTB ml_analyzedTB mdateTB filelistTB;

% %% manual classification
% [class2use,classcount,classbiovol,ml_analyzed,matdate,filelist]=...
%     excludebiovolACIDD(...
%     '~/MATLAB/bloom-baby-bloom/ACIDD2017/Data/IFCB_summary/manual/',...
%     'count_biovol_manual_17Dec2018',[1:3,51:56,69:78,85:90,97:98,111:122,147:156]);

%%
%%%% Step 2: Convert Biovolume to Carbon
% convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2use, class2use );
[ cellC ] = biovol2carbon(classbiovol, ind_diatom ); 

%convert from per cell to per mL
volC=zeros(size([cellC]));
volB=zeros(size([cellC]));

for i=1:length(ml_analyzed)
    volC(i,:)=cellC(i,:)./ml_analyzed(i);
    volB(i,:)=classbiovol(i,:)./ml_analyzed(i);    
end
    
%convert from pg/mL to ug/L 
volC=volC./1000;

%%%% Step 3: Determine what fraction of Cell-derived carbon is 
% Dinoflagellates vs Diatoms vs Classes of interest

%select total living biovolume 
[ ind_cell, ~ ] = get_cell_ind_CA( class2use, class2use );
cell=nansum(volC(:,ind_cell),2);

%select only diatoms
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2use, class2use );
diatom=nansum(volC(:,ind_diatom),2);

%select only dinoflagellates
[ ind_dino, ~ ] = get_dino_ind_CA( class2use, class2use );
dino=nansum(volC(:,ind_dino),2);

%select only nanoplankton
[ ind_nano, ~ ] = get_nano_ind_CA( class2use, class2use );
nano=nansum(volC(:,ind_nano),2);

%%
%%%% Step 4: import your cell count data
%General input
in_dir = '~/Documents/MATLAB/bloom-baby-bloom/';
class_sum = 'ACIDD2017/Data/IFCB_summary/class/summary_allTB_bythre_'; 
Thr_sum = 'SCW/Data/IFCB_summary/Coeff_';
biovol_sum = 'ACIDD2017/Data/IFCB_summary/manual/count_biovol_manual_17Dec2018';
remove = [1:3,51:56,69:78,85:90,97:98,111:122,147:156];

class2do_string = 'Chaetoceros';
[CHA]=excludecellcountACIDD(in_dir,class_sum,class2do_string,Thr_sum,biovol_sum,remove);

class2do_string = 'Dinophysis';
[DINO]=excludecellcountACIDD(in_dir,class_sum,class2do_string,Thr_sum,biovol_sum,remove);

class2do_string = 'Gymnodinium';
[GYM]=excludecellcountACIDD(in_dir,class_sum,class2do_string,Thr_sum,biovol_sum,remove);

class2do_string = 'Umbilicosphaera';
[UMB]=excludecellcountACIDD(in_dir,class_sum,class2do_string,Thr_sum,biovol_sum,remove);

class2do_string = 'Lingulodinium';
[LING]=excludecellcountACIDD(in_dir,class_sum,class2do_string,Thr_sum,biovol_sum,remove);

class2do_string = 'Prorocentrum';
[PRO]=excludecellcountACIDD(in_dir,class_sum,class2do_string,Thr_sum,biovol_sum,remove);

class2do_string = 'Centric';
[CEN]=excludecellcountACIDD(in_dir,class_sum,class2do_string,Thr_sum,biovol_sum,remove);

class2do_string = 'Pennate';
[PEN]=excludecellcountACIDD(in_dir,class_sum,class2do_string,Thr_sum,biovol_sum,remove);

clearvars Thr_sum biovol_sum class_sum ind_cell ind_diatom ind_dino ind_nano ...
    class2do_string in_dir classbiovolTB classcountTB filelistTB i remove


%% plot fraction biovolume of select species MANUAL
figure('Units','inches','Position',[1 1 10 10],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.08 0.04], [0.08 0.2]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum(2017,12,17,15,0,0); xax2=datenum(2017,12,22,10,0,0);     

%total cell-derived carbon
subplot(4,1,1);
plot(matdate,cell./ml_analyzed,'k-','linewidth',1);
    hold on
    xlim([xax1 xax2]);
    set(gca,'yscale','log','xgrid','on','ylim',[0 10^3],'xaxislocation','top',...
        'fontsize', 14, 'fontname', 'arial','tickdir','out');
    datetick('x','mmmdd', 'keeplimits')
    ylabel('Carbon (\mug L^{-1})', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    hold on

%Fraction dinos and diatoms and nanoplankton
subplot(4,1,2);
fx_other=(cell-(dino+diatom+nano))./cell; %fraction not dinos or diatoms or nanoplankton
    
col=brewermap(4,'Spectral');

    h=bar(matdate, [nano./cell diatom./cell dino./cell fx_other], 1, 'stack','Edgecolor','none');
    xlim([xax1 xax2]);

    set(h(1),'FaceColor',col(1,:));
    set(h(2),'FaceColor',col(2,:));
    set(h(3),'FaceColor',col(4,:));
    set(h(4),'FaceColor',[200 200 200]/255);
    
    hold on
    datetick('x','mmmdd', 'keeplimits')    
    set(gca,'ylim',[0 1],'fontsize', 14, 'ytick',0.5:0.5:1,...
        'fontname', 'arial','tickdir','out','xticklabel',{});
    ylabel({'Fraction Carbon'}, 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    lh=legend('nanoplankton','diatoms','dinoflagellates','other cell-derived');
set(lh,'Position',[0.802777777786517 0.610950716845878 0.191666666666667 0.0909722222222222]);    
    hold on

% %Fraction select classes
subplot(4,1,3)

select_diat = volC(:,strmatch('Centric',class2use),1);
select_diat=select_diat(:,1);
fx_otherdiat=(diatom-sum(select_diat,2))./cell; %fraction other dinos

select_dino=[volC(:,strmatch('Prorocentrum',class2use)),volC(:,strmatch('Lingulodinium',class2use))];

fx_otherdino=(dino-sum(select_dino,2))./cell; %fraction other dinos

Umbil = volC(:,strmatch('Umbilicosphaera',class2use));

fx_other=(cell-(dino+diatom+nano+Umbil))./cell; %fx not dinos, diatoms, nanoP or umbilicosphaera

h=bar(matdate,[nano./cell select_diat./cell fx_otherdiat select_dino./cell ...
    fx_otherdino Umbil./cell fx_other],1,'stack','Edgecolor','none');

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(5,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGnBu'));
col_diat2=(brewermap(5,'Purples'));

set(h(1),'FaceColor',col(1,:)); %nano
set(h(2),'FaceColor',col_dino2(3,:)); %
set(h(3),'FaceColor',col_dino2(2,:)); 
set(h(4),'FaceColor',col_diat1(6,:)); %pro
set(h(5),'FaceColor',col_diat1(4,:)); %ling
set(h(6),'FaceColor',col_diat1(2,:)); 
set(h(7),'FaceColor',col_diat2(4,:)); %umbil
set(h(8),'FaceColor',[200 200 200]/255);

datetick('x','mmmdd', 'keeplimits')
set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',0.5:0.5:1,...
    'fontsize', 14, 'fontname', 'arial','tickdir','out','xticklabel',{})
ylabel('Fraction Carbon', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
lh=legend('nanoplankton','Centric diatoms','other diatoms',...
    'Prorocentrum','Lingulodinium','other dinos','Umbilicosphaera',...
    'other cell-derived');
set(lh,'Position',[0.801388888897629 0.304700716845878 0.191666666666667 0.198611111111111]);
hold on

%cell counts
subplot(4,1,4); 
h=plot(PRO.mdateTB,PRO.y_mat_manual,'-o',...
    LING.mdateTB,LING.y_mat_manual,'-o',...
    UMB.mdateTB,UMB.y_mat_manual,'-o','linewidth',2,'markersize',3);

set(h(1),'Color',col_diat1(6,:)); %pro
set(h(2),'Color',col_diat1(4,:)); %ling
set(h(3),'Color',col_diat2(4,:)); %umbil

    hold on
    xlim([xax1 xax2]);
    datetick('x','mmmdd', 'keeplimits')
    set(gca,'xgrid','on','fontsize', 14,'ylim',[0 12],'ytick',0:4:12, 'fontname', 'arial','tickdir','out');
    ylabel('Cells mL^{-1}', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    legend('Prorocentrum','Lingulodinum','Umbilicosphaera');  
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/FxBiovolume_ACIDD_manual.tif']);
hold off

%% plot fraction biovolume of select species CLASS
figure('Units','inches','Position',[1 1 10 10],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.08 0.04], [0.08 0.2]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum(2017,12,17,15,0,0); xax2=datenum(2017,12,22,10,0,0);     

%total cell-derived carbon
subplot(4,1,1);
plot(matdate,cell./ml_analyzed,'k-','linewidth',1);
    hold on
    xlim([xax1 xax2]);
    set(gca,'yscale','log','xgrid','on','ylim',[0 10^3],'xaxislocation','top',...
        'fontsize', 14, 'fontname', 'arial','tickdir','out');
    datetick('x','mmmdd', 'keeplimits')
    ylabel('Carbon (\mug L^{-1})', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    hold on

%Fraction dinos and diatoms and nanoplankton
subplot(4,1,2);
fx_other=(cell-(dino+diatom+nano))./cell; %fraction not dinos or diatoms or nanoplankton
    
col=brewermap(4,'Spectral');

    bar(matdate, [nano./cell diatom./cell dino./cell fx_other], 1, 'stack','Edgecolor','none');
    xlim([xax1 xax2]);
    ax = get(gca); cat = ax.Children;
    for ii = 1:length(cat)
        set(cat(ii), 'FaceColor', col(ii,:),'BarWidth',1)
    end
    hold on
    datetick('x','mmmdd', 'keeplimits')    
    set(gca,'ylim',[0 1],'fontsize', 14, 'ytick',0.5:0.5:1,...
        'fontname', 'arial','tickdir','out','xticklabel',{});
    ylabel({'Fraction of biomass'}, 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    lh=legend('nanoplankton','diatoms','dinoflagellates','other cell-derived');
set(lh,'Position',[0.802777777786517 0.610950716845878 0.191666666666667 0.0909722222222222]);    
    hold on

% %Fraction select classes
subplot(4,1,3)

select_diat = [volC(:,strmatch('Centric',class2use)),...
    volC(:,strmatch('Pennate',class2use))];
fx_otherdiat=(diatom-sum(select_diat,2))./cell; %fraction other dinos

select_dino = [...
    volC(:,strmatch('Prorocentrum',class2use)),...
    volC(:,strmatch('Lingulodinium',class2use))];
fx_otherdino=(dino-sum(select_dino,2))./cell; %fraction other dinos

Umbil = volC(:,strmatch('Umbilicosphaera',class2use));

fx_other=(cell-(dino+diatom+nano+Umbil))./cell; %fx not dinos, diatoms, nanoP or umbilicosphaera

h=bar(matdate,[nano./cell select_diat./cell fx_otherdiat select_dino./cell ...
    fx_otherdino Umbil./cell fx_other],1,'stack','Edgecolor','none');

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(5,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGnBu'));
col_diat2=(brewermap(5,'Purples'));

set(h(1),'FaceColor',col_dino1(10,:)); %aka
set(h(2),'FaceColor',col_dino1(9,:)); %cer
set(h(3),'FaceColor',col_dino2(4,:)); %gm
set(h(4),'FaceColor',col_dino2(2,:)); %pro
set(h(5),'FaceColor',col_diat1(6,:)); %chae
set(h(6),'FaceColor',col_diat1(5,:)); %DCL
set(h(7),'FaceColor',col_diat1(4,:)); %Euc
set(h(8),'FaceColor',col_diat2(5,:)); %Cen
%set(h(9),'FaceColor',col_diat2(4,:)); %Pen

datetick('x','mmmdd', 'keeplimits')
set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',0.5:0.5:1,...
    'fontsize', 14, 'fontname', 'arial','tickdir','out','xticklabel',{})
ylabel('Fraction Biomass', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
lh=legend('nanoplankton','Centric diatoms','Pennate diatoms','other diatoms',...
    'Prorocentrum','Lingulodinium','other dinos','Umbilicosphaera',...
    'other cell-derived');
set(lh,'Position',[0.801388888897629 0.304700716845878 0.191666666666667 0.198611111111111]);
hold on

%cell counts
subplot(4,1,4); 
h=plot(PRO.mdateTB,PRO.y_mat,'-o',LING.mdateTB,LING.y_mat,'-o',...
    UMB.mdateTB,UMB.y_mat,'-o',CHA.mdateTB,CHA.y_mat,'-o',...
    'linewidth',1.5,'markersize',2);

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(4,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGnBu'));
col_diat2=(brewermap(5,'Purples'));

set(h(1),'Color',col_dino1(10,:)); 
set(h(2),'Color',col_dino1(8,:)); 
set(h(3),'Color',col_dino2(4,:)); 
set(h(4),'Color',col_diat1(6,:)); 

    hold on
    xlim([xax1 xax2]);
    datetick('x','mmmdd', 'keeplimits')
    set(gca,'xgrid','on','fontsize', 14, 'fontname', 'arial','tickdir','out');
    ylabel('Cells mL^{-1}', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    lh=legend('Prorocentrum','Lingulodinum','Umbilicosphaera','Chaeotoceros');  
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/FxBiovolume_ACIDD_class.tif']);
hold off

%% plot 2018 fraction biovolume of select species CLASS
figure('Units','inches','Position',[1 1 10 7],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.08 0.04], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum(2018,12,12,21,0,0); xax2=datenum(2018,12,12,24,0,0);     

%Fraction dinos and diatoms and nanoplankton
subplot(3,1,1);
fx_other=(cell-(dino+diatom+nano))./cell; %fraction not dinos or diatoms or nanoplankton
col=brewermap(4,'Spectral');

    h=bar(matdate, [nano./cell diatom./cell dino./cell fx_other], 1, 'stack','Edgecolor','none');
    xlim([xax1 xax2]);
    set(h(1),'FaceColor',col(1,:));
    set(h(2),'FaceColor',col(2,:));
    set(h(3),'FaceColor',col(4,:));
    set(h(4),'FaceColor',[200 200 200]/255);
    hold on
    datetick('x','mmmdd', 'keeplimits')    
    set(gca,'ylim',[0 1],'fontsize', 14, 'ytick',0.25:0.25:1,...
        'fontname', 'arial','tickdir','out','xticklabel',{});
    ylabel({'Fraction of sample'}, 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    legend('nanoplankton','diatoms','dinoflagellates','other (living & nonliving)','Location','EastOutside');
    hold on
    
% %Fraction select classes
subplot(3,1,2)

select_diat = [volC(:,strmatch('Centric',class2use)),...
    volC(:,strmatch('Pennate',class2use))];
fx_otherdiat=(diatom-sum(select_diat,2))./cell; %fraction other dinos

select_dino = [...
    volC(:,strmatch('Prorocentrum',class2use)),...
    volC(:,strmatch('Lingulodinium',class2use))];
fx_otherdino=(dino-sum(select_dino,2))./cell; %fraction other dinos

Umbil = volC(:,strmatch('Umbilicosphaera',class2use));

fx_other=(cell-(dino+diatom+nano+Umbil))./cell; %fx not dinos, diatoms, nanoP or umbilicosphaera

h=bar(matdate,[nano./cell select_diat./cell fx_otherdiat select_dino./cell ...
    fx_otherdino ],1,'stack','Edgecolor','none');

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(5,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGnBu'));
col_diat2=(brewermap(5,'Purples'));

set(h(1),'FaceColor',col_dino1(10,:)); 
set(h(2),'FaceColor',col_dino1(9,:)); 
set(h(3),'FaceColor',col_dino2(4,:)); 
set(h(4),'FaceColor',col_dino2(2,:)); 
set(h(5),'FaceColor',col_diat1(6,:)); 
set(h(6),'FaceColor',col_diat1(5,:));
set(h(7),'FaceColor',col_diat1(4,:)); 
%set(h(8),'FaceColor',col_diat2(5,:)); 
%set(h(9),'FaceColor',col_diat2(4,:));

datetick('x','mmmdd', 'keeplimits')
set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',0.5:0.5:1,...
    'fontsize', 14, 'fontname', 'arial','tickdir','out','xticklabel',{})
ylabel('Fraction Biomass', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
lh=legend('nanoplankton','Centric diatoms','Pennate diatoms','other diatoms',...
    'Prorocentrum','Lingulodinium','other dinos','Umbilicosphaera',...
    'other cell-derived','Location','EastOutside');
hold on

%cell counts
subplot(3,1,3); 

AST=classcount(:,4); %Asterionellopsis

PRO=classcount(:,33);
LING=classcountTB_above_optthresh(176:182,27);
CHA=classcountTB_above_optthresh(176:182,8);

h=plot(mdateTB(176:182),[PRO,'-o',LING,'-o',CHA,'-o'],'linewidth',1.5,'markersize',2);

col_dino1=flipud(brewermap(10,'PiYG'));
col_dino2=(brewermap(4,'YlOrBr'));
col_diat1=flipud(brewermap(7,'YlGnBu'));
col_diat2=(brewermap(5,'Purples'));

set(h(1),'Color',col_dino1(10,:)); 
set(h(2),'Color',col_dino1(8,:)); 
set(h(3),'Color',col_dino2(4,:)); 
set(h(4),'Color',col_diat1(6,:)); 

    hold on
    xlim([xax1 xax2]);
    datetick('x','mmmdd', 'keeplimits')
    set(gca,'xgrid','on','fontsize', 14, 'fontname', 'arial','tickdir','out');
    ylabel('Cells mL^{-1}', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
    lh=legend('Prorocentrum','Lingulodinum','Umbilicosphaera','Chaeotoceros');  
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/FxBiovolume_ACIDD_class_2018.tif']);
hold off



