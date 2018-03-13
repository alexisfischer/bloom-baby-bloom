
biovolume= 'F:\IFCB113\class\summary\summary_biovol_allcells';
cruisetime = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\st_filename_raw.csv';
parameters= 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\sfb_raw_2.csv';
[phyto,p] = compile_biovolume_yrs(biovolume, cruisetime, parameters);

%% Plot SFB biovolume vs Distance
figure('Units','inches','Position',[1 1 6 3],'PaperPositionMode','auto');

h=plot(...
    p(1).d36,p(1).biovol_sum,'ko',...
    p(2).d36,p(2).biovol_sum,'ko',...
    p(3).d36,p(3).biovol_sum,'ko',...
    p(4).d36,p(4).biovol_sum,'ko',...
    p(5).d36,p(5).biovol_sum,'ko',...
    p(6).d36,p(6).biovol_sum,'ko',...
    p(7).d36,p(7).biovol_sum,'ko',...
    p(8).d36,p(8).biovol_sum,'ko',...
    p(9).d36,p(9).biovol_sum,'ko',...
    'Linewidth',1,'Markersize',5);
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
    set(h(9),'Marker','s','Markersize',7);
    
    set(gca,'xlim',[-5 150],'xtick',0:50:150,'tickdir','out');    
    xlabel('Distance from Station 36 (km)','fontsize',10,'fontweight','bold');        
    ylabel('Biovolume (um^3)','fontsize',10,'fontweight','bold');        
    hleg = legend(p(1).dn,p(2).dn,p(3).dn,p(4).dn,p(5).dn,p(6).dn,...
        p(7).dn,p(8).dn,p(9).dn,'Location','EastOutside');
    set(hleg,'fontsize',9); 
    legend boxoff

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600','C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Figs\Biovolume_dist36_SFB.tif')
hold off 

%% Plot SFB biovolume vs Salinity
figure('Units','inches','Position',[1 1 6 3],'PaperPositionMode','auto');

h=plot(...
    p(1).sal,p(1).biovol_sum,'ko',...
    p(2).sal,p(2).biovol_sum,'ko',...
    p(3).sal,p(3).biovol_sum,'ko',...
    p(4).sal,p(4).biovol_sum,'ko',...
    p(5).sal,p(5).biovol_sum,'ko',...
    p(6).sal,p(6).biovol_sum,'ko',...
    p(7).sal,p(7).biovol_sum,'ko',...
    p(8).sal,p(8).biovol_sum,'ko',...
    p(9).sal,p(9).biovol_sum,'ko',...
    'Linewidth',1,'Markersize',5);
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
    set(h(9),'Marker','s','Markersize',7);
    
    set(gca,'xlim',[-1 35],'xtick',0:5:35,'tickdir','out');    
    xlabel('Salinity (psu)','fontsize',10,'fontweight','bold');        
    ylabel('Biovolume (um^3)','fontsize',10,'fontweight','bold');        

    hleg = legend(p(1).dn,p(2).dn,p(3).dn,p(4).dn,p(5).dn,p(6).dn,...
        p(7).dn,p(8).dn,p(9).dn,'Location','EastOutside');
    set(hleg,'fontsize',9); 
    legend boxoff

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600','C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Figs\Biovolume_Salinity_SFB.tif')
hold off 