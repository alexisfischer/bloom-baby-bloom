%% plot T Sal chl profiles in Budd Inlet
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/Misc-Functions/')); % add new data to search path

load([filepath 'Data/BuddInlet_TSChl_profiles'],'B');
load([filepath 'Data/DinophysisMicroscopy'],'T');
load([filepath 'Data/BI_DSP'],'DSP');

for i=1:length(B) %interpolate gaps
    [B(i).temp_C] = interp1babygap(B(i).temp_C,10);
    [B(i).sal_psu] = interp1babygap(B(i).sal_psu,10);
    [B(i).chl_rfu] = interp1babygap(B(i).chl_rfu,10);    
end

%grid data for plotting
[~,~,Temp] = griddata4pcolor([B.dn]',[B(1).depth_m]',[B.temp_C]',7);
[~,~,Sal] = griddata4pcolor([B.dn]',[B(1).depth_m]',[B.sal_psu]',7);
[X,Y,C] = griddata4pcolor([B.dn]',[B(1).depth_m]',[B.chl_rfu]',7);
X=datetime(X,'convertfrom','datenum');

figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.07 0.07], [0.12 0.14]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime('2021-04-01') datetime('2022-10-01')];

subplot(4,1,1);
yyaxis left
plot(T.SampleDate,.001*T.DinophysisConcentrationcellsL,'ko-','MarkerSize',4);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xaxislocation','top','ylim',[0 15],'ytick',0:5:15,'xlim',[xax(1) xax(2)],...
        'fontsize', 11,'tickdir','out','ycolor','k');   
    ylabel({'Dinophysis';'(cells/mL)'},'fontsize',12,'color','k'); hold on;
yyaxis right
plot(DSP.dt,DSP.ug100g,'r*','MarkerSize',5);
    set(gca,'xaxislocation','top','ylim',[0 20],'ytick',0:10:20,'xlim',[xax(1) xax(2)],...
        'fontsize', 11,'tickdir','out','ycolor','r');   
    ylabel({'DSP';'(ug/100g)'},'fontsize',12,'color','r'); hold on;

ax(3)=subplot(4,1,2); %chl
pcolor(X,Y,C); cax=[0 10]; caxis(cax); shading flat; 
set(gca,'YDir','reverse','xlim',[xax(1) xax(2)],'xticklabel',{},...
    'ylim',[0 7],'ytick',0:2:8,'fontsize', 11,'tickdir','out');
    ylabel('depth (m)', 'fontsize', 12); hold on;
    color=(brewermap([],'YlGn')); colormap(ax(3),color);  
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); h.Position = [hp(1)*1.1 hp(2) .5*hp(3) hp(4)];    
    h.TickDirection = 'out'; h.FontSize = 11; h.Label.String = 'chl (rfu)';     
    h.Label.FontSize = 12; h.Ticks=linspace(cax(1),cax(2),3); hold on; 
    plot(T.SampleDate,T.SampleDepths,'k-'); hold on;
    
ax(1)=subplot(4,1,3); %temperature
pcolor(X,Y,Temp); cax=[5 25]; caxis(cax); shading flat; 
set(gca,'xaxislocation','top','YDir','reverse','xlim',[xax(1) xax(2)],...
    'ylim',[0 7],'ytick',0:2:8,'fontsize', 11,'xticklabel',{},'tickdir','out');
    ylabel('depth (m)', 'fontsize', 12); hold on
    color=(brewermap([],'YlOrBr')); colormap(ax(1),color);  
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); h.Position = [hp(1)*1.1 hp(2) .5*hp(3) hp(4)];    
    h.TickDirection = 'out'; h.FontSize = 11; h.Label.String = 'temp (^oC)';     
    h.Label.FontSize = 12; h.Ticks=linspace(cax(1),cax(2),3); hold on   

ax(2)=subplot(4,1,4); %salinity    
pcolor(X,Y,Sal); cax=[10 30]; caxis(cax); shading flat; 
    datetick('x', 'mmm', 'keeplimits');
set(gca,'YDir','reverse','xlim',[xax(1) xax(2)],...
    'ylim',[0 7],'ytick',0:2:8,'fontsize', 11,'tickdir','out');
    ylabel('depth (m)', 'fontsize', 12); hold on;
    color=(brewermap([],'YlGnBu')); colormap(ax(2),color);  
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); h.Position = [hp(1)*1.1 hp(2) .5*hp(3) hp(4)];    
    h.TickDirection = 'out'; h.FontSize = 11; h.Label.String = 'salinity (psu)';     
    h.Label.FontSize = 12; h.Ticks=linspace(cax(1),cax(2),3); hold on      

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dpng','-r300',[filepath 'Figs/BuddInlet_TSC_pcolor.tif']);
hold off   
        
%% plot profiles
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.06], [0.04 0.1], [0.08 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

col=flipud(brewermap(length(B),'Spectral'));  %col=parula(length(B));

subplot(1,3,1);
for i=1:length(B)
    idx = ~isnan(B(i).temp_C);    
    h(i)=plot(B(i).temp_C(idx),B(i).depth_m(idx),'-','Color',col(i,:),'linewidth',1.5); hold on
end
set(gca,'ylim',[0 7],'Ydir','reverse','xaxislocation','top','fontsize',10,'Tickdir','out');

xlabel('temp (^oC)','fontsize',12);
ylabel('depth (m)','fontsize',12);

subplot(1,3,2);
for i=1:length(B)
    idx = ~isnan(B(i).sal_psu);        
    h(i)=plot(B(i).sal_psu(idx),B(i).depth_m(idx),'-','Color',col(i,:),'linewidth',1.5); hold on
end
set(gca,'ylim',[0 7],'Ydir','reverse','xaxislocation','top',...
    'yticklabel',{},'fontsize',10,'Tickdir','out');
xlabel('sal (psu)','fontsize',12);

subplot(1,3,3);
for i=1:length(B)
    idx = ~isnan(B(i).chl_rfu);            
    h(i)=plot(B(i).chl_rfu(idx),B(i).depth_m(idx),'-','Color',col(i,:),'linewidth',1.5); hold on
end
set(gca,'ylim',[0 7],'Ydir','reverse','xaxislocation','top',...
    'yticklabel',{},'fontsize',10,'Tickdir','out');
xlabel('chl (rfu)','fontsize',12);
char=datestr([B.dn]);
legend(h,char(:,1:6),'location','E','fontsize',10); legend boxoff;
 
% % mean chl line
% chl=nanmean([B.chl_rfu],2); idx = ~isnan(chl);         
% plot(chl(idx),B(1).depth_m(idx),':k','linewidth',1.5); hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'Figs/BuddInlet_TSC.tif']);
hold off   
