clear;
Mac=1;
nameL1='15Jun2022_UCSC1000';
nameL2='14Jun2022_UCSC2000';
nameR1='16Jun2022_regional1000';
nameR2='14Jun2022_regional2000';

if Mac
    basepath = '~/Documents/MATLAB/bloom-baby-bloom/';    
    filepath = [basepath 'IFCB-Data/Shimada/class/'];
    figpath = [filepath 'Figs/'];
else
    basepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
    filepath = [basepath 'IFCB-Data\Shimada\class\'];
    figpath = [filepath 'Figs\'];    
end
addpath(genpath(basepath));

load([filepath 'performance_classifier_' nameL1],'all'); L1i=flipud(all); 
load([filepath 'performance_classifier_' nameL2],'all'); L2i=flipud(all);
load([filepath 'performance_classifier_' nameR1],'all'); R1=flipud(all);
load([filepath 'performance_classifier_' nameR2],'all'); R2i=flipud(all);
maxn=round(max([R1.total]),-2);
[~,class]=get_class_ind( R1.class, 'all', basepath);

%% find and fill gaps, if they exist
L1=R1;
[~,ib]=ismember(R1.class,L1i.class);
for i=1:length(ib)
    if ib(i)>0
        L1.total(i)= L1i.total(ib(i));
        L1.R(i)= L1i.R(ib(i));
        L1.P(i)= L1i.P(ib(i));        
        L1.F1(i)= L1i.F1(ib(i));                
    else
        L1.total(i)=0;
        L1.R(i)=NaN;
        L1.P(i)=NaN;        
        L1.F1(i)=NaN;                
    end
end

L2=R1;
[~,ib]=ismember(R1.class,L2i.class);
for i=1:length(ib)
    if ib(i)>0
        L2.total(i)= L2i.total(ib(i));
        L2.R(i)= L2i.R(ib(i));
        L2.P(i)= L2i.P(ib(i));        
        L2.F1(i)= L2i.F1(ib(i));                
    else
        L2.total(i)=0;
        L2.R(i)=NaN;
        L2.P(i)=NaN;        
        L2.F1(i)=NaN;                
    end
end

R2=R1;
[~,ib]=ismember(R1.class,R2i.class);
for i=1:length(ib)
    if ib(i)>0
        R2.total(i)= R2i.total(ib(i));
        R2.R(i)= R2i.R(ib(i));
        R2.P(i)= R2i.P(ib(i));        
        R2.F1(i)= R2i.F1(ib(i));                
    else
        R2.total(i)=0;
        R2.R(i)=NaN;
        R2.P(i)=NaN;        
        R2.F1(i)=NaN;                
    end
end

clearvars classL classR L i ib Mac all L1i L2i R2i

%%
figure('Units','inches','Position',[1 1 4 6],'PaperPositionMode','auto');

tiledlayout(1,1)
blankY=ones(size(R1.F1));
blankX=ones(1,5);
C1 = [[L1.F1,L2.F1,R1.F1,R2.F1,blankY];blankX];
pcolor(nexttile,C1)

set(gca,'ylim',[1 (length(class)+1)],'ytick',1.5:1:length(class)+.5,...
    'yticklabel',class,'xlim',[1 5],'xtick',1.5:1:4.5,'tickdir','out',...
    'xticklabel',{'UCSC2.0-1000','UCSC2.0-2000','Regional-1000','Regional-2000'},'fontsize',10,'xaxislocation','top');
    xtickangle(30);

    colormap(parula); caxis([0.8 1]);
    h=colorbar('north'); %h.Label.String = label; h.Label.FontSize = 12;               
    hp=get(h,'pos'); 
    hp=[.4*hp(1) 1.08*hp(2) .7*hp(3) 0.7*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); 
    h.Label.String = 'F1 score';    
    h.Label.FontSize = 11;  

set(gcf,'color','w');
print(gcf,'-dpng','-r100',[figpath 'pcolor_all_classifiers_against_trainingset.png']);

%print(gcf,'-dpng','-r100',[figpath 'pcolor_Regional_vs_Local_classifier_' nameL '.png']);
hold off

%% plot comparison or Regional vs Local classifier
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');

yyaxis left;
b=bar([R.F1 UCSC2.F1],'Barwidth',1,'linestyle','none'); hold on
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
hold on;
set(gca,'xlim',[0.5 (length(class)+.5)], 'xtick', 1:length(class), 'ylim',[0 1],...
    'xticklabel', class,'ycolor','k','tickdir','out');
ylabel('F1 score','color','k');

yyaxis right;
plot(.8:1:length(class),R.total,'k*',1.2:1:length(class)+.2,UCSC2.total,'ks'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class),'ylim',[0 maxn], 'xticklabel', class); hold on
legend('regional', 'UCSC2','Location','NorthOutside')
xtickangle(45);
 
set(gcf,'color','w');
print(gcf,'-dpng','-r100',[figpath 'Regional_vs_Local_classifier' nameL '.png']);
hold off
