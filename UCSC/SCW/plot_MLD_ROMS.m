%plot MLD from ROMS data

filepath='~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
%load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD'],'ROMS');
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS','CA','MB');

load([filepath 'Data/M1_TS'],'M1');
M1s=M1;
load([filepath 'Data/M1-46092/M1_CTD_TS'],'M1');

% import_CAROMS
% import_M1_CTD
% import_M1sensor

%% M1 SCW_ROMS comparison

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.06 0.04], [0.1 0.12]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('2010-10-01'); xax2=datenum('2019-01-01');     
  
ax1=subplot(6,1,1); %SCW ROMS Temp
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,jet);     
    caxis([10 16]); grid on; 
    hold on
    set(gca,'XLim',[xax1;xax2],'xaxislocation','top','Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');    
    datetick('x','yy','keeplimits');    
    ylabel({'ROMS';'Depth (m)'},'fontsize',10,'fontweight','bold');
    h=colorbar;
    h.FontSize = 8;
    h.Label.String = 'T (^oC)';     
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
    
ax1=subplot(6,1,2); %M1 Temp sensor
    X=[M1s.dn]';
    Y=[M1s(1).Zi]';
    C=[M1s.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,jet);     
    caxis([10 16]);  grid on; 
    hold on
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');
    datetick('x','yy','keeplimits');
    ylabel({'M1 sensor';'Depth (m)'},'fontsize',10,'fontweight','bold');
    h=colorbar;
    h.FontSize = 8;
    h.Label.String = 'T (^oC)';     
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on    

ax1=subplot(6,1,3); %M1 Temp CTD
    X=[M1.dn]';
    Y=[M1(1).Zi]';
    C=[M1.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,jet);     
    caxis([10 16]);  grid on; 
    hold on
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');
    datetick('x','yy','keeplimits');
    ylabel({'M1 CTD monthly';'Depth (m)'},'fontsize',10,'fontweight','bold');
    h=colorbar;
    h.FontSize = 8;
    h.Label.String = 'T (^oC)';     
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on    
    
ax2=subplot(6,1,4); %ROMS MLD
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi(1:end-1)]';
    C=[ROMS.dTdz];
    pcolor(X,Y,C); shading interp;
    colormap(ax2,jet);     
    caxis([0 0.2]); grid on; 
    hold on
    hh=plot(X,smooth([ROMS.Zmax],10),'w-','linewidth',2);
    hold on
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');
    datetick('x','yy','keeplimits');
    ylabel({'ROMS';'Depth (m)'},'fontsize',10,'fontweight','bold');
    h=colorbar;    
    h.Label.String = 'dT/dz (^oC m^{-1})';
    h.FontSize = 8;
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
    
ax2=subplot(6,1,5); %M1 sensor MLD
    X=[M1s.dn]';
    Y=[M1s(1).Zi(1:end-1)]';
    C=[M1s.dTdz];
    pcolor(X,Y,C); shading interp;
    colormap(ax2,jet);     
    caxis([0 0.2]); datetick('x','mmm','keeplimits');  grid on; 
    hold on
    hh=plot(X,smooth([M1s.Zmax],10),'w-','linewidth',2);
    hold on
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');
    ylabel({'M1 sensor';'Depth (m)'},'fontsize',10,'fontweight','bold');
    datetick('x','yy','keeplimits')
    h=colorbar;    
    h.Label.String = 'dT/dz (^oC m^{-1})';
    h.FontSize = 8;
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on    
    
ax2=subplot(6,1,6); %M1 CTD monthly MLD
    X=[M1.dn]';
    Y=[M1(1).Zi(1:end-1)]';
    C=[M1.dTdz];
    pcolor(X,Y,C); shading interp;
    colormap(ax2,jet);     
    caxis([0 0.2]); datetick('x','mmm','keeplimits');  grid on; 
    hold on
    hh=plot(X,smooth([M1.Zmax],10),'w-','linewidth',2);
    hold on
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'fontsize',9,'tickdir','out');
    ylabel({'M1 CTD monthly';'Depth (m)'},'fontsize',10,'fontweight','bold');
    datetick('x','yy','keeplimits')
    h=colorbar;    
    h.Label.String = 'dT/dz (^oC m^{-1})';
    h.FontSize = 8;
    h.Label.FontSize = 10;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on        

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/m1-OBS_scw-ROMS_2010-2018.tif']);
hold off

%% plot pcolor temperature profile and dT/dZ
figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
 subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.08 0.04], [0.09 0.06]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

xax1= datenum('01-Sep-2010');
xax2= datenum('01-Jan-2019');

yax1= 0;
yax2= ROMS(1).Zi(end);
    
