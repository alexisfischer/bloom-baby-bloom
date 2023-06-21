addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/'));
%%%% import Pn width data from literature
% plot Pn width from literature
s(1).width=[1.1 2]; s(1).name='delicatissima';
s(2).width=[1.5 3.4]; s(2).name='pseudodelicatissima';
s(3).width=[2.4 5.3]; s(3).name='pungens';
s(4).width=[3.4 6]; s(4).name='multiseries';
s(5).width=[4 6]; s(5).name='hemii';
s(6).width=[4.5 7.0]; s(6).name='fraudulenta';
s(7).width=[6.5 8]; s(7).name='australis';

low=brewermap(2,'Blues'); 
mh=brewermap(6,'YlOrRd'); 
s(1).color=low(1,:); s(3).color=low(2,:); 
s(2).color=mh(1,:); s(5).color=mh(2,:); s(6).color=mh(3,:); 
s(4).color=mh(5,:); s(7).color=mh(6,:);

figure; set(gcf,'color','w','Units','inches','Position',[1 1 4 1.65]); 
    plot([3.4 3.4],[0 10],':k','linewidth',1); hold on
    plot([6.5 6.5],[0 10],':k','linewidth',1); hold on
    for i=1:length(s)
        line(s(i).width,[i./11 i./11],'color',s(i).color,'linewidth',9); hold on
        %text(s(i).width(1)+.04,i./10+.005,s(i).name,'fontsize',9); hold on
        %  text(mean(s(i).width)-.45,i./10+.005,['' s(i).name(1:5) '.'],'fontsize',9); hold on
    end
    set(gca,'ylim',[0.04 .70],'xlim',[1 9],'xtick',1:2:9,'fontsize',10,...
        'xaxislocation','top','tickdir','out','yticklabel',{}); box on
    xlabel('Width (\mum)','fontsize',11);

% set figure parameters
exportgraphics(gcf,'~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/Figs/PN_width_literature.png','Resolution',300)    
hold off