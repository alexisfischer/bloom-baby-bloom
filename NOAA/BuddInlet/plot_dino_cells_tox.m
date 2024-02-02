%% plot Dinophysis with mesodinium and toxicity
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

class2do_string='Dinophysis'; ymax=15;

load([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T','Tc','fli','sci');
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   

[~,label]=get_class_ind(class2do_string,'all',class_indices_path);

idx=find(~isnan(T.meso_fl));
mesof=T.meso_fl(idx);
dtf=T.dt(idx);

idx=find(~isnan(T.meso_sc));
mesos=T.meso_sc(idx);
dts=T.dt(idx);

%%%% Dinophysis vs Mesodinium
figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.14 0.14]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
%c=(brewermap(2,'Set2'));

yrlist={'2021';'2022';'2023'};
for j=1:length(yrlist)
    ax(j)=subplot(3,1,j);

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
    
        hd=plot(T.dt,smoothdata(T.dino_fl,'movmean',2,'omitnan'),'-k','Linewidth',.5); hold on;
        hf=plot(dtf,mesof,'r.','Linewidth',.5); hold on;
        hs=plot(dts,mesos,'g.','Linewidth',.5); hold on;
                
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime([char(yrlist(j)) '-05-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 10],'fontsize',10,'ycolor','k');         
        ylabel(yrlist(j)','fontsize',11);     

end
ax(1).Title.String=['cells/mL'];

datetick('x', 'mmm', 'keeplimits');            
lh=legend([hd hf hs hn],'FL Dinophysis auto','FL Mesodinium man','SS Mesodinium man','no IFCB data','location','nw');  hp=get(lh,'pos');
    lh.Position=[hp(1)-.02 hp(2)+.6 hp(3) hp(4)]; hold on    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_Mesodinium_BI.png'],'Resolution',100)    
hold off

%% IFCB fl, microscopy, toxicity
%fl=retime(fli,'regular','mean','TimeStep',hours(1));
Tc=retime(Tc,'hourly','mean');

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.14 0.14]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

yrlist={'2021';'2022';'2023'};
for j=1:length(yrlist)
    ax(j)=subplot(3,1,j);

    yyaxis left
    % add xs to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=zeros(size(idx));
    hd=plot(T.dt(idx),val,'x','linewidth',.5,'color',[.5 .5 .5],...
        'markerfacecolor',[.5 .5 .5],'markersize',3); hold on;    
    if strcmp(yrlist(j),'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.1*ones(size(dti));
        plot(dti,val,'ks','linewidth',.5,'markersize',3,'color',[.5 .5 .5],...
        'markerfacecolor',[.5 .5 .5]); hold on;
    end

        ha=plot(T.dt,smoothdata(T.dino_fl,'movmean',2,'omitnan'),'-k','Linewidth',.5); hold on;    
        set(gca,'xgrid','on','tickdir','out',...
            'xticklabel',{},'ylim',[0 4.2],'fontsize',10,'ycolor','k');         
        ylabel(yrlist(j)','fontsize',11);     

    yyaxis right
        ht=plot(T.dt,T.DST,'b*','Linewidth',.8,'markersize',4); hold on;
        hc=hline(16,'b:'); hold on;        
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime([char(yrlist(j)) '-05-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 30],'ytick',0:15:30,'fontsize',10,'ycolor','b'); 

end
datetick('x', 'mmm', 'keeplimits');            
lh=legend([ha hd ht hc],'Dinophysis/mL','no IFCB data','DST µg/100g','closure thresh.','location','nw');  hp=get(lh,'pos');
     lh.Position=[hp(1)-.07 hp(2)+.03 hp(3) hp(4)]; hold on    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/' class2do_string '_cells_toxicity_BI.png'],'Resolution',100)    
hold off

