%% plot Dinophysis microscopy in Budd Inlet and vs other sites
clear;
fprint=1;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy'],'T');
load([filepath 'NOAA/BuddInlet/Data/SoundToxins_DSP_BI'],'S');
addpath(genpath(filepath));

idx=string([S.Location])=='Port';


%% plot BI with Port Plaza
figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.08], [0.09 0.21]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datetime('2021-05-01'); xax2=datetime('2021-11-20');     

subplot(2,1,1);
plot(T.SampleDate,.001*T.DinophysisConcentrationcellsL,'k*-',...
    S.Date(idx),.001*S.DinocellsL(idx),'ko:','MarkerSize',5);
    set(gca,'xlim',[xax1 xax2],...
        'fontsize', 11,'fontname', 'arial','tickdir','out','xaxislocation','top');   
    ylabel('Dinophysis (cells/mL)','fontsize',11);
legend('OYC','Port Plaza');
subplot(2,1,2);
h = bar(T.SampleDate,0.01*[T.DAcuminata T.DFortii T.DNorvegica T.DOdiosa...
    T.DRotundata T.DParva],'stack','Barwidth',4);
c=brewermap(6,'Spectral');
    for i=1:length(h)
        set(h(i),'FaceColor',c(i,:));
    end  

%    datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 11,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'});   
        ylabel('Fx Dinophysis','fontsize',11);


    lh=legend('acuminata','fortii','norvegica','odiosa','rotundata','parva');
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)+.23 hp(2) hp(3) hp(4)]; hold on    
    lh.Title.String='Species';

if fprint
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r300',[filepath 'NOAA/BuddInlet/Figs/Dinophysis_microscopy_BI.tif']);
end
hold off