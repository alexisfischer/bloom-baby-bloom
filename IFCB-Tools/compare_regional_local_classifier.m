clear;
Mac=1;
nameL1='15Jun2022_UCSC1000';
%nameL2='14Jun2022_UCSC2000';
nameR1='15Jun2022_regional1000';
%nameR2='14Jun2022_regional2000';

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

load([filepath 'performance_classifier_' nameL1],'all'); L=flipud(all); 
%load([filepath 'performance_classifier_' nameL2],'all'); L2=flipud(all);
load([filepath 'performance_classifier_' nameR1],'all'); R=flipud(all);
%load([filepath 'performance_classifier_' nameR2],'all'); R2=flipud(all);
maxn=round(max([R.total]),-2);
[~,class]=get_class_ind( R.class, 'all', basepath);

%find and fill gaps, if they exist
classR=R.class;
classL=L.class;
UCSC2=R;
[~,ib]=ismember(classR,classL);
for i=1:length(ib)
    if ib(i)>0
        UCSC2.total(i)= L.total(ib(i));
        UCSC2.R(i)= L.R(ib(i));
        UCSC2.P(i)= L.P(ib(i));        
        UCSC2.F1(i)= L.F1(ib(i));                
    else
        UCSC2.total(i)=0;
        UCSC2.R(i)=NaN;
        UCSC2.P(i)=NaN;        
        UCSC2.F1(i)=NaN;                
    end
end
clearvars classL classR L i ib Mac all

%%
figure('Units','inches','Position',[1 1 3 6],'PaperPositionMode','auto');

tiledlayout(1,1)
blankY=ones(size(UCSC2.F1));
blankX=ones(1,3);
C1 = [[UCSC2.F1,R.F1,blankY];blankX];
pcolor(nexttile,C1)

set(gca,'ylim',[1 (length(class)+1)],'ytick',1.5:1:length(class)+.5,...
    'yticklabel',class,'xlim',[1 3],'xtick',1.5:1:2.5,'tickdir','out',...
    'xticklabel',{'UCSC-2.0','Regional'},'fontsize',10,'xaxislocation','top');
    xtickangle(30);

    colormap(parula); caxis([0.8 1]);
    h=colorbar('north'); %h.Label.String = label; h.Label.FontSize = 12;               
    hp=get(h,'pos'); 
    hp=[.4*hp(1) 1.08*hp(2) 1.3*hp(3) 0.7*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); 
    h.Label.String = 'F1 score';    
    h.Label.FontSize = 11;  

set(gcf,'color','w');
print(gcf,'-dpng','-r100',[figpath 'pcolor_Regional_vs_Local_classifier_' nameL '.png']);
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