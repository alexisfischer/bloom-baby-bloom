biovolume= 'F:\IFCB113\class\summary\summary_biovol_allcells';
resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\';

[phyto,p] = compile_biovolume_yrs(biovolume,...
    [resultpath 'Data\st_filename_raw.csv'],...
    [resultpath 'Data\sfb_raw_2.csv']);    

%% 
figure('Units','inches','Position',[1 1 8.5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.16 0.07], [0.05 -.18]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

% vs Distance from 36
subplot(1,3,1);
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
    set(h(9),'Color','k','Marker','s','Markersize',7);
    
    set(gca,'xlim',[-5 150],'xtick',0:50:150,'tickdir','out');    
    xlabel('Distance from Station 36 (km)','fontsize',10,'fontweight','bold');        
    ylabel('Biovolume (\mum^3)','fontsize',10,'fontweight','bold');        
hold on

% vs Salinity
subplot(1,3,2);    
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
    set(hleg,'fontsize',9); 
    legend boxoff

    % set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Biovolume_Sal_Dist_SFB.tif']);
hold off 