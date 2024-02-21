clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'Data/SequimBay_Dinophysiscells.mat'],'T','SB');

%SB.ComBlo=sum([SB.Bloom,SB.Common],2);

figure('Units','inches','Position',[1 1 3.5 3],'PaperPositionMode','auto');
c=brewermap(2,'Set1');

h=plot(SB.Month,SB.Present,'-.',SB.Month,SB.Common,'-','Color',c(1,:),...
    'markersize',3,'linewidth',2);

set(gca,'ylim',[0 1],'ytick',0:.5:1,'fontsize',10,...
    'xlim',[1 12],'xtick',1:1:12,'tickdir','out',...
   'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'})
ylabel('fx of samples per category','fontsize',11)

%lh=legend([h(2)],'Sequim Bay','Location','NorthOutside','fontsize',10); legend boxoff;

lh=legend([h(1) h(2)],'Present','Common','Location','NorthOutside','fontsize',10); legend boxoff;
lh.Title.String={'Abundance Categories'};

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