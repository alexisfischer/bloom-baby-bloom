%% plot continuous Budd Inlet data
clear
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
% addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
% addpath(genpath(filepath));
% addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

filepath = 'C:\Users\alexis.fischer\OneDrive - SePRO Corporation\Documents\MATLAB\bloom-baby-bloom\BuddInlet\';
addpath(genpath('C:\Users\alexis.fischer\OneDrive - SePRO Corporation\Documents\MATLAB\'));

yr='2023'; % '2023'
load([filepath 'Data/BuddInlet_data_summary'],'T','fli');
load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');
load([filepath 'Data/BI_Precipitation'],'P');

% only select data from year of interest
T(~(T.dt.Year==str2double(yr)),:)=[];
% T(~(T.dt.Month==6),:)=[];
% nanmean(T.NH3_avg)
% nanstd(T.NH3_avg)

%%% find median concentration on max bloom concentration
% fli(~(fli.dt.Year==str2double(yr)),:)=[];
% [val,idx]=max(fli.dino)
% idx2=find(T.dt==dateshift(fli.dt(idx),'start', 'day'));
% T.dino_fl(idx2)

idx=find(T.dt==datetime('09-Jul-2023')); T.mesoLarge_fl(idx)=T.mesoLarge_fl(idx)+17;
T.t1=(smoothdata(T.t1,'movmean',3,'omitnan'));
T.s1=(smoothdata(T.s1,'movmean',3,'omitnan'));

%T.dt(find(T.t1>16,1))

figure('Units','inches','Position',[1 1 2.4 4.4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.04 0.09], [0.19 0.05]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];
c=(brewermap(7,'Paired'));

subplot(5,1,1);
    if strcmp(yr,'2022')
        M=T; %already daily average       
        b=bar(M.dt,[M.mesoLarge_fl,M.mesoSmall_sc],'stacked','FaceColor','flat','barwidth',.7,'EdgeColor','none');hold on; 
        M.meso=sum([M.mesoLarge_fl,M.mesoSmall_sc],2);
    elseif strcmp(yr,'2023')
        M=T;
        %M=retime(T,T.dt(1):days(5):T.dt(end),'mean');        
        b=bar(M.dt,[M.mesoLarge_fl,M.mesoSmall_fl],'stacked','FaceColor','flat','barwidth',.7,'EdgeColor','none');hold on;
        M.meso=sum([M.mesoLarge_fl,M.mesoSmall_fl],2);        
    end  
    b(1).FaceColor = c(6,:);
    b(2).FaceColor = c(7,:);   

    idx=find(isnan(M.meso));
    plot(M.dt(idx),.1*ones(size(idx)),'|','markersize',2,'linewidth',1,'color','k','markerfacecolor','k'); hold on;                    
    set(gca,'xaxislocation','top','tickdir','out','xlim',xax,'ylim',[0 10],...
        'ytick',0:5:10,'fontsize',8);
    ylabel({'\itMesodinium';'\rmcells/mL'},'fontsize',9); hold on;     
    datetick('x', 'm', 'keeplimits');               
    title(yr,'fontsize', 10)   

subplot(5,1,2);
plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
hline(3,'k--'); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize', 8,'tickdir','out','ycolor','k','xticklabel',{});  
    ylabel({'\itDinophysis';'\rmcells/mL'},'fontsize',9); hold on;  

    % add black lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl));
    plot(T.dt(idx),.1*ones(size(idx)),'|','markersize',2,'linewidth',1,'color','k','markerfacecolor','k'); hold on;              
    
subplot(5,1,3)
plot(T.dt,T.t1,'-k','linewidth',1); hold on;
hline(15,'k--'); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[9 23],...
        'fontsize', 8,'xticklabel',{},'tickdir','out','ycolor','k');   
    ylabel('^oC','fontsize',9,'color','k'); hold on;

subplot(5,1,4)
plot(T.dt,T.s1,'-k','linewidth',1); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[20 33],...
        'fontsize', 8,'tickdir','out','xticklabel',{},'ycolor','k');   
    ylabel('ppt','fontsize',9,'color','k'); hold on;
    dtt=datetime('10-Jul-2022'):1:datetime('30-Jul-2022');
  %  plot(dtt,32.5*ones(size(dtt)),'m-','linewidth',1.5); hold on;                    
    
% yyaxis right
% plot(P.dt,P.PRCP,':b','linewidth',1); hold on;
%     set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
%         'fontsize', 8,'tickdir','out','xticklabel',{},'ycolor','b');   
%     ylabel({'Precip. (cm)'},'fontsize',9,'color','b'); hold on;

