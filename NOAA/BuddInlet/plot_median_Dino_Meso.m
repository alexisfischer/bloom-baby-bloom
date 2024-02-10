%% plot Dinophysis median and percentiles  daily box and whisker plot
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T','fli','dmatrix','ymatrix');
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   

%%%% plot Mesodinium 25-50-75 percentile
class2do_string='Mesodinium'; ymax=8;
[~,label]=get_class_ind(class2do_string,'all',class_indices_path);

med=retime(fli,'daily','median'); mea=retime(fli,'daily','mean');
idx=find(isnan(med.meso)); med(idx,:)=[]; mea(idx,:)=[];

figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

c=(brewermap(2,'Set2'));
yrlist={'2021';'2022';'2023'};
for j=1:length(yrlist)
    ax(j)=subplot(3,1,j);

    hf=plot(fli.dt,fli.meso,'.','color','k','markersize',4,'Linewidth',.5); hold on; %raw
    hm=plot(mea.dt,mea.meso,'-','Color',[16 48 82]./255,'Linewidth',1.5); hold on; %raw
    hd=plot(med.dt,med.meso,'-','Color',[65 173 213]./255,'Linewidth',1.5); hold on; %raw    

    ylabel('2021','fontsize',11);     
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime([char(yrlist(j)) '-04-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 ymax],'ytick',0:4:8,'fontsize',10,'ycolor','k','box','on');         
        ylabel(yrlist(j)','fontsize',11);  

end

set(gca,'Layer','top'); grid off;
ax(1).Title.String=[ char(label) ' cells/mL'];
datetick('x', 'mmm', 'keeplimits');            
lh=legend([hf hm hd],'raw IFCB','mean','median','location','nw');  hp=get(lh,'pos');
lh.Position=[hp(1)-.02 hp(2)+.6 hp(3) hp(4)]; hold on                

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Mesodinium_IFCB_fl_median.png'],'Resolution',100)    
hold off

%% plot Dinophysis 25-50-75 percentile
class2do_string='Dinophysis'; ymax=15;
[~,label]=get_class_ind(class2do_string,'all',class_indices_path);

P=prctile(ymatrix,[25 50 75],1);
x=dmatrix'; y1=P(1,:); y2=P(2,:); y3=P(3,:);

figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.08], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

c=(brewermap(2,'Set2'));
yrlist={'2021';'2022';'2023'};
for j=1:length(yrlist)
    ax(j)=subplot(3,1,j);

    hf=plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
    h27=patch([x fliplr(x)], [y1 fliplr(y3)],[65 173 213]./255,'Edgecolor',[76 134 162]./255,'Linewidth',1); hold on
    h50=plot(x,y2,'-','Color',[16 48 82]./255,'Linewidth',2); hold on;

    %deal with data gaps
    xx=datetime('15-Aug-2021'):1:datetime('18-Aug-2021');
    yy1=.05*ones(size(xx)); yy2=3*ones(size(xx));
    patch([xx fliplr(xx)], [yy1 fliplr(yy2)],'w','Edgecolor','none'); hold on

    %deal with data gaps
    xx=datetime('26-Jul-2022'):1:datetime('03-Aug-2022');
    yy1=.05*ones(size(xx)); yy2=5.5*ones(size(xx));
    patch([xx fliplr(xx)], [yy1 fliplr(yy2)],'w','Edgecolor','none'); hold on    

    %deal with data gaps
    xx=datetime('28-Sep-2022'):1:datetime('01-Oct-2022');
    yy1=.05*ones(size(xx)); yy2=3*ones(size(xx));
    patch([xx fliplr(xx)], [yy1 fliplr(yy2)],'w','Edgecolor','none'); hold on        

    %deal with data gaps
    xx=datetime('24-Jun-2023'):1:datetime('27-Jun-2023');
    yy1=.05*ones(size(xx)); yy2=3*ones(size(xx));
    patch([xx fliplr(xx)], [yy1 fliplr(yy2)],'w','Edgecolor','none'); hold on        
    
    hm=plot(T.dt,T.dinoML_microscopy,'r^','markerfacecolor','r','Linewidth',.8,'markersize',4); hold on;            
    ylabel('2021','fontsize',11);     
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime([char(yrlist(j)) '-04-01']) datetime([char(yrlist(j)) '-10-01'])],...
            'xticklabel',{},'ylim',[0 ymax],'fontsize',10,'ycolor','k','box','on');         
        ylabel(yrlist(j)','fontsize',11);  
set(gca,'Layer','top'); grid off;        
end

set(gca,'Layer','top'); grid off;
ax(1).Title.String=[ char(label) ' cells/mL'];
datetick('x', 'mmm', 'keeplimits');            
lh=legend([hf h50 h27 hm],'raw IFCB','median','25-75%','microscopy','location','nw');  hp=get(lh,'pos');
lh.Position=[hp(1)-.02 hp(2)+.6 hp(3) hp(4)]; hold on            

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_IFCB_fl_microscopy_25-50-75_percentile.png'],'Resolution',100)    
hold off


