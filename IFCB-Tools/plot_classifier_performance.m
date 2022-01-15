clear;
Mac=1;

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

load([filepath 'performance_classifier_13Jan2022'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');
%load([filepath 'performance_classifier_04Jan2022'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');
%load([filepath 'performance_classifier_29Dec2021_2UnidDino'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');
text_offset = 0.1;
maxn=5000;

[~,class]=get_phyto_ind_PNW(all.class);

%% plot stacked total in set
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
b = bar([SCW.total PNW.total],'stack','Barwidth',1);
col=brewermap(2,'PRGn'); %col=[[.3 .3 .3];col];
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
    
legend('UCSC','NWFSC','Location','NE');
set(gca, 'xtick', 1:length(class), 'xticklabel', class,'tickdir','out');
ylabel('total images in set');
%%
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'total_UCSC_NWFSC.png']);
hold off

%% plot total in set
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
b = bar([all.total SCW.total PNW.total],'Barwidth',1,'linestyle','none');
col=brewermap(2,'PRGn'); col=[[.3 .3 .3];col];
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
   
legend('overall','UCSC', 'NWFSC','Location','NE');
set(gca, 'xtick', 1:length(class),'xticklabel', class);
ylabel('total images in set');
%%
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'total_SCW_PNW.png']);
hold off
    
%% plot ALL bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([all.Se all.Pr],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class),all.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
legend('Sensitivity', 'Precision','Location','W')
title('NWFSC + UCSC')
%%
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'Fx_sensitivity_precision.png']);
hold off

%% plot N CCS bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([PNW.Se PNW.Pr],'Barwidth',1,'linestyle','none'); hold on
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class),PNW.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
legend('Sensitivity', 'Precision','Location','NW')
title('NWFSC')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Fx_sensitivity_precision_NWFSC.png']);
hold off

%% plot SCW bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([SCW.Se SCW.Pr],'Barwidth',1,'linestyle','none'); hold on
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class),SCW.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', class); hold on
legend('Sensitivity', 'Precision','Location','W')
title('UCSC')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Fx_sensitivity_precision_UCSC.png']);
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
axis square;  colorbar, caxis([0 1])
ylabel('Manual','fontweight','bold');
xlabel('Classifier','fontweight','bold')

%%
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'checkerboard_manual_vs_classifier_opt.png']);
hold off

%% plot manual vs classifier checkerboard
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
cplot = zeros(size(c_all)+1);
cplot(1:length(class),1:length(class)) = c_all;
total=[sum(c_all,2);0];
fx_unclass=sum(c_all(:,end))./sum(total) % what fraction of images went to unclassified?

C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(4,3); col]); 
set(gca, 'ytick', 1:length(class), 'yticklabel', class,...
    'xtick', 1:length(class), 'xticklabel',class)
axis square;  colorbar, caxis([0 1])
ylabel('Manual','fontweight','bold');
xlabel('Classifier','fontweight','bold')

%%
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[figpath 'checkerboard_manual_vs_classifier_all.png']);
hold off

    