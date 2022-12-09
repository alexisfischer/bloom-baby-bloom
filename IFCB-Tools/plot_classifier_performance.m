clear;
Mac=1;
name='BI_Dinophysis_GenusLevel_v5';
%name='BI_Dinophysis_SpeciesLevel';

if Mac
    basepath = '~/Documents/MATLAB/bloom-baby-bloom/';    
    filepath = [basepath 'IFCB-Data/BuddInlet/class/'];
    figpath = [filepath 'Figs/'];
else
    basepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
    filepath = [basepath 'IFCB-Data\BuddInlet\class\'];
    figpath = [filepath 'Figs\'];    
end
addpath(genpath(basepath));

load([filepath 'performance_classifier_' name],'topfeat','all','opt','c_all','c_opt','NOAA','UCSC','OSU');
maxn=round(max([all.total]),-2);
[~,class]=get_class_ind( all.class, 'all', basepath);

%% plot stacked total in set and F1 score comparison
% figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
% subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.26 0.15], [0.08 0.04]);
% %subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
% %where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
% 
% subplot(2,1,1)
% b=bar([NOAA.F1 UCSC.F1 OSU.F1 all.F1],'Barwidth',1,'linestyle','none'); hold on
% col=[brewermap(3,'Set2');[.1 .1 .1]]; 
% for i=1:4
%     set(b(i),'FaceColor',col(i,:));
% end  
% set(gca,'xlim',[0.5 (length(class)+.5)],'ycolor','k', 'xtick', 1:length(class), 'xticklabel', [],'tickdir','out'); hold on
% ylabel('F1 score');
% lh=legend('NWFSC','UCSC','OSU','all','Location','North');
%     legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
%     lh.Position=[hp(1) hp(2)+.16 hp(3) hp(4)]; hold on    
%  

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
col=[(brewermap(3,'Set2'));[.1 .1 .1]]; 
b = bar([NOAA.total UCSC.total OSU.total],'stack','linestyle','none','Barwidth',.7);
for i=1:3
    set(b(i),'FaceColor',col(i,:));
end  
set(gca,'xlim',[0.5 (length(class)+.5)], 'xtick', 1:length(class), 'ylim',[0 maxn],...
    'xticklabel', class,'tickdir','out');
ylabel('total images in set'); hold on
xtickangle(45);
lh=legend('NWFSC','UCSC','OSU','Location','NorthOutside');

set(gcf,'color','w');
print(gcf,'-dpng','-r100',[figpath 'TrainingSet_UCSC_OSU_CCS' name '.png']);
hold off

%% F1 scores
% plot bar Recall and Precision
% sort by F1
[all,ia]=sortrows(all,'F1','descend');
UCSC=UCSC(ia,:);
OSU=OSU(ia,:);
NOAA=NOAA(ia,:);
[~,class_s]=get_class_ind( all.class, 'all', basepath);

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([all.R all.P],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
set(gca,'ycolor','k', 'xtick', 1:length(class_s), 'xticklabel', class_s); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class_s),all.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 maxn], 'xticklabel', class_s); hold on
legend('Recall', 'Precision','Location','W')
title(['All CCS - Winner-takes-all: ' num2str(length(class)) ' classes ranked by F1 score'])
xtickangle(45);

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'F1score_UCSC_OSU_CCS_' name '.png']);
hold off

%% Winner takes All
%plot manual vs classifier checkerboard
figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
cplot = zeros(size(c_all)+1);
cplot(1:length(class),1:length(class)) = c_all;
total=[sum(c_all,2);0];
fx_unclass=sum(c_all(:,end))./sum(total)   % what fraction of images went to unclassified?

C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(1,3); col]); 
set(gca,'ylim',[1 length(class)],'xlim',[1 length(class)],...
    'ytick',1:1:length(class), 'yticklabel', class,...
    'xtick',1:1:length(class), 'xticklabel',class)

axis square;  col=colorbar; caxis([0 1])
colorTitleHandle = get(col,'Title');
titleString = {'Fx of test'; 'images/class'};
set(colorTitleHandle ,'String',titleString);

ylabel('Actual Classifications','fontweight','bold');
xlabel('Predicted Classifications','fontweight','bold')
title('Winner-takes-all');

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'confusion_matrix_all_' name '.png']);
hold off

%% plot opt manual vs classifier checkerboard with unclassified
classU=class;
classU{end+1}='unclassified';

figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
cplot = zeros(size(c_opt)+1);
cplot(1:length(classU),1:length(classU)) = c_opt;
total=[sum(c_opt,2);0];
fx_unclass=sum(c_opt(:,end))./sum(total) % what fraction of images went to unclassified?

C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(4,3); col]); 
set(gca,'ylim',[1 length(classU)],'xlim',[1 length(classU)],...
    'ytick', 1:1:length(classU), 'yticklabel', classU,...
    'xtick', 1:1:length(classU), 'xticklabel',classU)
axis square;  col=colorbar; caxis([0 1])
colorTitleHandle = get(col,'Title');
titleString = {'Fx of test'; 'images/class'};
set(colorTitleHandle ,'String',titleString);

ylabel('Actual Classifications','fontweight','bold');
xlabel('Predicted Classifications','fontweight','bold')
title('Optimal score threshold');

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'confusion_matrix_opt_' name '.png']);
hold off

