%% plot Soundtoxins Dinophysis
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'Data/SoundToxins_Dinophysis.mat'],'QH','BI','LB','SB','MB','DB','S');
%load([filepath 'Data/SequimBay_Dinophysiscells.mat'],'T','SB');

%SB.ComBlo=sum([SB.Bloom,SB.Common],2);

figure('Units','inches','Position',[1 1 3.5 4.6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.23], [0.2 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
c=brewermap(length(S),'Spectral');

subplot(2,1,1)
b=bar(BI.Month,[BI.n,SB.n,QH.n,DB.n,MB.n,LB.n],'stacked','FaceColor','flat','BarWidth',1); hold on;
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
plot(BI.Month,BI.Present,':',BI.Month,(BI.Common+BI.Bloom),'-','Color',c(1,:),'markersize',3,'linewidth',2); hold on
plot(SB.Month,SB.Present,':',SB.Month,(SB.Common+SB.Bloom),'-','Color',c(2,:),'markersize',3,'linewidth',2); hold on
plot(QH.Month,QH.Present,':',QH.Month,(QH.Common+QH.Bloom),'-','Color',c(3,:),'markersize',3,'linewidth',2); hold on
plot(DB.Month,DB.Present,':',DB.Month,(DB.Common+DB.Bloom),'-','Color',c(4,:),'markersize',3,'linewidth',2); hold on
plot(MB.Month,MB.Present,':',MB.Month,(MB.Common+MB.Bloom),'-','Color',c(5,:),'markersize',3,'linewidth',2); hold on
plot(LB.Month,LB.Present,':',LB.Month,(LB.Common+LB.Bloom),'-','Color',c(6,:),'markersize',3,'linewidth',2); hold on

set(gca,'ylim',[-.02 1.02],'ytick',0:.5:1,'fontsize',10,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out',...
   'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'});
ylabel({'fraction of samples';'with \itDinophysis \rmspp.'},'fontsize',11)

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Soundtoxins_lineplot.png'],'Resolution',100)    
hold off

%% plot stacked bar chart
c=flipud(brewermap(4,'Greys')); c(4,:)=[1 1 1];

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
yyaxis left
b=bar(T,'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:4
    b(i).CData=c(i,:);
end
set(gca,'xlim',[0.5 12.5],'ycolor','k','fontsize',10)
ylabel('fx of samples per category','fontsize',11)

yyaxis right
plot(SB.Month,SB.n,'r*','linewidth',1); hold on;
set(gca,'xlim',[0.5 12.5],'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'},'ycolor','r','fontsize',10)

ylabel('# samples','fontsize',11)
xlabel('month','fontsize',11)
title('Sequim Bay','fontsize',12)

lh=legend([b(4) b(3) b(2) b(1)],'Absent','Present','Common','Bloom',...
    'Location','NorthOutside','fontsize',10); legend boxoff;
%lh.Title.String={'Dinophysis';'Relative';'Abundance'};

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/SequimBay_RelAbundance.png'],'Resolution',100)    
hold off