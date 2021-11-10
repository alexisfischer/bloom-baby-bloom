%plot classifier comparison

clear;
addpath(genpath('~/MATLAB/bloom-baby-bloom/'));
filepath = '~/MATLAB/bloom-baby-bloom/IFCB-Data/Shimada/class/';
N=load([filepath 'performance_classifier_09Nov2021'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');
O=load([filepath 'performance_classifier_19Oct2021'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');

text_offset = 0.1;
maxn=5000;

[ ind_out, class_label ] = get_all_ind_PNW( [N.all.class] );

figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.2 0.02], [0.15 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(3,1,1)
plot(1:length(N.PNW.class),N.PNW.total,'r*',1:length(O.PNW.class),O.PNW.total,'bs'); hold on
yline(2000,'--'); hold on;
set(gca,'ycolor','k','xlim',[0 length(N.all.class)+4],'xtick', 1:length(N.all.class), 'xticklabel',{},'tickdir','out'); hold on
ylabel({'total images';'in NWFSC set'});
legend('09Nov', '19Oct','Location','NE'); hold on;

subplot(3,1,2)
plot(1:length(N.all.class),N.all.Se,'r*',1:length(O.all.class),O.all.Se,'bs'); hold on
yline(.9,'--'); hold on;
set(gca,'ycolor','k','xlim',[0 length(N.all.class)+4], 'xtick', 1:length(N.all.class), 'xticklabel',{},'tickdir','out'); hold on
ylabel('Sensitivity (all)');

subplot(3,1,3)
plot(1:length(N.all.class),N.all.Pr,'r*',1:length(O.all.class),O.all.Pr,'bs'); hold on
yline(.9,'--'); hold on;
set(gca,'ycolor','k','xlim',[0 length(N.all.class)+4], 'xtick', 1:length(N.all.class), 'xticklabel',class_label,'tickdir','out'); hold on
ylabel('Precision (all)');

set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Classifier_Comparison.png']);
hold off