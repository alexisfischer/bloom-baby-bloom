%% plot Dinophysis with toxicity
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

class2do_string='Dinophysis'; ymax=20;

load([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T','Tc','fli','sci');
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   

[~,label]=get_class_ind(class2do_string,'all',class_indices_path);

T.dinomax=smoothdata(T.dinomax,'movmean',2,'omitnan');
T.mesomax=smoothdata(T.mesomax,'movmean',2,'omitnan');

%% plot raw data
figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.14 0.14]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
c=(brewermap(2,'Set1'));

T(isnan(T.dino_fl),:)=[]; %remove IFCB data gaps

yrlist={'2021';'2022';'2023'};
for j=1:length(yrlist)
    ax(j)=subplot(3,1,j);

        % hf=stem(T.dt,T.mesomax,'k-','Linewidth',.5,'marker','none'); hold on;
         hf=stem(Tc.dt,Tc.meso,'k-','Linewidth',.5,'marker','none'); hold on;

         %hf=stem(sci.dt,sci.dino,'k-','Linewidth',.5,'marker','none'); hold on;
         %hf=stem(fli.dt,fli.dino,'k-','Linewidth',.5,'marker','none'); hold on;

       % hm=plot(T.dt,T.dinoML_microscopy,'^','color',c(1,:),'markerfacecolor',c(1,:),'Linewidth',.8,'markersize',4); hold on;        
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime([char(yrlist(j)) '-05-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 ymax],'fontsize',10,'ycolor','k');         
        ylabel(yrlist(j)','fontsize',11);     

end
ax(1).Title.String=[ char(label) ' cells/mL'];
datetick('x', 'mmm', 'keeplimits');            
% lh=legend([hf hm],'IFCB FL','microscopy','location','nw');  hp=get(lh,'pos');
%     lh.Position=[hp(1)-.02 hp(2)+.6 hp(3) hp(4)]; hold on    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Mesodinium_IFCB_fl_microscopy.png'],'Resolution',100)    
hold off

%% IFCB fl and sc, microscopy
figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.14 0.14]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
c=(brewermap(2,'Set1'));

T(isnan(T.dino_fl),:)=[]; %remove IFCB data gaps

yrlist={'2021';'2022';'2023'};
for j=1:length(yrlist)
    ax(j)=subplot(3,1,j);
  
        hf=plot(T.dt,T.dino_fl,'k-','Linewidth',.5); hold on;
        hs=plot(T.dt,T.dino_sc,'k:','Linewidth',1); hold on;        
        hm=plot(T.dt,T.dinoML_microscopy,'^','color',c(1,:),'markerfacecolor',c(1,:),'Linewidth',.8,'markersize',4); hold on;        
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime([char(yrlist(j)) '-05-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 ymax],'fontsize',10,'ycolor','k');         
        ylabel(yrlist(j)','fontsize',11);     

end
ax(1).Title.String=[char(label) ' cells/mL'];
datetick('x', 'mmm', 'keeplimits');            
lh=legend([hf hs hm],'IFCB fl','IFCB sc','microscopy','location','nw');  hp=get(lh,'pos');
    lh.Position=[hp(1)-.02 hp(2)+.6 hp(3) hp(4)]; hold on    

%% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_IFCB_sc_fl_microscopy.png'],'Resolution',100)    
hold off


%% IFCB fl, microscopy, toxicity
%fl=retime(fli,'regular','mean','TimeStep',hours(1));
Tc=retime(Tc,'hourly','mean');

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.14 0.14]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
c=(brewermap(2,'Set1'));

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

        ha=plot(T.dt,T.dinomax,'k-','Linewidth',.5,'marker','none'); hold on;
        hm=plot(T.dt,T.dinoML_microscopy,'^','color',c(1,:),'markerfacecolor',c(1,:),'Linewidth',.8,'markersize',4); hold on;        
        set(gca,'xgrid','on','tickdir','out',...
            'xticklabel',{},'ylim',[0 ymax],'fontsize',10,'ycolor','k');         
        ylabel('cells/mL','fontsize',11);   

    yyaxis right
        ht=plot(T.dt,T.DST,'*','color',c(2,:),'Linewidth',.8,'markersize',4); hold on;
        hline(16,'k:'); hold on;        
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime([char(yrlist(j)) '-05-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 30],'ytick',0:15:30,'fontsize',10,'ycolor',c(2,:)); 
        ylabel({'DST µg/100g'},'fontsize',11);           

end
datetick('x', 'mmm', 'keeplimits');            
lh=legend([ha hd hm],'IFCB','no IFCB data','microscopy','location','nw');  hp=get(lh,'pos');
     lh.Position=[hp(1)-.03 hp(2)+.02 hp(3) hp(4)]; hold on    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_cells_toxicity_BI.png'],'Resolution',100)    
hold off

%% Dinophysis vs Mesodinium
%fl=retime(fli,'regular','mean','TimeStep',hours(1));
Tc=retime(Tc,'hourly','mean');

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

        hd=plot(T.dt,T.dinomax,'-k','Linewidth',.5); hold on;
        hm=plot(T.dt,T.mesomax,'-r','Linewidth',.5,'markersize',4); hold on;        
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime([char(yrlist(j)) '-05-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 ymax],'fontsize',10,'ycolor','k');         
        ylabel('cells/mL','fontsize',11);   

end
datetick('x', 'mmm', 'keeplimits');            
lh=legend([hd hm hn],'Dinophysis','Mesodinium','no IFCB data','location','nw');  hp=get(lh,'pos');
    lh.Position=[hp(1)-.02 hp(2)+.6 hp(3) hp(4)]; hold on    

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_Mesodinium_BI.png'],'Resolution',100)    
hold off