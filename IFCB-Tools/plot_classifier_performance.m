%plot classifier performance
clear;
filepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\';
load([filepath 'performance_classifier_12Oct2021'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');

text_offset = 0.1;

%% plot bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([PNW.Se PNW.Pr])
set(gca, 'xtick', 1:length(PNW.class), 'xticklabel', [])
text(1:length(PNW.class), -text_offset.*ones(size(PNW.class)), PNW.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
legend('Sensitivity', 'Precision','Location','SE')
title('score threshold = 0')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Fx_sensitivity_precision_PNW.png']);
hold off

%% plot bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([SCW.Se SCW.Pr])
set(gca, 'xtick', 1:length(SCW.class), 'xticklabel', [])
text(1:length(SCW.class), -text_offset.*ones(size(SCW.class)), SCW.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
legend('Sensitivity', 'Precision','Location','SE')
title('score threshold = 0')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Fx_sensitivity_precision_SCW.png']);
hold off

%% plot total in set
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([all.total SCW.total PNW.total])
legend('overall', 'SCW', 'N CCS','Location','NE');
set(gca, 'xtick', 1:length(all.class), 'xticklabel', []);
ylabel('total images in set');
text(1:length(all.class), -text_offset.*ones(size(all.class)), all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\total_SCW_PNW.png']);
hold off
    
%% plot bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([all.Se all.Pr])
set(gca, 'xtick', 1:length(all.class), 'xticklabel', [])
text(1:length(all.class), -text_offset.*ones(size(all.class)), all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
legend('Sensitivity', 'Precision','Location','SE')
title('score threshold = 0')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Fx_sensitivity_precision.png']);
hold off

%% plot manual vs classifier checkerboard
figure('Units','inches','Position',[1 1 7 5],'PaperPositionMode','auto');
cplot = zeros(size(c_all)+1);
cplot(1:length(all.class),1:length(all.class)) = c_all;
pcolor(cplot)
set(gca, 'ytick', 1:length(all.class), 'yticklabel', [])
text( -text_offset+ones(size(all.class)),(1:length(all.class))+.5, all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 0)
set(gca, 'xtick', 1:length(all.class), 'xticklabel', [])
text((1:length(all.class))+.5, -text_offset+ones(size(all.class)), all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
axis square, colorbar, caxis([0 maxn])
title('manual vs. classifier; score threshold = 0')
%
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\checkerboard_manual_vs_classifier.png']);
hold off

%% plot bar Sensitivity and Precision (optimal)
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([opt.Se opt.Pr opt.Pm])
title('optimal score threshold')
set(gca, 'xtick', 1:length(opt.class), 'xticklabel', [])
text(1:length(opt.class), -text_offset.*ones(size(opt.class)), opt.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45)
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
legend('Se', 'Pr', 'Pmissed')
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Fx_sensitivity_precision_optimal.png']);
hold off
    
%% plot manual vs classifier checkerboard (optimal)
figure('Units','inches','Position',[1 1 7 5],'PaperPositionMode','auto');
cplot = zeros(size(c_opt)+1);
cplot(1:length(opt.class),1:length(opt.class)) = c_opt;
%pcolor(log10(cplot))
pcolor(cplot)
set(gca, 'ytick', 1:length(opt.class), 'yticklabel', [])
text( -text_offset+ones(size(opt.class)),(1:length(opt.class))+.5, opt.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 0)
set(gca, 'xtick', 1:length(classes), 'xticklabel', [])
text((1:length(opt.class))+.5, -text_offset+ones(size(opt.class)), opt.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
axis square, colorbar, caxis([0 maxn])
title('manual vs. classifier; optimal score threshold')
%
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\checkerboard_manual_vs_classifier_optimal.png']);
hold off
