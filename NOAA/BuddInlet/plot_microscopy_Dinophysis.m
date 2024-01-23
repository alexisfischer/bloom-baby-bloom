%% plot Dinophysis microscopy in Budd Inlet and vs other sites
clear;
fprint=0;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

load([filepath 'Data/BuddInlet_data_summary'],'T');

idx=isnan(T.dinoML_microscopy); T(idx,:)=[]; %remove nans for better plotting

% plot BI 
figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto'); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.15], [0.12 0.25]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datetime('2021-05-01'); xax2=datetime('2023-11-01');     

subplot(2,1,1);
plot(T.dt,T.dinoML_microscopy,'k*','MarkerSize',5);
    set(gca,'xlim',[xax1 xax2],...
        'fontsize', 11,'fontname', 'arial','tickdir','out','xaxislocation','top');   
    ylabel('cells/mL','fontsize',11);
    title('Dinophysis spp. Microscopy')

subplot(2,1,2);
h = bar(T.dt,[T.fx_Dacuminata T.fx_Dfortii T.fx_Dnorvegica T.fx_Dodiosa...
    T.fx_Drotundata T.fx_Dparva T.fx_Dacuta],'stack','Barwidth',3,'linestyle','none');
c=brewermap(7,'Spectral');
    for i=1:length(h)
        set(h(i),'FaceColor',c(i,:));
    end  

    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',0:.5:1,...
        'fontsize', 11,'fontname', 'arial','tickdir','out')
    ylabel('species fraction','fontsize',11);

    lh=legend('acuminata','fortii','norvegica','odiosa','rotundata','parva','acuta');
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)+.27 hp(2)+.05 hp(3) hp(4)]; hold on    
    lh.Title.String='Species';

if fprint
    exportgraphics(gcf,[filepath 'Figs/Dinophysis_microscopy_BI.png'],'Resolution',100)    
    hold off
end
hold off