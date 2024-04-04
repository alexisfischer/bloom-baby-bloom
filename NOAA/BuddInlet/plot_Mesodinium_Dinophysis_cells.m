%% plot Dinophysis with mesodinium and toxicity
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T','Tc','fli');

%%%% remove IFCB sampling data gaps, but keep meso gaps
idx=find(isnan(T.mesoSmall_fl)); 
    T.mesoSmall_fl(idx)=999; T.mesoLarge_fl(idx)=999; T.mesoSmall_sc(idx)=999; T.mesoLarge_sc(idx)=999;
idx=find(isnan(T.dino_fl));
    T.mesoSmall_fl(idx)=NaN; T.mesoLarge_fl(idx)=NaN; T.mesoSmall_sc(idx)=NaN; T.mesoLarge_sc(idx)=NaN;
idx=~((T.mesoSmall_fl)==999); 
    small=T.mesoSmall_fl(idx); large=T.mesoLarge_fl(idx); smallA=T.mesoSmall_sc(idx); largeA=T.mesoLarge_sc(idx); dt=T.dt(idx);

idx=find(dt==datetime('09-Jul-2023')); large(idx)=large(idx)-17;

%%%% Dinophysis vs Mesodinium
figure('Units','inches','Position',[1 1 3.2 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.04], [0.08 0.08]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
c=flipud(brewermap(3,'YlOrRd')); ymax=8;

yrlist={'2021';'2022';'2023'};
for j=1:length(yrlist)
    ax(j)=subplot(3,1,j);

yyaxis left    
        hd=plot(T.dt,T.dino_fl,'-k','Linewidth',1); hold on;                           
        set(gca,'xgrid','on','tickdir','out',...
            'xlim',[datetime([char(yrlist(j)) '-04-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 4],'fontsize',9,'ycolor','k');         
        
    yyaxis right
        hl=plot(dt,large,':.','color',c(2,:),'Linewidth',1.5); hold on;  
        if strcmp(yrlist(j),'2022')
            hs=plot(dt,smallA,':.','color',c(1,:),'Linewidth',1.5); hold on;
        else
            hs=plot(dt,small,':.','color',c(1,:),'Linewidth',1.5); hold on;
        end            
        set(gca,'xgrid','on','tickdir','out',...
            'xlim',[datetime([char(yrlist(j)) '-04-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 ymax],'ytick',0:4:ymax,'fontsize',9,'ycolor',c(1,:));

    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
    hn=plot(T.dt(idx),val,'s','markersize',3,'linewidth',.5,'color',[.5 .5 .5],'markerfacecolor',[.5 .5 .5]); hold on;              
    if strcmp(yrlist(j),'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.1*ones(size(dti));
        plot(dti,val,'-','linewidth',3.2,'color',[.5 .5 .5]); hold on;        
    end
        grid off; 
end

datetick('x', 'mmm', 'keeplimits');       

% lh=legend([hd hs hl hn],'\itDinophysis \rmspp.','small \itMesodinium \rmspp.','large \itMesodinium \rmspp.','no IFCB data','location','nw');  hp=get(lh,'pos');
%     lh.Position=[hp(1)-.02 hp(2)+.6 hp(3) hp(4)]; hold on    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_Mesodinium_BI.png'],'Resolution',300)    
hold off
