addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/'));
% plot Pn width from literature
s(1).width=[1.1 2]; s(1).name='delicatissima';
s(2).width=[1.5 3.4]; s(2).name='pseudodelicatissima';
s(3).width=[2.4 3.5]; s(3).name='pungens';
s(4).width=[3.4 6.5]; s(4).name='multiseries';
s(5).width=[4.5 6.5]; s(5).name='fraudulenta';
s(6).width=[6.5 8]; s(6).name='australis';

s(1).letter='A'; s(2).letter='B'; s(3).letter='C';
s(4).letter='D'; s(5).letter='E'; s(6).letter='F';

col=brewermap(5,'RdBu'); 
s(1).color=col(4,:); s(2).color=col(4,:); s(3).color=col(4,:);
s(4).color=col(2,:); s(5).color=col(2,:); s(6).color=col(2,:);

figure; set(gcf,'color','w','Units','inches','Position',[1 1 2.3 1.3]); 
for i=1:length(s)
    line(s(i).width,[i./16 i./16],'color',s(i).color,'linewidth',8); hold on
    text(mean(s(i).width)-.5,i./16+.01,s(i).name(1:3),'fontsize',9); hold on
   % text(s(i).width(2),i./16+.01,s(i).name(1:3),'fontsize',9); hold on
end
xline(3.5,'-r','linewidth',1); hold on
set(gca,'ylim',[0.02 0.42],'xlim',[1 9],'xtick',1:2:9,'fontsize',9,...
    'xaxislocation','bottom','tickdir','out','yticklabel',{}); box on
xlabel('Width (\mum)','fontsize',11);

% set figure parameters

exportgraphics(gcf,'~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/Figs/PN_width_literature.png','Resolution',300)    
hold off