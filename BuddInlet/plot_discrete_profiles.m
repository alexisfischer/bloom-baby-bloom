%% plot T Sal chl profiles in Budd Inlet
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/Misc-Functions/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));

%yr='2021';
%yr='2022';
yr='2023';

load([filepath 'Data/BuddInlet_data_summary'],'T');
load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');

%%%% plot line profiles
% select data for the year you want and May through October
%yr='2021-2023';
idx=(dt.Year==str2double(yr)); data=[B(:,idx)]; dt=dt(idx);
idx=find(dt.Month>=5 & dt.Month<=10); data=[data(:,idx)]; dt=dt(idx);
%idx=find(dt.Month==5); data=[data(:,idx)]; dt=dt(idx);

figure('Units','inches','Position',[1 1 7 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.04 0.1], [0.06 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

col=flipud(brewermap(length(data),'Set1')); 

subplot(1,5,1);
for i=1:length(data)
    idx = ~isnan(data(i).fl);    
    h(i)=plot(data(i).fl(idx),data(i).z(idx),'-','Color',col(i,:),'linewidth',1); hold on
end
h=plot(mean([data.fl],2,'omitnan'),[data(1).z],'k--','linewidth',2);
set(gca,'ylim',[0 6],'xlim',[0 10],'Ydir','reverse','xaxislocation','top','fontsize',10,'Tickdir','out');
xlabel('Chl (rfu)','fontsize',12);
ylabel('depth (m)','fontsize',12);
legend(h,'mean','location','se')

subplot(1,5,2);
for i=1:length(data)
    idx = ~isnan(data(i).CT);    
    h(i)=plot(data(i).CT(idx),data(i).z(idx),'-','Color',col(i,:),'linewidth',1); hold on
end
set(gca,'ylim',[0 6],'xlim',[10 23],'Ydir','reverse','xaxislocation','top','yticklabel',{},'fontsize',10,'Tickdir','out');

xlabel('CT (^oC)','fontsize',12);

subplot(1,5,3);
for i=1:length(data)
    idx = ~isnan(data(i).SA);        
    h(i)=plot(data(i).SA(idx),data(i).z(idx),'-','Color',col(i,:),'linewidth',1); hold on
end
set(gca,'ylim',[0 6],'xlim',[0 33],'xtick',0:15:30,'Ydir','reverse','xaxislocation','top',...
    'yticklabel',{},'fontsize',10,'Tickdir','out');
xlabel('SA (ppt)','fontsize',12);

subplot(1,5,4);
for i=1:length(data)
    idx = ~isnan(data(i).sigmat);            
    h(i)=plot(data(i).sigmat(idx),data(i).z(idx),'-','Color',col(i,:),'linewidth',1); hold on
end
set(gca,'ylim',[0 6],'xlim',[0 24],'Ydir','reverse','xaxislocation','top',...
    'yticklabel',{},'fontsize',10,'Tickdir','out');
xlabel('sigma-t','fontsize',12);

subplot(1,5,5);
for i=1:length(data)
    idx = ~isnan(data(i).rho_m);            
    h(i)=plot(data(i).rho_m(idx),data(i).z(idx),'-','Color',col(i,:),'linewidth',1); hold on
    idx=find(data(i).z==data(i).Zp);
    plot(data(i).rho_m(idx),data(i).Zp,'k*'); hold on
end

set(gca,'ylim',[0 6],'xlim',[0 15],'Ydir','reverse','xaxislocation','top',...
    'yticklabel',{},'fontsize',10,'Tickdir','out');
xlabel('gradient (kg/m^4)','fontsize',12);

%char=datestr([data.dn]);
%legend(h,char(:,1:6),'location','SE','fontsize',10); legend boxoff;

%text(0,mean([data.Zm],'omitnan'),'Zm');
%text(0,mean([data.Zb],'omitnan'),'Zb');
%text(0,mean([data.Zp],'omitnan'),'Zp');

clearvars h data char

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Profiles_BI_' yr '.png'],'Resolution',100)    
hold off

%% mean sigmat profiles for each year
idx=find(dt.Month>=5 & dt.Month<=9); B=[B(:,idx)]; dt=dt(idx);

figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.04 0.12], [0.12 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

c=brewermap(3,'Set2');
yr={'2021','2022','2023'};

subplot(1,2,1)
n=yr;
for i=1:length(yr)
    data=[B(:,(dt.Year==str2double(yr(i))))];
    n(i)={num2str(length(data))};
    sigmat=mean([data.sigmat],2,'omitnan'); 
    s=std([data.sigmat],0,2,'omitnan');
    h(i)=plot(sigmat,data(1).z,'-','color',c(i,:),'linewidth',2); hold on
    plot(sigmat-s,data(1).z,':','color',c(i,:),'linewidth',1.2); hold on
    plot(sigmat+s,data(1).z,':','color',c(i,:),'linewidth',1.2); hold on
    Zp(i)=mean([data.Zp],'omitnan'); 
    hz=plot(sigmat(find(data(1).z>=Zp(i),1))-.4,Zp(i),'k*','linewidth',1,'markersize',4);
end
text(8.4,1.5,'IFCB','fontsize',11); hold on
set(gca,'ylim',[0 6],'xlim',[8 23],'Ydir','reverse','xaxislocation','top',...
    'fontsize',10,'Tickdir','out');
xlabel('sigma-t','fontsize',11);
ylabel('depth (m)','fontsize',11);

subplot(1,2,2)
for i=1:length(yr)
    data=[B(:,(dt.Year==str2double(yr(i))))];
    fl=mean([data.fl],2,'omitnan'); 
    s=std([data.fl],0,2,'omitnan'); 
    h(i)=plot(fl,data(1).z,'-','color',c(i,:),'linewidth',2); hold on
    plot(fl-s,data(1).z,':','color',c(i,:),'linewidth',1.2); hold on
    plot(fl+s,data(1).z,':','color',c(i,:),'linewidth',1.2); hold on
end
set(gca,'ylim',[0 6],'xlim',[0 15],'Ydir','reverse','xaxislocation','top',...
    'fontsize',10,'yticklabel',{},'Tickdir','out');
xlabel('Chl (rfu)','fontsize',11);
legend([h hz],['2021 (n=' char(n(1)) ')'],['2022 (n=' char(n(2)) ')'],...
    ['2023 (n=' char(n(3)) ')'],'Zp','location','south'); legend boxoff;
mean(Zp) %mean of Zp

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/SigmaT_Profiles_BI.png'],'Resolution',100)    
hold off

%% plot pcolor profiles
%grid data for plotting
[~,~,Temp] = griddata4pcolor([B.dn]',[B(1).z]',[B.CT]',7);
[~,~,Sal] = griddata4pcolor([B.dn]',[B(1).z]',[B.SA]',7);
[X,Y,ST] = griddata4pcolor([B.dn]',[B(1).z]',[B.sigmat]',7);

X=datetime(X,'convertfrom','datenum');

figure('Units','inches','Position',[1 1 5 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.06 0.09], [0.12 0.14]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime([yr '-05-01']) datetime([yr '-10-01'])];

subplot(4,1,1)
yyaxis left
    plot(T.dt,T.sigmat_diff,'k-'); hold on
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[-5 8],'xaxislocation','top','fontsize',10,'ycolor','k'); 
    ylabel('rho index','fontsize',11)
yyaxis right
plot(dt,[B.N],'r*'); hold on
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 .08],'ytick',0:.04:.08,...
        'ycolor','r','xaxislocation','top','fontsize',10); 
ylabel('max buoy. freq.','fontsize',11)

ax(2)=subplot(4,1,2); %sigma-t
pcolor(X,Y,ST);  shading flat;  cax=[2 23]; clim(cax);
set(gca,'xticklabel',{},'YDir','reverse','xlim',[xax(1) xax(2)],...
    'ylim',[0 6],'ytick',0:3:6,'fontsize', 10,'tickdir','out');
    ylabel('depth (m)', 'fontsize', 11); hold on
    color=(brewermap([],'Purples')); colormap(ax(2),color);  
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); h.Position = [hp(1)*1.1 hp(2) .5*hp(3) hp(4)];     
    h.TickDirection = 'out'; h.FontSize = 10; h.Label.String = 'Sigma-t';     
    h.Label.FontSize = 11;% h.Ticks=linspace(cax(1),cax(2),3); hold on   

    h1=plot(dt,[B.Zm],'w^',dt,[B.Zb],'wo',dt,[B.Zp],'r*','markersize',5); hold on;
  % legend(h1(3),'Z_p','location','Southeast');   

ax(3)=subplot(4,1,3); %temperature
pcolor(X,Y,Temp); cax=[5 25]; clim(cax); shading flat; 
set(gca,'YDir','reverse','xlim',[xax(1) xax(2)],...
    'ylim',[0 6],'ytick',0:3:6,'fontsize', 10,'xticklabel',{},'tickdir','out');
    ylabel('depth (m)', 'fontsize', 11); hold on
    color=(brewermap([],'YlOrBr')); colormap(ax(3),color);  
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); h.Position = [hp(1)*1.1 hp(2) .5*hp(3) hp(4)];    
    h.TickDirection = 'out'; h.FontSize = 10; h.Label.String = 'temp (^oC)';     
    h.Label.FontSize = 11; h.Ticks=linspace(cax(1),cax(2),3); hold on   

ax(4)=subplot(4,1,4); %salinity    
pcolor(X,Y,Sal); cax=[10 30]; clim(cax); shading flat; 
set(gca,'xaxislocation','bottom','YDir','reverse','xlim',[xax(1) xax(2)],...
    'ylim',[0 6],'ytick',0:3:6,'fontsize', 10,'tickdir','out');
    ylabel('depth (m)', 'fontsize', 11); hold on;
    color=(brewermap([],'YlGnBu')); colormap(ax(4),color);  
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); h.Position = [hp(1)*1.1 hp(2) .5*hp(3) hp(4)];    
    h.TickDirection = 'out'; h.FontSize = 10; h.Label.String = 'salinity (psu)';     
    h.Label.FontSize = 11; h.Ticks=linspace(cax(1),cax(2),3); hold on      

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/DensityProfiles_' yr '.png'],'Resolution',100)    
hold off



