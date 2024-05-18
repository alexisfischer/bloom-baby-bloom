%% plot Soundtoxins Dinophysis
% A.D. Fischer, May 2024

clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/'));
addpath(genpath(filepath));

DSP=load([filepath 'Data/DSP_PugetSound'],'QH','BI','LB','SB','MB','DB');
load([filepath 'Data/SoundToxins_Dinophysis.mat'],'QH','BI','LB','SB','MB','DB','S');
Month=BI.Month;

figure('Units','inches','Position',[1 1 5 4.6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.23], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
c=brewermap(length(S),'Spectral');

subplot(2,2,1)
b=bar(Month,[BI.n,SB.n,QH.n,DB.n,MB.n,LB.n],'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',c(i,:))
end
set(gca,'ylim',[0 400],'ytick',0:200:400,'fontsize',9,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out','xticklabel',{})
ylabel('total samples','fontsize',11)
lh=legend('Budd Inlet','Sequim Bay','Quartermaster Harbor','Discovery Bay',...
    'Mystery Bay','Liberty Bay','Location','North','fontsize',9); legend boxoff;
    lh.FontSize = 9; hp=get(lh,'pos');
    lh.Position=[hp(1) hp(2)+.24 hp(3) hp(4)]; hold on   

subplot(2,2,3)
plot(Month,(BI.Present+BI.Common+BI.Bloom),':',Month,(BI.Common+BI.Bloom),'-','Color',c(1,:),'markersize',3,'linewidth',2); hold on
plot(Month,(SB.Present+SB.Common+SB.Bloom),':',Month,(SB.Common+SB.Bloom),'-','Color',c(2,:),'markersize',3,'linewidth',2); hold on
plot(Month,(QH.Present+QH.Common+QH.Bloom),':',Month,(QH.Common+QH.Bloom),'-','Color',c(3,:),'markersize',3,'linewidth',2); hold on
plot(Month,(DB.Present+DB.Common+DB.Bloom),':',Month,(DB.Common+DB.Bloom),'-','Color',c(4,:),'markersize',3,'linewidth',2); hold on
plot(Month,(MB.Present+MB.Common+MB.Bloom),':',Month,(MB.Common+MB.Bloom),'-','Color',c(5,:),'markersize',3,'linewidth',2); hold on
plot(Month,(LB.Present+LB.Common+LB.Bloom),':',Month,(LB.Common+LB.Bloom),'-','Color',c(6,:),'markersize',3,'linewidth',2); hold on
set(gca,'ylim',[-.02 1.02],'ytick',0:.5:1,'fontsize',9,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out',...
   'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'});
ylabel({'fraction of samples'},'fontsize',11)

subplot(2,2,2)
b=bar(Month,[DSP.BI.n,DSP.SB.n,DSP.QH.n,DSP.DB.n,DSP.MB.n,DSP.LB.n],'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',c(i,:)); hold on
end
set(gca,'ylim',[0 400],'ytick',0:200:400,'fontsize',9,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out','xticklabel',{},'yticklabel',{}); hold on;

subplot(2,2,4)
plot(Month,DSP.BI.with,':',Month,DSP.BI.above16,'-','Color',c(1,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.SB.with,':',Month,DSP.SB.above16,'-','Color',c(2,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.QH.with,':',Month,DSP.QH.above16,'-','Color',c(3,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.DB.with,':',Month,DSP.DB.above16,'-','Color',c(4,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.MB.with,':',Month,DSP.MB.above16,'-','Color',c(5,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.LB.with,':',Month,DSP.LB.above16,'-','Color',c(6,:),'markersize',3,'linewidth',2); hold on
set(gca,'ylim',[-.02 1.02],'ytick',0:.5:1,'fontsize',9,'yticklabel',{},...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out',...
   'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); hold on;
xtickangle=90;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Soundtoxins_DSP_lineplot.png'],'Resolution',300)  

%% Soundtoxins only
figure('Units','inches','Position',[1 1 3.5 4.6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.23], [0.2 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
c=brewermap(length(S),'Spectral');

subplot(2,1,1)
b=bar(Month,[BI.n,SB.n,QH.n,DB.n,MB.n,LB.n],'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',c(i,:))
end
set(gca,'ylim',[0 215],'ytick',0:100:200,'fontsize',10,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out','xticklabel',{})
ylabel('total samples','fontsize',11)
lh=legend('Budd Inlet','Sequim Bay','Quartermaster Harbor','Discovery Bay',...
    'Mystery Bay','Liberty Bay','Location','North','fontsize',10); legend boxoff;
    lh.FontSize = 9; hp=get(lh,'pos');
    lh.Position=[hp(1) hp(2)+.24 hp(3) hp(4)]; hold on   

subplot(2,1,2)
plot(Month,(BI.Present+BI.Common+BI.Bloom),':',Month,(BI.Common+BI.Bloom),'-','Color',c(1,:),'markersize',3,'linewidth',2); hold on
plot(Month,(SB.Present+SB.Common+SB.Bloom),':',Month,(SB.Common+SB.Bloom),'-','Color',c(2,:),'markersize',3,'linewidth',2); hold on
plot(Month,(QH.Present+QH.Common+QH.Bloom),':',Month,(QH.Common+QH.Bloom),'-','Color',c(3,:),'markersize',3,'linewidth',2); hold on
plot(Month,(DB.Present+DB.Common+DB.Bloom),':',Month,(DB.Common+DB.Bloom),'-','Color',c(4,:),'markersize',3,'linewidth',2); hold on
plot(Month,(MB.Present+MB.Common+MB.Bloom),':',Month,(MB.Common+MB.Bloom),'-','Color',c(5,:),'markersize',3,'linewidth',2); hold on
plot(Month,(LB.Present+LB.Common+LB.Bloom),':',Month,(LB.Common+LB.Bloom),'-','Color',c(6,:),'markersize',3,'linewidth',2); hold on

set(gca,'ylim',[-.02 1.02],'ytick',0:.5:1,'fontsize',10,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out',...
   'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'});
ylabel({'fraction of samples';'with \itDinophysis \rmspp.'},'fontsize',11)


%% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Soundtoxins_lineplot.png'],'Resolution',100)    
hold off
