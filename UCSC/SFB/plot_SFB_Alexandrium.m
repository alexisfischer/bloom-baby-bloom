% summarize your class of interest
class2do_string = 'Dinophysis'; 

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SFB/';

[class] = summarize_class(class2do_string,...
    ['~/Documents/MATLAB/bloom-baby-bloom/SCW/Data/IFCB_summary/Coeff_' class2do_string],...
    [filepath 'Data/IFCB_summary/manual/count_biovol_manual_18Aug2018'],...
    [filepath 'Data/IFCB_summary/class/summary_allTB_bythre_' class2do_string],...
    filepath);

%
[phyto,A] = compile_species(class2do_string,...
    [filepath 'Data/IFCB_summary/class/' num2str(class2do_string) '_summary'],...
    [filepath 'Data/st_filename_raw.csv'],...
    [filepath 'Data/sfb_raw.csv'],filepath);


%% contour Alexandrium
str='Prorocentrum';
label='Prorocentrum (cells mL^{-1})';
ccon=0:1:30;
cax=[0 30];    

for i=1:(length(A)-1)
    
    var = A(i).y_mat;    
    
    yrok = datenum(A(i).dn);
    lat = A(i).lat; 
    lon = A(i).lon; 
    ii=~isnan(var+lat+lon);
    lonok=lon(ii); latok=lat(ii); vvok=var(ii);    

    % map limits and tics for SFB
    xax = [-122.56 -121.78]; yax=[37.42 38.22];
    xtic = -122.5:.2:-121.8; ytic=37.5:.1:38.2;  
    textsurv={datestr(yrok,'dd-mmm-yyyy')};

    % contour plot 
    x = -122.56:.001:-121.76; y = 37.4:.001:38.22;
    bathydata = load([filepath 'Data/SFB_bathymetry.mat']);
    xx = bathydata.lon; yy = bathydata.lat;
    F = scatteredInterpolant(lonok,latok,vvok,'nearest','nearest'); %F is a function
    zz = F(xx,yy); %must call scatteredInterp function in order to plot
    zz(bathydata.bathy==-9999) = nan;

    fig1 = figure('Units','inches','Position',[1 1 6 6],'PaperPositionMode','auto'); clf;
    axes1 = axes('Parent',fig1);
    [C,h]=contour(xx,yy,zz,ccon); h.Fill='on';
    set(axes1, 'color', [0.83 0.816 0.78])
    caxis(cax); hold on;
    set(gca,'xtick',xtic,'ytick',ytic,'fontsize',10,'TickDir','out');
    dasp(41); xlim(xax); ylim(yax);
    hp=get(gca,'pos');

    axes('pos',hp,'color','none'); axis off;
    dasp(41); xlim(xax); ylim(yax);
    caxis(cax); hold on;

    % plots outline of sfb
    coastline_SFB('k-'); 

    % add station locations
    plot(lon,lat,'ko','markerfacecolor','w','markersize',12,'linewidth',.5);
    xlim(xax); ylim(yax);
    labels = num2str(A(i).st,'%d'); 
    text(lon,lat,labels,'horizontal','center','vertical','middle',...
        'fontsize',8,'color','k');
    axis off; 

    % colorbar
    h=colorbar('east'); 
    h.TickDirection = 'out';    
    h.Label.String = label;
    hp=get(h,'pos'); hp(4)=.5*hp(4); hp(3)=.6*hp(3); 
    set(h,'pos',hp,'xaxisloc','top','fontsize',11); 
    hold on;

    title(textsurv,'fontsize',14);

    % Set figure parameters
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r600',...
        [filepath 'Figs/' num2str(str) '_contour_' datestr(yrok,'ddmmmyyyy') '.tif'])
    hold off

end

%% Plot Alexandrium vs Distance from st36 and salinity
figure('Units','inches','Position',[1 1 8.5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.17 0.05], [0.07 -.12]);
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
    A(10).d36,A(10).y_mat,'ko',...
    A(11).d36,A(11).y_mat,'ko',...
    A(12).d36,A(12).y_mat,'ko',...
    A(13).d36,A(13).y_mat,'ko',...
    A(14).d36,A(14).y_mat,'ko',...    
    A(15).d36,A(15).y_mat,'ko',...        
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
    set(h(10),'Color',c1,'Marker','o','MarkerFaceColor',c1);
    set(h(11),'Color',c2,'Marker','h');
    set(h(12),'Color',c3,'Marker','d','MarkerFacecolor',c3);
    set(h(13),'Color',c4,'Marker','o');
    set(h(14),'Color',c5,'Marker','v','MarkerFaceColor',c5);
    set(h(15),'Color',c6,'Marker','^');      
    
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
    A(10).sal,A(10).y_mat,'ko',...
    A(11).sal,A(11).y_mat,'ko',...
    A(12).sal,A(12).y_mat,'ko',...
    A(13).sal,A(13).y_mat,'ko',...
    A(14).sal,A(14).y_mat,'ko',...    
    A(15).sal,A(15).y_mat,'ko',...        
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
    set(h(10),'Color',c1,'Marker','o','MarkerFaceColor',c1);
    set(h(11),'Color',c2,'Marker','h');
    set(h(12),'Color',c3,'Marker','d','MarkerFacecolor',c3);
    set(h(13),'Color',c4,'Marker','o');
    set(h(14),'Color',c5,'Marker','v','MarkerFaceColor',c5);
    set(h(15),'Color',c6,'Marker','^');  
    
    set(gca,'xlim',[-1 35],'xtick',0:5:35,'tickdir','out','yticklabel',{});    
    xlabel('Salinity (psu)','fontsize',10,'fontweight','bold');        
hold on

%legend
hSub=subplot(1,3,3);
h=plot(1,nan,'ko',1,nan,'ko',1,nan,'ko',1,nan,'ko',1,nan,'ko',...
    1,nan,'ko',1,nan,'ko',1,nan,'ko',1,nan,'ko',1,nan,'ko',1,nan,...
    'ko',1,nan,'ko',1,nan,'ko',1,nan,'ko',1,nan,'ko'); 
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
    set(h(10),'Color',c1,'Marker','o','MarkerFaceColor',c1);
    set(h(11),'Color',c2,'Marker','h');
    set(h(12),'Color',c3,'Marker','d','MarkerFacecolor',c3);
    set(h(13),'Color',c4,'Marker','o');
    set(h(14),'Color',c5,'Marker','v','MarkerFaceColor',c5);
    set(h(15),'Color',c6,'Marker','^');    

    hleg=legend(hSub,A(1).dn,A(2).dn,A(3).dn,A(4).dn,A(5).dn,A(6).dn,...
        A(7).dn,A(8).dn,A(9).dn,A(10).dn,A(11).dn,A(12).dn,A(13).dn,...
        A(14).dn,A(15).dn,'Location','NorthWest');
    set(hleg,'fontsize',9); 
    legend boxoff

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\Alex_Sal_Dist_SFB.tif']);
hold off 