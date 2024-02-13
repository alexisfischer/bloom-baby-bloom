% plot histogram on greyscale
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T','fli');

fli((fli.dt.Year==2021),:)=[];
gray=fli.dGray(~isnan(fli.dGray));
P=prctile(gray,[1 50 99]);

figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
    histogram(gray); hold on
    xline(P(1),':','linewidth',1.5); hold on;
    xline(P(2),':','linewidth',1.5); hold on;
    xline(P(3),':','linewidth',1.5); hold on;     
    ylabel('count','fontsize',11)
    xlabel('pigmentation','fontsize',11)    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_pigmentation.png'],'Resolution',100)    
hold off    

%%% Dinophysis vs Mesodinium vs Gray scale

%%%% adjust data for gray plotting
T.dGrayfx=T.dGray_fl;
T.dGrayfx(T.dGrayfx<P(1))=P(1);
T.dGrayfx(T.dGrayfx>P(3))=P(3);
T.dGrayfx=T.dGrayfx-P(1);
T.dGrayfx=T.dGrayfx./max(T.dGrayfx);
T.dGrayfx=abs(1-T.dGrayfx);

T.meso_fl(T.meso_fl<0)=0;

figure;
scatter(T.meso_fl,T.dGrayfx)
set(gca,'ylim',[.2 .8]);
ylabel('Dinophysis pigmentation')
xlabel('Mesodinium/mL')

%%%%
figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
    histogram(T.dGrayfx); hold on   
    ylabel('count','fontsize',11)
    xlabel('pigmentation','fontsize',11)        

idx=find(~isnan(T.mesoSmall_fl)); 
small=T.mesoSmall_fl(idx); large=T.mesoLarge_fl(idx); dt=T.dt(idx);

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.14 0.14]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

c=(brewermap(4,'RdYlGn')); ymax=8;

yrlist={'2021';'2022';'2023'};
for j=1:length(yrlist)
    ax(j)=subplot(3,1,j);

yyaxis left    
    % add xs to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=zeros(size(idx));
    hn=plot(T.dt(idx),val,'x','linewidth',.5,'color',[.5 .5 .5],...
        'markerfacecolor',[.5 .5 .5],'markersize',3); hold on;    
    if strcmp(yrlist(j),'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.1*ones(size(dti));
        plot(dti,val,'ks','linewidth',.5,'markersize',3,'color',[.5 .5 .5],...
        'markerfacecolor',[.5 .5 .5]); hold on;
    end

        hd=plot(T.dt,T.dino_fl,'-k','Linewidth',.5); hold on;            
        hl=plot(dt,large,'--.','color',c(2,:),'Linewidth',1); hold on;            
        hs=plot(dt,small,'--.','color',c(1,:),'Linewidth',1); hold on;
        set(gca,'xgrid','on','tickdir','out',...
            'xlim',[datetime([char(yrlist(j)) '-04-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 ymax],'ytick',0:4:ymax,'fontsize',10,'ycolor','k'); 
                  
        ylabel(yrlist(j)','fontsize',11);     

    yyaxis right
        hg=plot(T.dt,T.dGrayfx,'.b','Linewidth',1); hold on;            
        set(gca,'xgrid','on','tickdir','out',...
            'xlim',[datetime([char(yrlist(j)) '-04-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[.2 .8],'ytick',.2:.3:.8,'fontsize',10,'ycolor','b'); 
        grid off; 

end

datetick('x', 'mmm', 'keeplimits');            
lh=legend([hd hs hl hg hn],'Dinophysis cells/mL','small Meso cells/mL','large Meso cells/mL','Dino Pigmentation','no IFCB data','location','nw');  hp=get(lh,'pos');
    lh.Position=[hp(1)-.02 hp(2)+.6 hp(3) hp(4)]; hold on    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_Mesodinium_pigmentation_BI.png'],'Resolution',100)    
hold off

