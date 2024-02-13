%% plot Dinophysis with mesodinium and toxicity
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T','Tc','fli');
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   

idx=find(~isnan(T.mesoSmall_fl)); 
small=T.mesoSmall_fl(idx); large=T.mesoLarge_fl(idx); dt=T.dt(idx);

idx=find(dt==datetime('09-Jul-2023')); large(idx)=large(idx)-17;


%% Dinophysis vs Mesodinium
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
                
        set(gca,'xgrid','on','tickdir','out',...
            'xlim',[datetime([char(yrlist(j)) '-04-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 4],'fontsize',10,'ycolor','k');         
        ylabel(yrlist(j)','fontsize',11);     

    yyaxis right
        hl=plot(dt,large,'--.','color',c(2,:),'Linewidth',1); hold on;            
        hs=plot(dt,small,'--.','color',c(1,:),'Linewidth',1); hold on;
        set(gca,'xgrid','on','tickdir','out',...
            'xlim',[datetime([char(yrlist(j)) '-04-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 ymax],'ytick',0:4:ymax,'fontsize',10,'ycolor',c(1,:)); 
        grid off; 

end

ax(1).Title.String=['daily median cells/mL'];
datetick('x', 'mmm', 'keeplimits');            
lh=legend([hd hs hl hn],'Dinophysis','small Mesodinium','large Mesodinium','no IFCB data','location','nw');  hp=get(lh,'pos');
    lh.Position=[hp(1)-.02 hp(2)+.6 hp(3) hp(4)]; hold on    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_Mesodinium_BI.png'],'Resolution',100)    
hold off
