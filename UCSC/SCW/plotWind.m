clear;
filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/Wind_MB'],'w');

%year=(2003:2018)';
year=[(2003:2016),2018]';

% find regional upwelling winds
for i=1:length(year)
        
    xax1=datenum([num2str(year(i)) '-01-01']); xax2=datenum([num2str(year(i)) '-05-31']);     
    itime=find(w.s42.dn>=xax1 & w.s42.dn<=xax2);

    %find hourly average
    [dn,v,~] = ts_aggregation(w.s42.dn(itime),w.s42.v(itime),1,'hour',@mean); 
    [~,u,~] = ts_aggregation(w.s42.dn(itime),w.s42.u(itime),1,'hour',@mean);
  
    vv=pl33tn(v,1,36); uu=pl33tn(u,1,36); %36 hr filter    
    vfilt=pl33tn(vv,1,36); ufilt=pl33tn(uu,1,36); %36 hr filter    
    
    [up,~]=rotate_current(ufilt,vfilt,35); %rotate 44º to reflect coastline
    upp = interp1babygap(up,24); 
    [DN,UP,~] = ts_aggregation(dn,upp,1,'day',@mean); 

    clearvars xax1 xax2 v u vfilt ufilt up upp itime
    
    % find length of upwelling periods (winds exceed 5 m/s equatorward)
    idUP=(UP<-5); trUP=diff(idUP); 
    to_up=find(trUP==1); end_up=find(trUP==-1);
    if end_up(1) < to_up(1)
        end_up(1)=[];
    end
    maxlen = max(length(to_up), length(end_up));
    to_up(end+1:maxlen) = length(DN); end_up(end+1:maxlen) = length(DN);    
    dn0_up=DN(to_up);
    upwell_dur=zeros*dn0_up;
    for j=1:length(to_up)
        upwell_dur(j)=end_up(j)-to_up(j);
    end        
    
    % find length of relaxation periods (winds exceed 0 m/s poleward) 
    idRE=(UP>=-1); trRE=diff(idRE);     
    to_relax=find(trRE==1); end_relax=find(trRE==-1);    
    if end_relax(1) < to_relax(1)
        end_relax(1)=[];
    end    
    maxlen = max(length(to_relax), length(end_relax));
    to_relax(end+1:maxlen) = length(DN); end_relax(end+1:maxlen) = length(DN);
    
    dn0_up=DN(to_relax);
    relax_dur=zeros*dn0_up;
    for j=1:length(to_relax)
        relax_dur(j)=end_relax(j)-to_relax(j);
    end

    Z(i).year=year(i);
    Z(i).datadays=sum(~isnan(UP));
    Z(i).totalUPdays=nansum(upwell_dur);
    Z(i).UPevents=length(upwell_dur);    
    
    Z(i).totalREdays=nansum(relax_dur);
    Z(i).REevents=length(relax_dur);   

    Z(i).UP2REdays=Z(i).totalUPdays./Z(i).totalREdays;
    Z(i).UP2REevents=Z(i).UPevents./Z(i).REevents;
    Z(i).upwell_dur=upwell_dur;      
    Z(i).relax_dur=relax_dur;  
    
end  
    
%    Z(i).fx=round(Z(i).totalupdays./Z(i).totaldays,2);

%    Z(i).upwell2events2=round(Z(i).totalupdays./Z(i).events,2);
%    Z(i).upwell_dur=upwell_dur;  
    
%    clearvars upwell_dur up_to_relax trans to_up maxlen j dn0_up dn UP idx DN
    
%end

%%
save([filepath 'Data/Upwell5ms'],'UU','U');
save([filepath 'Data/UpwellRelax'],'Z');


%%
figure; plot(DN,UP,'-','Color','k','linewidth',2); hold on
    xL = get(gca, 'XLim'); plot(xL, [0 0], 'k--'); datetick('x','m')    

