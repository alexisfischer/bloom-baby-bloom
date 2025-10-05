%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2022'; % '2023'
load([filepath 'Data/BuddInlet_data_summary'],'T','fli');
%fli=retime(fli,'hourly','mean');

% only select data from year of interest
T(~(T.dt.Year==str2double(yr)),:)=[];
%T((T.dt.Month<=5),:)=[];
%nanmean(T.Urea_avg)
%nanstd(T.Urea_avg)
idx=find(T.dt==datetime('09-Jul-2023')); T.mesoLarge_fl(idx)=T.mesoLarge_fl(idx)+17;

T.t1=(smoothdata(T.t1,'movmean',3,'omitnan'));
T.s1=(smoothdata(T.s1,'movmean',3,'omitnan'));

T.dt(find(T.t1>15),1)

figure('Units','inches','Position',[1 1 3.2 4.8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.04 0.08], [0.19 0.23]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];
c=(brewermap(7,'Paired'));

subplot(5,1,1);
h=plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
    set(gca,'xaxislocation','top','xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize', 8,'tickdir','out','ycolor','k');  
    ylabel({'\itDinophysis';'\rm(cells/mL)'},'fontsize',9); hold on;  
    datetick('x', 'm', 'keeplimits');               
    title(yr,'fontsize', 10)   

    % add black lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl));
    plot(T.dt(idx),.1*ones(size(idx)),'s','markersize',2,'linewidth',.5,'color','k','markerfacecolor','k'); hold on;              

subplot(5,1,2);
    if strcmp(yr,'2022')
        M=T; %already daily average       
        b=bar(M.dt,[M.mesoLarge_fl,M.mesoSmall_sc],'stacked','FaceColor','flat','barwidth',1,'EdgeColor','none');hold on; 
        M.meso=sum([M.mesoLarge_fl,M.mesoSmall_sc],2);
    elseif strcmp(yr,'2023')
        M=retime(T,T.dt(1):days(5):T.dt(end),'mean');        
        b=bar(M.dt,[M.mesoLarge_fl,M.mesoSmall_fl],'stacked','FaceColor','flat','barwidth',1,'EdgeColor','none');hold on;
        M.meso=sum([M.mesoLarge_fl,M.mesoSmall_fl],2);        
    end  
    b(1).FaceColor = c(6,:);
    b(2).FaceColor = c(7,:);   

    % add black lines to axis where no IFCB data 
    if strcmp(yr,'2022')
        M=retime(M,M.dt(1):days(2):M.dt(end),'mean');        
    end
    idx=find(isnan(M.meso));
    plot(M.dt(idx),.1*ones(size(idx)),'s','markersize',2,'linewidth',.5,'color','k','markerfacecolor','k'); hold on;                    
    set(gca,'tickdir','out','xticklabel',{},'xlim',xax,'ylim',[0 10],...
        'ytick',0:5:10,'fontsize',8);
    ylabel({'\itMesodinium';'\rm(cells/mL)'},'fontsize',9); hold on;           

subplot(5,1,3)
plot(T.dt,T.t1,'-k','linewidth',1); hold on;
hline(15,'k--'); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[9 23],...
        'fontsize', 8,'xticklabel',{},'tickdir','out','ycolor','k');   
    ylabel({'Temperature';'(^oC)'},'fontsize',9,'color','k'); hold on;

subplot(5,1,4)
plot(T.dt,T.s1,'-k','linewidth',1); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[20 33],...
        'fontsize', 8,'tickdir','out','xticklabel',{},'ycolor','k');   
    ylabel({'Salinity';'(ppt)'},'fontsize',9,'color','k'); hold on;

subplot(5,1,5)
c=(brewermap(3,'Blues'));
h1=plot(T.dt(~isnan(T.NH3_avg)),T.NH3_avg(~isnan(T.NH3_avg)),'o-','Markersize',2,'linewidth',1,'color',c(2,:)); hold on;
h2=plot(T.dt(~isnan(T.NO3_avg)),T.NO3_avg(~isnan(T.NO3_avg)),'o-','Markersize',2,'linewidth',1,'color',c(3,:)); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 23],'fontsize',8,'tickdir','out','ycolor','k');   
    ylabel({'Nitrogen';'(\muM)'},'fontsize',9,'color','k'); hold on;
    lh=legend([h1 h2],'NH_3','NO_3','Location','East');
    lh.FontSize = 8; hp=get(lh,'pos');
    lh.Position=[hp(1)+.26 hp(2) hp(3) hp(4)]; legend boxoff; hold on  
    datetick('x', 'm', 'keeplimits');           
    
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_overview_v2_' yr '.png'],'Resolution',300)    
hold off


