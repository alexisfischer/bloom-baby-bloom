%plot MLD from ROMS data

%year=2017;
year=2018;
resultpath='~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
load([resultpath 'Data/ROMS/MB_temp_sal_' num2str(year) ''],'ROMS');

%% plot pcolor temperature profile and delta T MLD 
figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
 subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.08 0.04], [0.09 0.06]);
% %subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
% %where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

subplot(2,1,1);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    caxis([10 16]); datetick('x','m');  grid on; 
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))
    set(gca,'xticklabel',{},'Ydir','reverse','ylim',[0 40],'ytick',0:10:40,...
        'fontsize',10,'tickdir','out');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.FontSize = 10;
    h.Label.String = 'T (^oC)'; 
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
    
subplot(2,1,2);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.diff];
    pcolor(X,Y,C); shading interp;
    caxis([0 0.5]); datetick('x','m');  grid on; 
    hold on
    hh=plot(X,smooth([ROMS.mld5],20),'k-','linewidth',3);
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))    
    set(gca,'Ydir','reverse','ylim',[0 40],'ytick',0:10:40,'fontsize',10,'tickdir','out');
    datetick('x','m','keeplimits','keepticks');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.Label.String = '\DeltaT from 0m (^oC)';
    h.FontSize = 10;
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
    legend([hh(1)],'\DeltaT = 0.5^oC','Location','SE');
        
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs/ROMS_MB_Temp_MLD_' num2str(year) '.tif']);
hold off

%% plot pcolor temperature profile, delta T MLD  and dT/dZ
figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.08 0.04], [0.09 0.06]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

subplot(3,1,1);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];

    pcolor(X,Y,C); shading interp;
    caxis([10 16]); datetick('x','m');  grid on; 
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))
    set(gca,'xticklabel',{},'Ydir','reverse','ylim',[0 40],'ytick',0:20:40,'fontsize',10,'tickdir','out');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.FontSize = 10;
    h.Label.String = 'T (^oC)'; 
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on

subplot(3,1,2);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi(1:40)]';
    C=[ROMS.dTdz];
    pcolor(X,Y,C); shading interp;
    caxis([0 0.2]); datetick('x','m');  grid on; 
    hold on
    plot(X,smooth([ROMS.Zmax],20),'w-','linewidth',3);
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))    
    set(gca,'Ydir','reverse','ylim',[0 40],'ytick',0:20:40,'fontsize',10,...
        'xticklabel',{},'tickdir','out');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.Label.String = 'dTdz (^oC m^{-1})';
    h.FontSize = 10;
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on

subplot(3,1,3);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.diff];
    pcolor(X,Y,C); shading interp;
    caxis([0 0.5]); datetick('x','m');  grid on; 
    hold on
    hh=plot(X,smooth([ROMS.mld2],20),'r-',X,smooth([ROMS.mld5],20),'k-','linewidth',3);
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))    
    set(gca,'Ydir','reverse','ylim',[0 40],'ytick',0:10:40,'fontsize',10,'tickdir','out');
    datetick('x','m','keeplimits','keepticks');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.Label.String = '\DeltaT from 0m (^oC)';
    h.FontSize = 10;
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
    legend([hh(1),hh(2)],'\DeltaT = 0.2^oC','\DeltaT = 0.5^oC','Location','SE');
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs/ROMS_MB_Temp_dTdz_' num2str(year) '.tif']);
hold off