%% plot 2018 SCW, M1
figure('Units','inches','Position',[1 1 8 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.06 0.12], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('2005-01-01'); xax2=datenum('2018-12-31');
    
subplot(2,1,1); %M1
    [uu,dnn]=plfilt(w.M1.v,w.M1.dn);
    [time,u,~] = ts_aggregation(dnn,uu,4,'day',@mean);
        
    plot(time,u,'-','linewidth',1);  
    ylabel('M1','fontsize',14); 
    title('Alongshore wind (m s^{-1})','fontsize',16);
    datetick('x','yyyy','keeplimits');   
    set(gca,'xlim',[xax1 xax2],'xgrid', 'on','ylim',[-4 6],'ytick',-4:4:6,'xaxislocation','top');   
    hold on
    clearvars time u
    
subplot(2,1,2); %SCW
    [uu,dnn]=plfilt(w.scw.u,w.scw.dn);    
    [time,u,~] = ts_aggregation(dnn,uu,4,'day',@mean);  
    
    plot(time,u,'-','linewidth',1);  
    ylabel('SCMW','fontsize',14); 
    datetick('x','yyyy','keeplimits');   
    set(gca,'xgrid', 'on','xlim',[xax1 xax2],'ylim',[-1 2.5],'ytick',-1:1:3);
    hold on    

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\wind_M1_SCW.tif']);
hold off

%% plots 2012-2018 Wind for SCW
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[U,~]=plfilt(w.scw.u, w.scw.dn);
[V,DN]=plfilt(w.scw.v, w.scw.dn);
[~,u,~] = ts_aggregation(DN,U,1,'8hour',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'8hour',@mean);
    
yr=[2012:2018]';    
for i=1:length(yr)
    subplot(length(yr),1,i)      
    xax1=datenum(['' num2str(yr(i)) '-01-01']);
    xax2=datenum(['' num2str(yr(i)) '-12-31']);
    yax1=-5; yax2=5;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    legend(['' num2str(yr(i)) ''],'Location','NW'); legend boxoff
    hold on  
end

set(gca,'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01'),datenum('2018-08-01'),...
    datenum('2018-09-01'),datenum('2018-10-01'),datenum('2018-11-01'),...
    datenum('2018-12-01')],'Xticklabel',{'Jan','Feb','Mar','Apr','May',...
    'Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'tickdir','out','fontsize',10);  
   
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\Wind_SCW_2012_2018.tif']);
hold off        


%% plots 2002-2018 Wind for 46042
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

    [U,~]=plfilt(w.s42.u, w.s42.dn);
    [V,DN]=plfilt(w.s42.v, w.s42.dn);
    [~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
    
yr=(2001:2018)';    
for i=1:length(yr)
    subplot(length(yr),1,i)      
    xax1=datenum(['' num2str(yr(i)) '-01-01']);
    xax2=datenum(['' num2str(yr(i)) '-12-31']);
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    datetick('x','mmm','keeplimits');       
    set(gca,'tickdir','out','xticklabels',{},'fontsize',10);  
    legend(['' num2str(yr(i)) ''],'Location','NW'); legend boxoff
    hold on  
end

    datetick('x','mmm','keeplimits');       
   
%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Wind_46042_2011_2018.tif']);
hold off        

%% plots 2012-2018 Wind for M1
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

    [U,~]=plfilt(w.M1.u, w.M1.dn);
    [V,DN]=plfilt(w.M1.v, w.M1.dn);
    [~,u,~] = ts_aggregation(DN,U,12,'hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,12,'hour',@mean);
    
yr=[2012:2018]';    
for i=1:length(yr)
    subplot(length(yr),1,i)      
    xax1=datenum(['' num2str(yr(i)) '-01-01']);
    xax2=datenum(['' num2str(yr(i)) '-12-31']);
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    legend(['' num2str(yr(i)) ''],'Location','NW'); legend boxoff
    hold on  
end

set(gca,'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01'),datenum('2018-08-01'),...
    datenum('2018-09-01'),datenum('2018-10-01'),datenum('2018-11-01'),...
    datenum('2018-12-01')],'Xticklabel',{'Jan','Feb','Mar','Apr','May',...
    'Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'tickdir','out','fontsize',10);  
   
%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\Wind_M1_2012_2018.tif']);
hold off        