ax1=subplot(2,1,1);  
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    colormap(ax1,parula);     
    caxis([10 16]); datetick('x','yyyy');  
    hold on
    set(gca,'Ydir','reverse','ylim',[yax1 yax2],'xlim',[xax1 xax2],...
        'ytick',yax1:yax2/2:yax2,'fontsize',10,'xticklabel',{},'tickdir','out');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    box on;
    h1=colorbar; 
    h1.FontSize = 10;
    h1.Label.String = 'T (^oC)'; 
    h1.Label.FontSize = 12;
    h1.Label.FontWeight = 'bold';
    h1.TickDirection = 'out';
    hold on
    
ax2=subplot(2,1,2);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi(1:end-1)]';
    C=[ROMS.dTdz];
    pcolor(X,Y,C); shading interp;    
    colormap(ax2,parula); 
    caxis([0 0.2]); datetick('x','yy');
    hold on
 %   plot(X,[ROMS.Zmax],'w-','linewidth',1.5);
    hold on
    set(gca,'Ydir','reverse','ylim',[yax1 yax2],...
            'xlim',[xax1 xax2],'ytick',yax1:yax2/2:yax2,'fontsize',10,'tickdir','out');    
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.Label.String = 'dTdz (^oC m^{-1})';
    h.FontSize = 10;
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on

%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/ROMS_CTD_SCW_Temp_dTdz.tif']);
hold off

%% plot pcolor temperature profile and delta T MLD 
figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
 subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.08 0.04], [0.09 0.06]);
% %subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
% %where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

xax1= datenum('01-Sep-2010');
xax2= datenum('01-Jan-2019');

% yax1= ROMS(1).Zi(1);
% yax2= ROMS(1).Zi(end);
yax1=0;
yax2=50;
    
ax1=subplot(2,1,1);   
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    colormap(ax1,parula);     
    pcolor(X,Y,C); shading interp;
    caxis([10 16]); datetick('x','yyyy');  
    hold on
    set(gca,'xticklabel',{},'Ydir','reverse','ylim',[yax1 yax2],...
            'xlim',[xax1 xax2],'ytick',yax1:yax2/2:yax2,'fontsize',10,'tickdir','out');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    box on;
    h1=colorbar; 
    h1.FontSize = 10;
    h1.Label.String = 'T (^oC)'; 
    h1.Label.FontSize = 12;
    h1.Label.FontWeight = 'bold';
    h1.TickDirection = 'out';
    hold on
    
ax2=subplot(2,1,2);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.diff];
    pcolor(X,Y,C); shading interp;
    colormap(ax2,(parula)); 
    caxis([0 0.5]); datetick('x','yyyy'); 
    hold on
    ii=~isnan([ROMS.mld5])';
    Y=smooth([ROMS(ii).mld5],20);
    plot(X(ii),Y,'k-','linewidth',2);
    hold on
    set(gca,'Ydir','reverse','ylim',[yax1 yax2],...
        'xlim',[xax1 xax2],'ytick',yax1:yax2/2:yax2,'fontsize',10,'tickdir','out');
    datetick('x','yyyy','keeplimits','keepticks');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    box on;
    h2=colorbar; 
   % h2.YDir='reverse';
    h2.Label.String = '\DeltaT from 0 m (^oC)';
    h2.FontSize = 10;
    h2.Label.FontSize = 12;
    h2.Label.FontWeight = 'bold';
    h2.TickDirection = 'out';
    hold on
%    legend([hh(1)],'\DeltaT = 0.5^oC','Location','SE');
        
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/ROMS_SCW_Temp_MLD_50m.tif']);
hold off

%% plot trendlines for strength of thermocline
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
 subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.04], [0.09 0.06]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

xax1= datenum('01-Jan-2000');
xax2= datenum('01-Oct-2018');
    
subplot(3,1,1);
plot([M1.dn],[M1.maxdTdzM],'-k','linewidth',1);
hold on
plot([M1.dn],[M1.maxdTdzS],'-r','linewidth',2);
    hold on
    datetick('x','yy');  
    set(gca,'xticklabel',{},'xlim',[xax1 xax2],'fontsize',10,'tickdir','out');
    ylabel('maximum dT/dZ  (^oC/m)');    
    hold on
    
subplot(3,1,2);  
plot([M1.dn],[M1.ZmaxM],'-k','linewidth',1);
hold on
plot([M1.dn],[M1.ZmaxS],'-g','linewidth',2);
    hold on
    datetick('x','yy');  
    hold on
    set(gca,'xticklabel',{},'xlim',[xax1 xax2],'ydir','reverse','fontsize',10,'tickdir','out');
    ylabel('dT/dZ Depth (m)');
    hold on    
    
subplot(3,1,3); 
plot([M1.dn],[M1.TmaxM],'-k','linewidth',1);
hold on
plot([M1.dn],[M1.TmaxS],'-b','linewidth',2);
    hold on
    datetick('x','yy');  
    hold on
    set(gca,'xlim',[xax1 xax2],'fontsize',10,'tickdir','out');
    ylabel('Temperature at dT/dZ  (^oC)');        
    hold on       

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/M1_thermocline_trend.tif']);
hold off