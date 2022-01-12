%% plot CCS classifer comparison w/out Detritus
clear;
filepath = '~/MATLAB/bloom-baby-bloom/IFCB-Data/Shimada/class/';
addpath(genpath(filepath));
addpath(genpath('~/MATLAB/bloom-baby-bloom/Misc-Functions/'));

D=load([filepath 'performance_classifier_30Dec2021_noUnidDino'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');
N=load([filepath 'performance_classifier_03Jan2022'],'topfeat','PNW','SCW','all','opt','c_all','c_opt');

class=D.all.class;

id=strcmp(class,'D_acuminata,D_acuta,D_caudata,D_fortii,D_norvegica,D_odiosa,D_parva,D_rotundata,D_tripos,Dinophysis');
class{id}='Dinophysis';
id=find(strcmp(class,'Pn_large_narrow,Pn_large_wide,Pn_parasite,Pn_small,Pseudo-nitzschia'));
class{id}='Pseudo-nitzschia';

%%
fx_un.D=round(sum(D.c_opt(:,end))./sum(sum(D.c_opt,2)),2);
fx_un.N=round( sum(N.c_opt(:,end))./sum(sum(N.c_opt,2)),2);

% plot total in set
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.3 0.1], [0.1 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1)
b = bar([D.all.Se N.all.Se],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k:');
col=brewermap(3,'Accent');
set(b(1),'FaceColor',col(1,:));
set(b(2),'FaceColor',col(2,:));
set(gca, 'xtick', 1:length(class), 'xticklabel', [],'ylim',[.3 1]);
ylabel('Sensitivity');
lh=legend(['w Detritus (fx unclassified=' num2str(fx_un.D) ')'],...
    ['w Dactyliosolen (fx unclassified=' num2str(fx_un.N) ')'],'Location','North'); legend boxoff;
a=lh.Position; set(lh,'Position',[a(1) 1.15*a(2) a(3) a(4)]); 

subplot(2,1,2)
b = bar([D.all.Pr N.all.Pr],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k:');
col=brewermap(3,'Accent');
set(b(1),'FaceColor',col(1,:));
set(b(2),'FaceColor',col(2,:));
  
set(gca, 'xtick', 1:length(class), 'xticklabel', class,'ylim',[.3 1]);
xtickangle(45)
ylabel('Precision');

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'Figs\classifier_compare_Detritus.png']);
hold off