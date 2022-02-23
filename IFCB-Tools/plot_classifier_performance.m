clear;
Mac=0;
name='16Feb2022_nocentric_ungrouped_PN';

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

load([filepath 'performance_classifier_' name],'topfeat','all','opt','c_all','c_opt','NOAA','UCSC','BI');

[~,class]=get_phyto_ind_NOAA(all.class);
    
%% Winner takes All
% plot bar Recall and Precision
% sort by F1
all=sortrows(all,'F1','descend');
[~,C]=get_phyto_ind_NOAA(all.class);

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([all.R all.P],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
set(gca,'ycolor','k', 'xtick', 1:length(C), 'xticklabel', C); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(C),all.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(C), 'xticklabel', C); hold on
legend('Recall', 'Precision','Location','W')
title(['Winner-takes-all: ' num2str(length(C)) ' classes ranked by F1 score'])
xtickangle(45);

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'Fx_recall_precision_' name '.png']);
hold off

%% Winner takes All
%plot manual vs classifier checkerboard
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
cplot = zeros(size(c_all)+1);
cplot(1:length(class),1:length(class)) = c_all;
total=[sum(c_all,2);0];
fx_unclass=sum(c_all(:,end))./sum(total) % what fraction of images went to unclassified?

C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(4,3); col]); 
set(gca, 'ytick', 1:length(class), 'yticklabel', class,...
    'xtick', 1:length(class), 'xticklabel',class)
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

figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
cplot = zeros(size(c_opt)+1);
cplot(1:length(classU),1:length(classU)) = c_opt;
total=[sum(c_opt,2);0];
fx_unclass=sum(c_opt(:,end))./sum(total) % what fraction of images went to unclassified?

C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(4,3); col]); 
set(gca, 'ytick', 1:length(classU), 'yticklabel', classU,...
    'xtick', 1:length(classU), 'xticklabel',classU)
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

%% plot stacked total in set
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
b = bar([NOAA.total BI.total UCSC.total],'stack','Barwidth',.7);
col=brewermap(3,'Dark2'); %col=[[.3 .3 .3];col];
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
    
legend('Shimada','Budd/Lab','UCSC','Location','NW');
set(gca, 'xtick', 1:length(class), 'xticklabel', class,'tickdir','out');
ylabel('total images in set');
xtickangle(45);

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'total_UCSC_NWFSC.png']);
hold off

%%
% %% plot total in set
% figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
% b = bar([all.total SCW.total PNW.total],'Barwidth',1,'linestyle','none');
% col=brewermap(2,'PRGn'); col=[[.3 .3 .3];col];
% for i=1:length(b)
%     set(b(i),'FaceColor',col(i,:));
% end  
%    
% legend('overall','UCSC', 'NWFSC','Location','NE');
% set(gca, 'xtick', 1:length(class),'xticklabel', class);
% ylabel('total images in set');
% 
% set(gcf,'color','w');
% print(gcf,'-dpng','-r200',[figpath 'total_SCW_PNW.png']);
% hold off
% 
% %% plot N CCS bar Recall and Precision
% figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
% yyaxis left;
% b=bar([PNW.Se PNW.Pr],'Barwidth',1,'linestyle','none'); hold on
% set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
% ylabel('Performance');
% col=flipud(brewermap(2,'RdBu')); 
% for i=1:length(b)
%     set(b(i),'FaceColor',col(i,:));
% end  
% yyaxis right;
% plot(1:length(class),PNW.total,'k*'); hold on
% ylabel('total images in set');
% set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
% legend('Recall', 'Precision','Location','NW')
% title('NWFSC')
% set(gcf,'color','w');
% print(gcf,'-dtiff','-r200',[filepath 'Figs/Fx_recall_precision_NWFSC.png']);
% hold off
% 
% %% plot SCW bar Recall and Precision
% figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
% yyaxis left;
% b=bar([SCW.Se SCW.Pr],'Barwidth',1,'linestyle','none'); hold on
% set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
% ylabel('Performance');
% col=flipud(brewermap(2,'RdBu')); 
% for i=1:length(b)
%     set(b(i),'FaceColor',col(i,:));
% end  
% yyaxis right;
% plot(1:length(class),SCW.total,'k*'); hold on
% ylabel('total images in set');
% set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
% legend('Recall', 'Precision','Location','W')
% title('UCSC')
% set(gcf,'color','w');
% print(gcf,'-dtiff','-r200',[filepath 'Figs\Fx_recall_precision_UCSC.png']);
% hold off
    