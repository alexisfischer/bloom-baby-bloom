%% calculate Brunt-Väisälä frequency for ROMS data

filepath='~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS');

p=sw_pres(ROMS(1).Zi,ROMS(1).lat); %dbar

for i=1:length(ROMS)
    ROMS(i).CT = gsw_CT_from_t( ROMS(i).Si, ROMS(i).Ti, p ); %calculate Conservative Temperature 
    [ROMS(i).N2, ~] = gsw_Nsquared( ROMS(i).Si, ROMS(i).CT, p, ROMS(1).lat );
    ROMS(i).N2 = smooth(ROMS(i).N2,10); %10 pt running average as in Graff & Behrenfeld 2018 and log transform
    ROMS(i).logN2=log10(abs(ROMS(i).N2));
end

%%
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     

figure;
ax=subplot(2,1,1); %SCW dT/dz
    cax=[-5 -3]; 
    X=[ROMS.dn]';
    Y=(ROMS(1).Zi(1:end-1))';
    C=[ROMS.logN2];
    pcolor(X,Y,C); shading interp;
    colormap(ax,parula); caxis(cax); datetick('x','mmm');  grid on; 
    hold on     
    set(gca,'XLim',[xax1;xax2],'Ydir','reverse',...
        'ylim',[0 ROMS(1).Zi(end)],'ytick',10:20:50,'fontsize',12,'tickdir','out');
    datetick('x','mmm','keeplimits')    
   % set(gca, 'XTickLabel',{})
    ylabel('Depth (m)','fontsize',14,'fontweight','bold');
    hold on
    h=colorbar('east','AxisLocation','out');
    hp=get(h,'pos'); 
    h.Position = [hp(1)+.04 hp(2) hp(3) hp(4)];    
    h.TickDirection = 'out';         
    h.FontSize = 12;
    h.Label.String = 'log_10 s^{-1}';     
    h.Label.FontSize = 14;
    h.Label.FontWeight = 'bold';
    h.Ticks=linspace(cax(1),cax(2),3);       
    hold on