% ax(1)=subplot(6,1,5); %sigma-t
% [X,Y,ST] = griddata4pcolor([B.dn]',[B(1).z]',[B.sigmat]',7);
% X=datetime(X,'convertfrom','datenum');
% 
% pcolor(X,Y,ST);  shading flat;  cax=[2 23]; clim(cax);
% set(gca,'xticklabel',{},'YDir','reverse','xlim',[xax(1) xax(2)],...
%     'ylim',[0 2],'ytick',0:1:2,'fontsize', 8,'tickdir','out');
%     ylabel('depth (m)', 'fontsize', 9); hold on
%     color=(brewermap([],'YlGnBu')); colormap(ax(1),color);  
%     h=colorbar('east','AxisLocation','out');
%     hp=get(h,'pos'); h.Position = [hp(1)+.11 hp(2)*.95 .5*hp(3) .9*hp(4)];     
%     h.TickDirection = 'out'; h.FontSize = 7; h.Label.String = 'Sigma-t';     
%     h.Label.FontSize = 8; h.Ticks=5:15:20; h.TickDirection = 'out'; hold on   
% 
%    plot(dt,[B.Zp],'w*','markersize',3); hold on;
% %   legend(h1(3),'Z_p','location','Southeast');   

subplot(5,1,5)
c=(brewermap(3,'Blues'));
h1=plot(T.dt(~isnan(T.NH3_avg)),T.NH3_avg(~isnan(T.NH3_avg)),'o-','Markersize',2,'linewidth',1,'color',c(2,:)); hold on;
h2=plot(T.dt(~isnan(T.NO3_avg)),T.NO3_avg(~isnan(T.NO3_avg)),'o-','Markersize',2,'linewidth',1,'color',c(3,:)); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 23],'fontsize',8,'tickdir','out','ycolor','k');   
    ylabel('\muM','fontsize',9,'color','k'); hold on;
    % lh=legend([h1 h2],'NH_3','NO_3','Location','East');
    % lh.FontSize = 8; hp=get(lh,'pos');
    % lh.Position=[hp(1)+.26 hp(2) hp(3) hp(4)]; legend boxoff; hold on  
    datetick('x', 'm', 'keeplimits');           
    
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_overview_v3_' yr '.png'],'Resolution',300)    
hold off

%% just freshening event
figure('Units','inches','Position',[1 1 2.4 4.4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.04 0.09], [0.19 0.05]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-07-01']) datetime(['' yr '-8-05'])];
%xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];
c=(brewermap(7,'Paired'));

subplot(5,1,1);
    if strcmp(yr,'2022')
        M=T; %already daily average       
        b=bar(M.dt,[M.mesoLarge_fl,M.mesoSmall_sc],'stacked','FaceColor','flat','barwidth',.7,'EdgeColor','none');hold on; 
        M.meso=sum([M.mesoLarge_fl,M.mesoSmall_sc],2);
    elseif strcmp(yr,'2023')
        M=T;
        %M=retime(T,T.dt(1):days(5):T.dt(end),'mean');        
        b=bar(M.dt,[M.mesoLarge_fl,M.mesoSmall_fl],'stacked','FaceColor','flat','barwidth',.7,'EdgeColor','none');hold on;
        M.meso=sum([M.mesoLarge_fl,M.mesoSmall_fl],2);        
    end  
    b(1).FaceColor = c(6,:);
    b(2).FaceColor = c(7,:);   

    idx=find(isnan(M.meso));
    plot(M.dt(idx),.1*ones(size(idx)),'|','markersize',2,'linewidth',1,'color','k','markerfacecolor','k'); hold on;                    
    set(gca,'xaxislocation','top','tickdir','out','xlim',xax,'ylim',[0 10],...
        'ytick',0:5:10,'fontsize',8);
    ylabel({'\itMesodinium';'\rmcells/mL'},'fontsize',9); hold on;     
    datetick('x', 'dd', 'keeplimits');               
    title(yr,'fontsize', 10)   

subplot(5,1,2);
plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
hline(3,'k--'); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize', 8,'tickdir','out','ycolor','k','xticklabel',{});  
    ylabel({'\itDinophysis';'\rmcells/mL'},'fontsize',9); hold on;  

    % add black lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl));
    plot(T.dt(idx),.1*ones(size(idx)),'|','markersize',2,'linewidth',1,'color','k','markerfacecolor','k'); hold on;              
    
subplot(5,1,3)
plot(T.dt,T.t1,'-k','linewidth',1); hold on;
hline(15,'k--'); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[9 23],...
        'fontsize', 8,'xticklabel',{},'tickdir','out','ycolor','k');   
    ylabel('^oC','fontsize',9,'color','k'); hold on;

subplot(5,1,4)
plot(T.dt,T.s1,'-k','linewidth',1); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[20 33],...
        'fontsize', 8,'tickdir','out','xticklabel',{},'ycolor','k');   
    ylabel('ppt','fontsize',9,'color','k'); hold on;
    dtt=datetime('10-Jul-2022'):1:datetime('30-Jul-2022');
  %  plot(dtt,32.5*ones(size(dtt)),'m-','linewidth',1.5); hold on;                    

ax(1)=subplot(5,1,5); %sigma-t
[X,Y,ST] = griddata4pcolor([B.dn]',[B(1).z]',[B.sigmat]',2);
X=datetime(X,'convertfrom','datenum');

pcolor(X,Y,ST);  shading flat;  cax=[2 23]; clim(cax);
set(gca,'xticklabel',{},'YDir','reverse','xlim',[xax(1) xax(2)],...
    'ylim',[0 2],'ytick',0:1:2,'fontsize', 8,'tickdir','out');
    ylabel('depth (m)', 'fontsize', 9); hold on
    color=(brewermap([],'YlGnBu')); colormap(ax(1),color);  
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); h.Position = [hp(1)+.11 hp(2)*.95 .5*hp(3) .9*hp(4)];     
    h.TickDirection = 'out'; h.FontSize = 7; h.Label.String = 'Sigma-t';     
    h.Label.FontSize = 8; h.Ticks=5:15:20; h.TickDirection = 'out'; hold on   

   plot(dt,[B.Zp],'w*','markersize',3); hold on;
%   legend(h1(3),'Z_p','location','Southeast');   
     datetick('x', 'dd', 'keeplimits');           

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_overview_subset_' yr '.png'],'Resolution',300)    
hold off

