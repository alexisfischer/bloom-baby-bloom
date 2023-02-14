clear;
Mac=1;
nameL1='CCS_NOAA-OSU_v4';
nameR1='CCS_v6';

if Mac
    basepath = '~/Documents/MATLAB/bloom-baby-bloom/';    
    filepath = [basepath 'IFCB-Data/Shimada/class/'];
    classidx=[basepath 'IFCB-Tools/convert_index_class/class_indices.mat'];
    figpath = [filepath 'Figs/'];
else
    basepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
    filepath = [basepath 'IFCB-Data\Shimada\class\'];
    classidx=[basepath 'IFCB-Tools\convert_index_class\class_indices.mat'];    
    figpath = [filepath 'Figs\'];    
end
addpath(genpath(basepath));

load([filepath 'performance_classifier_' nameL1],'all'); L1i=flipud(all); 
load([filepath 'performance_classifier_' nameR1],'all'); R1=flipud(all);
maxn=round(max([R1.total]),-2);
[~,class]=get_class_ind( R1.class,'all',classidx);

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


%%
figure('Units','inches','Position',[1 1 5 6],'PaperPositionMode','auto');

tiledlayout(1,1)
blankY=ones(size(R1.F1));
blankX=ones(1,3);
C1 = [[L1.F1,R1.F1,blankY];blankX];
pcolor(nexttile,C1)

set(gca,'ylim',[1 (length(class)+1)],'ytick',1.5:1:length(class)+.5,...
    'yticklabel',class,'xlim',[1 3],'xtick',1.5:1:3.5,'tickdir','out',...
    'xticklabel',{'NOAA-OSU','NOAA-OSU-UCSC'},'fontsize',10,'xaxislocation','top');
    xtickangle(30);

    colormap(parula); caxis([0.8 1]);
    h=colorbar('north'); %h.Label.String = label; h.Label.FontSize = 12;               
    hp=get(h,'pos'); 
    hp=[.4*hp(1) 1.08*hp(2) .7*hp(3) 0.7*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); 
    h.Label.String = 'F1 score';    
    h.Label.FontSize = 11;  

    set(gcf,'color','w');
    exportgraphics(gcf,[figpath 'pcolor_CCS_classifier_compare.png'],'Resolution',100)    
hold off

%% plot comparison or Regional vs Local classifier
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');

yyaxis left;
b=bar([L1.F1 R1.F1],'Barwidth',1,'linestyle','none'); hold on
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
hold on;
set(gca,'xlim',[0.5 (length(class)+.5)], 'xtick', 1:length(class), 'ylim',[0 1],...
    'xticklabel', class,'ycolor','k','tickdir','out');
ylabel('F1 score','color','k');

yyaxis right;
plot(.8:1:length(class),L1.total,'k*',1.2:1:length(class)+.2,R1.total,'ks'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class),'ylim',[0 maxn], 'xticklabel', class); hold on
legend('NOAA-OSU', 'NOAA-OSU-UCSC','Location','NorthOutside')
xtickangle(45);
%%
set(gcf,'color','w');
print(gcf,'-dpng','-r100',[figpath 'classifier_compare' nameL '.png']);
hold off
