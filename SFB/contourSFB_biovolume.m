biovolume= 'F:\IFCB113\class\summary\summary_biovol_allcells';
resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\';

[phyto,p] = compile_biovolume_yrs(biovolume,...
    [resultpath 'Data\st_filename_raw.csv'],...
    [resultpath 'Data\sfb_raw.csv']);    

%% contour biovolume in the San Francisco Bay

for i=1:(length(p)-1)
    yrok = p(i).dn;
    lat = p(i).lat; 
    lon = p(i).lon; 
    bio = p(i).biovol_sum;
    ii=~isnan(bio+lat+lon);
    lonok=lon(ii); latok=lat(ii); vvok=bio(ii);    

    % map limits and tics for SFB
    xax = [-122.56 -121.78]; yax=[37.42 38.22];
    xtic = -122.5:.2:-121.8; ytic=37.5:.1:38.2;  
    textsurv={datestr(yrok,'dd-mmm-yyyy')};

    % contour plot 
    x = -122.56:.001:-121.76; y = 37.4:.001:38.22;
    bathydata = load([resultpath 'Data\SFB_bathymetry.mat']);
    xx = bathydata.lon; yy = bathydata.lat;
    F = scatteredInterpolant(lonok,latok,vvok,'nearest','nearest'); %F is a function
    zz = F(xx,yy); %must call scatteredInterp function in order to plot
    zz(bathydata.bathy==-9999) = nan;
    ccon=0:1e+05:2e+06;

    fig1 = figure('Units','inches','Position',[1 1 6 6],'PaperPositionMode','auto'); clf;
    axes1 = axes('Parent',fig1);
    [C,h]=contour(xx,yy,zz,ccon); h.Fill='on';
    set(axes1, 'color', [0.83 0.816 0.78])
    cax=[0 2e+06];
    caxis(cax); hold on;
    set(gca,'xtick',xtic,'ytick',ytic,'fontsize',10,'TickDir','out');
    dasp(41); xlim(xax); ylim(yax);
    hp=get(gca,'pos');

    axes('pos',hp,'color','none'); axis off;
    dasp(41); xlim(xax); ylim(yax);
    caxis(cax);
    hold on;

    % plots outline of sfb
    coastline_SFB('k-'); 

    % add station locations
    plot(lon,lat,'ko','markerfacecolor','w','markersize',12,'linewidth',.5);
    xlim(xax); ylim(yax);
    labels = num2str(p(i).st,'%d'); 
    text(lon,lat,labels,'horizontal','center','vertical','middle',...
        'fontsize',8,'color','k');
    axis off; 

    % colorbar
    h=colorbar('east'); 
    h.Label.String= {'Biomass (\mum^3 mL^{-1})'};
    h.TickDirection = 'out';    
    hp=get(h,'pos'); hp(4)=.5*hp(4); hp(3)=.7*hp(3); 
    set(h,'pos',hp,'xaxisloc','top','fontsize',10); 
    h.Label.FontSize = 11;
    hold on;
    
    title(textsurv,'fontsize',14);
    str=['Biovol_' datestr(yrok,'ddmmmyyyy') '_contour'];

    % Set figure parameters
    print(gcf,'-dtiff','-r600',[resultpath 'Figs\' num2str(str) '.tif'])
    hold off

end 

%% Plot Biovolume vs Distance from st36 and salinity
figure('Units','inches','Position',[1 1 8.5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.16 0.07], [0.05 -.18]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

% vs Distance from 36
subplot(1,3,1);
h=plot(p(1).d36,p(1).biovol_sum,'ko',p(2).d36,p(2).biovol_sum,'ko',...
    p(3).d36,p(3).biovol_sum,'ko',p(4).d36,p(4).biovol_sum,'ko',...
    p(5).d36,p(5).biovol_sum,'ko',p(6).d36,p(6).biovol_sum,'ko',...
    p(7).d36,p(7).biovol_sum,'ko',p(8).d36,p(8).biovol_sum,'ko',...
    p(9).d36,p(9).biovol_sum,'ko','Linewidth',1,'Markersize',5);
hold on
    c1=[124 31 0]/255;
    c2=[209 87 13]/255;
    c3=[216 159 43]/255;
    c4=[140 178 2]/255;
    c5=[0 140 116]/255;
    c6=[0 76 102]/255;
    c7=[78 31 87]/255;
    c8=[100,100,100]/255;
    set(h(1),'Color',c1,'Marker','o');
    set(h(2),'Color',c2,'Marker','h','markerfacecolor',c2);
    set(h(3),'Color',c3,'Marker','d');
    set(h(4),'Color',c4,'Marker','o','MarkerFaceColor',c4);
    set(h(5),'Color',c5,'Marker','v');
    set(h(6),'Color',c6,'Marker','^','MarkerFacecolor',c6);
    set(h(7),'Color',c7,'Marker','p');
    set(h(8),'Color',c8,'Marker','*','Markersize',6);
    set(h(9),'Color','k','Marker','s','Markersize',7);
    set(gca,'xlim',[-5 150],'xtick',0:50:150,'tickdir','out');    
    xlabel('Distance from Station 36 (km)','fontsize',10,'fontweight','bold');        
    ylabel('Biovolume (\mum^3)','fontsize',10,'fontweight','bold');        
hold on

% vs Salinity
subplot(1,3,2);    
h=plot(p(1).sal,p(1).biovol_sum,'ko',p(2).sal,p(2).biovol_sum,'ko',...
    p(3).sal,p(3).biovol_sum,'ko',p(4).sal,p(4).biovol_sum,'ko',...
    p(5).sal,p(5).biovol_sum,'ko',p(6).sal,p(6).biovol_sum,'ko',...
    p(7).sal,p(7).biovol_sum,'ko',p(8).sal,p(8).biovol_sum,'ko',...
    p(9).sal,p(9).biovol_sum,'ko','Linewidth',1,'Markersize',5);
hold on

    c1=[124 31 0]/255;
    c2=[209 87 13]/255;
    c3=[216 159 43]/255;
    c4=[140 178 2]/255;
    c5=[0 140 116]/255;
    c6=[0 76 102]/255;
    c7=[78 31 87]/255;
    c8=[100,100,100]/255;
    set(h(1),'Color',c1,'Marker','o');
    set(h(2),'Color',c2,'Marker','h','markerfacecolor',c2);
    set(h(3),'Color',c3,'Marker','d');
    set(h(4),'Color',c4,'Marker','o','MarkerFaceColor',c4);
    set(h(5),'Color',c5,'Marker','v');
    set(h(6),'Color',c6,'Marker','^','MarkerFacecolor',c6);
    set(h(7),'Color',c7,'Marker','p');
    set(h(8),'Color',c8,'Marker','*','Markersize',6);
    set(h(9),'Color','k','Marker','s','Markersize',7);  
    set(gca,'xlim',[-1 35],'xtick',0:5:35,'tickdir','out','yticklabel',{});    
    xlabel('Salinity (psu)','fontsize',10,'fontweight','bold');        
hold on

%legend
hSub=subplot(1,3,3);
h=plot(1,nan,'ko',1,nan,'ko',1,nan,'ko',1,nan,'ko',1,nan,'ko',...
    1,nan,'ko',1,nan,'ko',1,nan,'ko',1,nan,'ko'); 
set(hSub, 'Visible', 'off');
    set(h(1),'Color',c1,'Marker','o');
    set(h(2),'Color',c2,'Marker','h','markerfacecolor',c2);
    set(h(3),'Color',c3,'Marker','d');
    set(h(4),'Color',c4,'Marker','o','MarkerFaceColor',c4);
    set(h(5),'Color',c5,'Marker','v');
    set(h(6),'Color',c6,'Marker','^','MarkerFacecolor',c6);
    set(h(7),'Color',c7,'Marker','p');
    set(h(8),'Color',c8,'Marker','*','Markersize',6);
    set(h(9),'Color','k','Marker','s','Markersize',7);

    hleg=legend(hSub,p(1).dn,p(2).dn,p(3).dn,p(4).dn,p(5).dn,p(6).dn,...
        p(7).dn,p(8).dn,p(9).dn,'Location','West');
    set(hleg,'fontsize',9); legend boxoff

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Biovolume_Sal_Dist_SFB.tif']);
hold off 