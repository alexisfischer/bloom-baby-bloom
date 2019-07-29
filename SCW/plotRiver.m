%% Plot river discharge and nitrate 2018
%  Alexis D. Fischer, University of California - Santa Cruz, June 2019
clear;
filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Wind_MB'],'w');

%%
figure('Units','inches','Position',[1 1 8 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.07 0.04], [0.12 0.1]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%xax1=datenum('2018-03-10'); xax2=datenum('2018-03-31'); xtick=(xax1+2:2:xax2);
%'xtick',xtick,'xticklabel',datestr(xtick,'dd-m'),

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');
%xax1=datenum('2018-10-01'); xax2=datenum('2018-12-31');

yyaxis left
    plot(SC.dn,SC.sanlorR,'-k','linewidth',2);
    set(gca,'xgrid','on','ylim',[0 1500],'ytick',500:500:1500,'XLim',[xax1;xax2],...
       'fontsize',14,'tickdir','out','ycolor','k'); 
    ylabel({'Discharge (ft^3 s^{-1})'},'fontsize',14,'fontweight','bold');
    datetick('x','m','keeplimits');       
    hold on  
yyaxis right
    plot(SC.dn,SC.nitrate,'*b','linewidth',2);
    set(gca,'xgrid','on','XLim',[xax1;xax2],...
        'ylim',[0 15],'fontsize',14,'tickdir','out','ycolor','b'); 
    ylabel({'Nitrate (uM)'},'fontsize',16,'fontweight','bold');
    hold on   

    %% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/River_Nitrate_2018.tif']);
hold off   

%%
figure('Units','inches','Position',[1 1 8 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.07 0.04], [0.12 0.1]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');
%xax1=datenum('2018-10-01'); xax2=datenum('2018-12-31');

subplot(2,1,1)
yyaxis left
    plot(SC.dn,SC.sanlorR,'-k','linewidth',2);
    set(gca,'xgrid','on','ylim',[0 1500],'ytick',500:500:1500,'XLim',[xax1;xax2],...
       'fontsize',14,'tickdir','out','ycolor','k'); 
    ylabel({'Discharge (ft^3 s^{-1})'},'fontsize',14,'fontweight','bold');
    datetick('x','m','keeplimits');       
    hold on  
yyaxis right
    plot(SC.dn,SC.nitrate,'*b','linewidth',2);
    set(gca,'xgrid','on','XLim',[xax1;xax2],'xticklabel',{},...
        'ylim',[0 15],'fontsize',14,'tickdir','out','ycolor','b'); 
    ylabel({'Nitrate (uM)'},'fontsize',16,'fontweight','bold');
    hold on 

 subplot(2,1,2) %regional upwelling
% col1=brewermap(3,'Greys');
     itime=find(w.s42.dn>=xax1 & w.s42.dn<=xax2);
     [time,v,~] = ts_aggregation(w.s42.dn(itime),w.s42.v(itime),1,'hour',@mean); 
     [~,u,~] = ts_aggregation(w.s42.dn(itime),w.s42.u(itime),1,'hour',@mean); 

    [vfilt,df]=plfilt(v,time); [ufilt,df]=plfilt(u,time);        
    [up,across]=rotate_current(ufilt,vfilt,44); 
    upp = interp1babygap(up,24); 
    [DF,UP,~] = ts_aggregation(df,upp,1,'day',@mean); 

    h1=plot(DF,UP,'-','Color','k','linewidth',2); 
    hold on
    xL = get(gca, 'XLim');
    plot(xL, [0 0], 'k--')      
    set(gca,'xlim',[xax1 xax2],'ylim',[-11 10],'ytick',-7:7:7,'fontsize',14,'tickdir','out');    
    datetick('x','m','keeplimits');   
    ylabel('Alongshore wind (m s^{-1})','fontsize',16,'fontweight','bold');
    hold on    

    %set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/River_Nitrate_Upwell_2018.tif']);
hold off   

