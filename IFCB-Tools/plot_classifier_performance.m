%function [ ] = plot_classifier_performance( classifiername )
%plot classifier performance
clear;
%filepath = '~/MATLAB/bloom-baby-bloom/IFCB-Data/Shimada/class/';
filepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\';
addpath(genpath(filepath));

load([filepath 'performance_classifier_30Dec2021'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');
text_offset = 0.1;
maxn=5000;

% %% plot stacked total in set
% figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
% b = bar([SCW.total PNW.total],'stack','Barwidth',1);
% col=brewermap(2,'PRGn'); %col=[[.3 .3 .3];col];
% for i=1:length(b)
%     set(b(i),'FaceColor',col(i,:));
% end  
%     
% legend('UCSC','NWFSC','Location','NE');
% set(gca, 'xtick', 1:length(all.class), 'xticklabel', []);
% ylabel('total images in set');
% text(1:length(all.class), -text_offset.*ones(size(all.class)), all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
% set(gca, 'position', [ 0.13 0.35 0.8 0.6])
% set(gcf,'color','w');
% print(gcf,'-dpng','-r200',[filepath 'Figs\total_UCSC_NWFSC.png']);
% hold off
% 
% %% plot total in set
% figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
% b = bar([all.total SCW.total PNW.total],'Barwidth',1,'linestyle','none');
% col=brewermap(2,'PRGn'); col=[[.3 .3 .3];col];
% for i=1:length(b)
%     set(b(i),'FaceColor',col(i,:));
% end  
%    
% legend('overall','UCSC', 'NWFSC','Location','NE');
% set(gca, 'xtick', 1:length(all.class), 'xticklabel', []);
% ylabel('total images in set');
% text(1:length(all.class), -text_offset.*ones(size(all.class)), all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
% set(gca, 'position', [ 0.13 0.35 0.8 0.6])
% set(gcf,'color','w');
% print(gcf,'-dpng','-r200',[filepath 'Figs\total_SCW_PNW.png']);
% hold off
    
%% plot ALL bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 4.5],'PaperPositionMode','auto');
yyaxis left;
b=bar([all.Se all.Pr],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
set(gca,'ycolor','k', 'xtick', 1:length(all.class), 'xticklabel', []); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(all.class),all.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(all.class), 'xticklabel', []); hold on
text(1:length(all.class), -text_offset.*ones(size(all.class)), all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.75 0.6])
legend('Sensitivity', 'Precision','Location','W')
title('NWFSC + UCSC')

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'Figs\Fx_sensitivity_precision_noUnidDino.png']);
hold off
% 
% %% plot N CCS bar Sensitivity and Precision
% figure('Units','inches','Position',[1 1 6 4.5],'PaperPositionMode','auto');
% yyaxis left;
% b=bar([PNW.Se PNW.Pr],'Barwidth',1,'linestyle','none'); hold on
% set(gca,'ycolor','k', 'xtick', 1:length(PNW.class), 'xticklabel', []); hold on
% ylabel('Performance');
% col=flipud(brewermap(2,'RdBu')); 
% for i=1:length(b)
%     set(b(i),'FaceColor',col(i,:));
% end  
% yyaxis right;
% plot(1:length(PNW.class),PNW.total,'k*'); hold on
% ylabel('total images in set');
% set(gca,'ycolor','k', 'xtick', 1:length(PNW.class), 'xticklabel', []); hold on
% text(1:length(PNW.class), -text_offset.*ones(size(PNW.class)), PNW.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
% set(gca, 'position', [ 0.13 0.35 0.75 0.6])
% legend('Sensitivity', 'Precision','Location','NW')
% title('NWFSC')
% set(gcf,'color','w');
% print(gcf,'-dtiff','-r200',[filepath 'Figs/Fx_sensitivity_precision_NWFSC.png']);
% hold off
% 
% %% plot SCW bar Sensitivity and Precision
% figure('Units','inches','Position',[1 1 6 4.5],'PaperPositionMode','auto');
% yyaxis left;
% b=bar([SCW.Se SCW.Pr],'Barwidth',1,'linestyle','none'); hold on
% set(gca,'ycolor','k', 'xtick', 1:length(SCW.class), 'xticklabel', []); hold on
% ylabel('Performance');
% col=flipud(brewermap(2,'RdBu')); 
% for i=1:length(b)
%     set(b(i),'FaceColor',col(i,:));
% end  
% yyaxis right;
% plot(1:length(SCW.class),SCW.total,'k*'); hold on
% ylabel('total images in set');
% set(gca,'ycolor','k', 'xtick', 1:length(SCW.class), 'xticklabel', []); hold on
% text(1:length(SCW.class), -text_offset.*ones(size(SCW.class)), SCW.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
% set(gca, 'position', [ 0.13 0.35 0.75 0.6])
% legend('Sensitivity', 'Precision','Location','W')
% title('UCSC')
% set(gcf,'color','w');
% print(gcf,'-dtiff','-r200',[filepath 'Figs\Fx_sensitivity_precision_UCSC.png']);
% hold off
% 
% %% plot manual vs classifier checkerboard
% figure('Units','inches','Position',[1 1 7 5],'PaperPositionMode','auto');
% cplot = zeros(size(c_all)+1);
% cplot(1:length(all.class),1:length(all.class)) = c_all;
% pcolor(cplot)
% set(gca, 'ytick', 1:length(all.class), 'yticklabel', [])
% text( -text_offset+ones(size(all.class)),(1:length(all.class))+.5, all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 0)
% set(gca, 'xtick', 1:length(all.class), 'xticklabel', [])
% text((1:length(all.class))+.5, -text_offset+ones(size(all.class)), all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
% axis square, colorbar, caxis([0 maxn])
% title('manual vs. classifier; score threshold = 0')
% %
% set(gcf,'color','w');
% print(gcf,'-dtiff','-r200',[filepath 'Figs\checkerboard_manual_vs_classifier.png']);
% hold off
    