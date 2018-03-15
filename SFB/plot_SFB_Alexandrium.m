resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\';

[phyto,A] = compile_species(...
    [resultpath 'Data\Alexandrium_summary'],...
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
    A(1).d36,A(1).y_mat,'ko',...
    A(2).d36,A(2).y_mat,'ko',...
    A(3).d36,A(3).y_mat,'ko',...
    A(4).d36,A(4).y_mat,'ko',...
    A(5).d36,A(5).y_mat,'ko',...
    A(6).d36,A(6).y_mat,'ko',...
    A(7).d36,A(7).y_mat,'ko',...
    A(8).d36,A(8).y_mat,'ko',...
    A(9).d36,A(9).y_mat,'ko',...
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
    ylabel(['\it' 'Alexandrium' '\rm\bf' ' (cells mL^{-1})'],...
    'fontsize',10,'fontweight','bold'); 
hold on

% vs Salinity
subplot(1,3,2);
h=plot(...
    A(1).sal,A(1).y_mat,'ko',...
    A(2).sal,A(2).y_mat,'ko',...
    A(3).sal,A(3).y_mat,'ko',...
    A(4).sal,A(4).y_mat,'ko',...
    A(5).sal,A(5).y_mat,'ko',...
    A(6).sal,A(6).y_mat,'ko',...
    A(7).sal,A(7).y_mat,'ko',...
    A(8).sal,A(8).y_mat,'ko',...
    A(9).sal,A(9).y_mat,'ko',...
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
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Alex_Sal_Dist_SFB.tif']);
hold off 
