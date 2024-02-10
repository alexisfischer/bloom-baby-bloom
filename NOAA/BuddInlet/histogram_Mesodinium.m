% plot histogram on Mesodinium
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/BuddInlet/manual/summary_meso_width_manual'],'mdate','ESD');
dt=datetime(mdate,'convertfrom','datenum')';

figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
    histogram(cell2mat(ESD),10:2:70); hold on
    xl=xline(26,':',{'26 \mum'},'linewidth',1.5); hold on;
    set(gca,'xlim',[10 70],'xtick',10:10:70,'fontsize',10,'tickdir','out');
    ylabel('count','fontsize',11)
    xlabel('Mesodinium ESD (\mum)')

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Mesodinium_ESD_histogram.png'],'Resolution',100)    
hold off


%% year by year
figure('Units','inches','Position',[1 1 3.5 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.1 0.04], [0.19 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
% yrlist=[2021;2022;2023];
for i=1:length(yrlist)
    ax(i)=subplot(3,1,i);
    idx=(dt.Year==yrlist(i));
    histogram(cell2mat([ESD(idx)]),10:2:70); hold on
    xl=xline(26,':','linewidth',1.5); hold on;
    set(gca,'xlim',[10 70],'xtick',10:10:70, ...
       'fontsize',10,'tickdir','out'); hold on;
    ylabel(num2str(yrlist(i)),'fontsize',11)
end
    xlabel('Mesodinium ESD (\mum)')

ax(1).XTickLabel={}; ax(2).XTickLabel={};

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Mesodinium_ESD_histogram_yr.png'],'Resolution',100)    
hold off
