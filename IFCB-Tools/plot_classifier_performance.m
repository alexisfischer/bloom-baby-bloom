%function [ ] = plot_classifier_performance( classifiername )
%plot classifier performance
clear;
%filepath = '~/MATLAB/bloom-baby-bloom/IFCB-Data/Shimada/class/';
filepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\';
addpath(genpath(filepath));
%addpath(genpath('~/MATLAB/bloom-baby-bloom/Misc-Functions/'));

load([filepath 'performance_classifier_04Jan2022'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');
%load([filepath 'performance_classifier_29Dec2021_2UnidDino'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');
text_offset = 0.1;
maxn=5000;

class=all.class;
id=strcmp(class,'D_acuminata,D_acuta,D_caudata,D_fortii,D_norvegica,D_odiosa,D_parva,D_rotundata,D_tripos,Dinophysis');
class{id}='Dinophysis';
% id=find(strcmp(class,'Pn_large_narrow,Pn_large_wide,Pn_parasite,Pn_small,Pseudo-nitzschia'));
% class{id}='Pseudo-nitzschia';

%% plot stacked total in set
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
b = bar([SCW.total PNW.total],'stack','Barwidth',1);
col=brewermap(2,'PRGn'); %col=[[.3 .3 .3];col];
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
    
legend('UCSC','NWFSC','Location','NE');
set(gca, 'xtick', 1:length(class), 'xticklabel', []);
ylabel('total images in set');
text(1:length(class), -text_offset.*ones(size(class)), class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
%%
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'Figs\total_UCSC_NWFSC.png']);
hold off

%% plot total in set
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
b = bar([all.total SCW.total PNW.total],'Barwidth',1,'linestyle','none');
col=brewermap(2,'PRGn'); col=[[.3 .3 .3];col];
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
   
legend('overall','UCSC', 'NWFSC','Location','NE');
set(gca, 'xtick', 1:length(class), 'xticklabel', []);
ylabel('total images in set');
text(1:length(class), -text_offset.*ones(size(class)), class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'Figs\total_SCW_PNW.png']);
hold off
    
%% plot ALL bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 4.5],'PaperPositionMode','auto');
yyaxis left;
b=bar([all.Se all.Pr],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', []); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class),all.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', []); hold on
text(1:length(class), -text_offset.*ones(size(class)), class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.75 0.6])
legend('Sensitivity', 'Precision','Location','W')
title('NWFSC + UCSC')

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'Figs\Fx_sensitivity_precision_noUnidDino.png']);
hold off

%% plot N CCS bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 4.5],'PaperPositionMode','auto');
yyaxis left;
b=bar([PNW.Se PNW.Pr],'Barwidth',1,'linestyle','none'); hold on
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', []); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class),PNW.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', []); hold on
text(1:length(class), -text_offset.*ones(size(class)), class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.75 0.6])
legend('Sensitivity', 'Precision','Location','NW')
title('NWFSC')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Fx_sensitivity_precision_NWFSC.png']);
hold off

%% plot SCW bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 4.5],'PaperPositionMode','auto');
yyaxis left;
b=bar([SCW.Se SCW.Pr],'Barwidth',1,'linestyle','none'); hold on
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', []); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class),SCW.total,'k*'); hold on
ylabel('total images in set');
set(gca,'ycolor','k', 'xtick', 1:length(class), 'xticklabel', []); hold on
text(1:length(class), -text_offset.*ones(size(class)), class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.75 0.6])
legend('Sensitivity', 'Precision','Location','W')
title('UCSC')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Fx_sensitivity_precision_UCSC.png']);
hold off

%% plot opt manual vs classifier checkerboard
class=opt.class;
id=strcmp(class,'D_acuminata,D_acuta,D_caudata,D_fortii,D_norvegica,D_odiosa,D_parva,D_rotundata,D_tripos,Dinophysis');
class{id}='Dinophysis';
id=find(strcmp(class,'Pn_large_narrow,Pn_large_wide,Pn_parasite,Pn_small,Pseudo-nitzschia'));
class{id}='Pseudo-nitzschia';

figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
cplot = zeros(size(c_opt)+1);
cplot(1:length(opt.class),1:length(opt.class)) = c_opt;
total=[sum(c_opt,2);0];
fx_unclass=sum(c_opt(:,end))./sum(total) % what fraction of images went to unclassified?

C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(4,3); col]); 
set(gca, 'ytick', 1:length(opt.class), 'yticklabel', [])
text( -text_offset+ones(size(opt.class)),(1:length(opt.class))+.5, class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 0)
set(gca, 'xtick', 1:length(opt.class), 'xticklabel', [])
text((1:length(opt.class))+.5, -text_offset+ones(size(opt.class)), class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
axis square;  colorbar, caxis([0 1])
%title('manual(x) vs. classifier(y)')
p=get(gca,'position');  % retrieve the current values
set(gca,'position',[2.2*p(1) p(2) .9*p(3) 1.2*p(4)]);  % write the new values

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'Figs\checkerboard_manual_vs_classifier_opt.png']);
hold off

%%
%% plot manual vs classifier checkerboard
class=all.class;
id=strcmp(class,'D_acuminata,D_acuta,D_caudata,D_fortii,D_norvegica,D_odiosa,D_parva,D_rotundata,D_tripos,Dinophysis');
class{id}='Dinophysis';
id=find(strcmp(class,'Pn_large_narrow,Pn_large_wide,Pn_parasite,Pn_small,Pseudo-nitzschia'));
class{id}='Pseudo-nitzschia';

figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
cplot = zeros(size(c_all)+1);
cplot(1:length(all.class),1:length(all.class)) = c_all;
total=[sum(c_all,2);0];
fx_unclass=sum(c_all(:,end))./sum(total) % what fraction of images went to unclassified?

C = bsxfun(@rdivide, cplot, total); C(isnan(C)) = 0;
pcolor(C); col=flipud(brewermap([],'Spectral')); colormap([ones(4,3); col]); 
set(gca, 'ytick', 1:length(all.class), 'yticklabel', [])
text( -text_offset+ones(size(all.class)),(1:length(all.class))+.5, class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 0)
set(gca, 'xtick', 1:length(all.class), 'xticklabel', [])
text((1:length(all.class))+.5, -text_offset+ones(size(all.class)), class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
axis square;  colorbar, caxis([0 1])
%title('manual(x) vs. classifier(y)')
p=get(gca,'position');  % retrieve the current values
set(gca,'position',[2.2*p(1) p(2) .9*p(3) 1.2*p(4)]);  % write the new values

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'Figs\checkerboard_manual_vs_classifier_all.png']);
hold off

    