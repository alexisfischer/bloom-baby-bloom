%% Plot DSP data from all of Puget Sound
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath(filepath));

load([filepath 'Data/DSP_PugetSound'],'S','TR');

c=brewermap(length(S),'Spectral');
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
for i=1:width(TR)
    temp=table2array(TR(:,i));
    idx=isnan(temp);
    cs=cumsum(temp(~idx));
    h(i)=plot(TR.Time(~idx),cs,'.'); hold on;
    set(h(i),'color',c(i,:))
end
set(gca,'tickdir','out','fontsize',10);
ylabel('DST µg/100g','fontsize',11)
lh=legend([S.site],'location','EastOutside','fontsize',10); legend boxoff;

% set figure parameters
exportgraphics(gcf,[filepath '/Figs/DST_PugetSound_summary.png'],'Resolution',100)    
hold off
