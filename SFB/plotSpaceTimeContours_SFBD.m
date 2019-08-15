%% plot Space & Time Contours
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

clear;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/NetDeltaFlow'],'DN','X2','OUT');
load([filepath 'Data/physical_param'],'S','Si'); % parameters
load([filepath 'Data/Phytoflash_summary'],'P','Pi'); % parameters
load([filepath 'Data/microscopy_SFB'],'BAi','CYi','CRi','DIi');

% back-of-the-envelope Suisun Bay daily residence time calculation
OUT=OUT*60*60*24; %convert from m^3/s to m^3/day
RT=.001*6.54e11./OUT; % days
    
%% monthly averages
clearvars X Y C;

label="FvFm"; str="FvFm"; cax=[.1 .6];  F=[Pi.FvFm]';
%label="Surface Salinity (psu)"; str="Sal"; cax=[0 30]; F=[Si.sal]';
%label="Temperature (^oC)"; str="Temp"; cax=[8 24]; F=[Si.temp]';
%label="Chl \ita \rm(mg m^{-3})"; str="Chl"; cax=[0 15]; F=[Si.chl]';
%label="Chl:(Chl+PHA)"; str="ChlPha"; cax=[.3 1]; F=[Si.chlpha]';
%label="Ammonium (\muM)"; str="Amm"; cax=[0 20]; F=[Si.amm]';
%label="Nitrate+Nitrite (\muM)"; str="Nina"; cax=[10 60]; F=[Si.nina]';
%label="Nitrite (\muM)"; str="Ni"; cax=[0 5]; F=[Si.ni]';
%label="Optical Backscatter (V)"; str="Obs"; cax=[0 3]; F=[Si.obs]';
%label=["Suspended Sediments";"(mg L^{-1})"]; str="SPM"; cax=[0 100]; F=[Si.spm]';
%label=["Light Attenuation";"Coefficient (m^{-1})"]; str="Light"; cax=[0 5]; F=[Si.light]';
%label=" "; str="diatom"; cax=[0 4000000];  FF=[BAi.biovol]';
%label=" "; str="cryp"; cax=[0 600000];  FF=[CRi.biovol]';
%label=" "; str="cyano"; cax=[0 100000];  FF=[CYi.biovol]';
%label="Dinoflagellates"; str="dino"; cax=[0 800000];  FF=[DIi.biovol]';

if str == "FvFm"    
    D = [Pi.dn]'; Y=[Pi(1).d18]';
elseif str == "diatom"
    D = [BAi.dn]'; YY = [BAi(1).d18]';
    Y=[YY(1),10,YY(2),YY(3),40,YY(4),YY(5),YY(6),85,YY(7)];
    F=[FF(:,1),NaN*FF(:,1),FF(:,2),FF(:,3),NaN*FF(:,1),FF(:,1),FF(:,5),FF(:,6),NaN*FF(:,1),FF(:,7)];    
elseif str == "cyano"
    D = [CYi.dn]'; YY = [CYi(1).d18]';
    Y=[YY(1),10,YY(2),YY(3),40,YY(4),YY(5),YY(6),85,YY(7)];
    F=[FF(:,1),NaN*FF(:,1),FF(:,2),FF(:,3),NaN*FF(:,1),FF(:,1),FF(:,5),FF(:,6),NaN*FF(:,1),FF(:,7)];
elseif str == "cryp"
    D = [CRi.dn]'; YY = [CRi(1).d18]'; 
    Y=[YY(1),10,YY(2),YY(3),40,YY(4),YY(5),YY(6),85,YY(7)];
    F=[FF(:,1),NaN*FF(:,1),FF(:,2),FF(:,3),NaN*FF(:,1),FF(:,1),FF(:,5),FF(:,6),NaN*FF(:,1),FF(:,7)];    
elseif str == "dino"
    D = [DIi.dn]'; YY = [DIi(1).d18]';
    Y=[YY(1),10,YY(2),YY(3),40,YY(4),YY(5),YY(6),85,YY(7)];
    F=[FF(:,1),NaN*FF(:,1),FF(:,2),FF(:,3),NaN*FF(:,1),FF(:,1),FF(:,5),FF(:,6),NaN*FF(:,1),FF(:,7)];   
else
    D = [Si.dn]'; Y = [Si(1).d18]'; 
end

for i=1:size(F,2) %organize data into a week x location matrix   
    [ ~, y_ydmat, yearlist, ~ ] = timeseries2ydmat( D, F(:,i));
    [  y_wkmat, mdate_wkmat, yd_wk ] = ydmat2interval( y_ydmat, yearlist, 30 );
    C(i,:) = reshape(y_wkmat,[length(y_wkmat)*size(y_wkmat,2),1]);
    X = reshape(mdate_wkmat,[length(mdate_wkmat)*size(mdate_wkmat,2),1]);
end

figure('Units','inches','Position',[1 1 6.5 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.16 0.04], [0.13 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax=[datenum('2013-01-01') datenum('2019-12-31')];     

subplot(5,1,1);
    plot(DN,smooth(OUT,4),'-k','linewidth',1.5);
    datetick('x', 'yyyy', 'keeplimits')
    set(gca,'tickdir','out','ylim',[0 3.3e10],'ytick',1e10:1e10:3e10,...
        'xlim',[xax(1) xax(2)],'fontsize', 14,'xticklabels',{},'ycolor','k');   
    ylabel('m^3 day^{-1}', 'fontsize', 14, 'fontname', 'arial')
    hold on

subplot(5,1,[2 3 4 5]);
    pcolor(X,Y,C);        
    caxis(cax); shading flat; 
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],...
        'ylim',[0 max(Y)],'ytick',0:20:80,'fontsize', 14,'tickdir','out');
    datetick('x', 'yyyy', 'keeplimits')  
    ylabel('Distance (km) from Angel Island)', 'fontsize', 14)    
    hold on
    
    if str == "Sal"    
        color=brewermap([],'YlGnBu');  
    elseif str == "Chl" || str == "diatom" || str == "cyano" || str == "cryp" || str == "dino" 
        color=brewermap([],'YlGn');     
    elseif str == "SPM" || str == "Obs" || str == "Light"
        color=brewermap([],'YlOrBr');  
    elseif str == "FvFm" || str == "ChlPha" 
        color=(brewermap([],'RdYlGn'));            
    elseif str == "Temp"
        color=flipud(brewermap([],'RdBu'));               
    else
        color=brewermap([],'RdPu');     
    end
    colormap(color);    
      
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 14;               
    hp=get(h,'pos'); 
    hp(1)=hp(1); hp(2)=.2*hp(2); hp(3)=.54*hp(3); hp(4)=.8*hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on
    
 if str == "Sal"    
        h.Label.Position = [hp(1)+43 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),7);  
    elseif str == "Chl"
        h.Label.Position = [hp(1)+20 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),4);   
    elseif str == "Nina"  
        h.Label.Position = [hp(1)+84 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),6);    
    elseif str == "Ni"  
        h.Label.Position = [hp(1)+7 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),6);   
    elseif str == "Obs"  
        h.Label.Position = [hp(1)+4.5 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),4);  
    elseif str == "SPM"  
        h.Label.Position = [hp(1)+150 hp(2)+1.8]; 
        h.Ticks=linspace(cax(1),cax(2),5);       
    elseif str == "Light"  
        h.Label.Position = [hp(1)+7 hp(2)+1.8]; 
        h.Ticks=linspace(cax(1),cax(2),6);   
    elseif str == "ChlPha"  
        h.Label.Position = [hp(1)+1.1 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),8);          
    elseif str == "FvFm"  
        h.Label.Position = [hp(1)+.6 hp(2)+1]; 
        h.Ticks=linspace(cax(1),.6,6);           
    elseif str == "diatom" || str == "cyano" || str == "cryp"
        h.Label.Position = [hp(1)+5  hp(2)+1];
        h.Ticks=linspace(cax(1),cax(2),5);      
    elseif str == "temp"
        h.Label.Position = [hp(1)+40 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);               
    else
        h.Label.Position = [hp(1)+30 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);         
 end
        
    h.Label.FontSize = 14;           
    hold on   
    plot([datenum('01-Jan-2014') datenum('01-Jan-2014')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2014') datenum('01-Jan-2014')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2015') datenum('01-Jan-2015')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2016') datenum('01-Jan-2016')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2017') datenum('01-Jan-2017')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2018') datenum('01-Jan-2018')],[0 100],'k-','linewidth',1);    
    plot([datenum('01-Jan-2019') datenum('01-Jan-2019')],[0 100],'k-','linewidth',1);    
    plot(DN,(X2-6.43738),'k-','linewidth',2); %adjust X2 so distance from Angel island, not GG

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/' num2str(str) '_RT_space_time_2013-2019.tif'])
hold off

%% plot Delta Flow vs Suisun Bay residence time
figure('Units','inches','Position',[1 1 6 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.14 0.09], [0.1 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax=[datenum('2013-01-01') datenum('2019-12-31')];     

subplot(2,1,1);
    plot(DN,smooth(OUT,4),'-k','linewidth',1.5);
    datetick('x', 'yyyy', 'keeplimits')
    set(gca,'tickdir','out','ylim',[0 3.3e10],'ytick',1e10:1e10:3e10,...
        'xlim',[xax(1) xax(2)],'fontsize', 14,'xticklabels',{},'ycolor','k');  
    ylabel('m^3 day^{-1}', 'fontsize', 14, 'fontname', 'arial')
    hold on
     
subplot(2,1,2);
    plot(DN,smooth(RT,4),'-b','linewidth',1);
    datetick('x', 'yyyy', 'keeplimits')
    set(gca,'tickdir','out','ylim',[0 3.3],'ytick',1:1:3,...
        'xlim',[xax(1) xax(2)],'fontsize', 14,'ycolor','k');   
    ylabel('days', 'fontsize', 14, 'fontname', 'arial')

    % Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/DeltaFlow_ResidenceTime_2013-2019.tif'])
hold off
    
%% interpolate gaps (not preferred for biological variables)
figure('Units','inches','Position',[1 1 6.5 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.16 0.02], [0.13 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

% label="FvFm"; str="FvFm"; cax=[.1 .6];  C=([Pi.FvFm]);
label="Surface Salinity (psu)"; str="Sal"; cax=[0 30]; C=[Si.sal];%
%label="Temperature (^oC)"; str="Temp"; cax=[8 24]; C=[Si.temp];%
%label="log Chl \ita \rm(mg m^{-3})"; str="Chl"; cax=[0 15]; C=([Si.chl]);
%label="Ammonium (\muM)"; str="Amm"; cax=[0 20]; C=([Si.amm]);
%label="Nitrate+Nitrite (\muM)"; str="Nina"; cax=[10 60]; C=([Si.nina]);
%label="Nitrite (\muM)"; str="Ni"; cax=[0 5]; C=([Si.ni]);
%label="Optical Backscatter (V)"; str="Obs"; cax=[0 3]; C=([Si.obs]);
%label={"Suspended Sediments";"(mg L^{-1})"}; str="SPM"; cax=[0 100]; C=([Si.spm]);
%label={"Light Attenuation";"Coefficient (m^{-1})"}; str="Light"; cax=[0 5]; C=[Si.light];
%label=" "; str="diatom"; cax=[0 5000000];  C=([BAi.biovol]);
%label=" "; str="cyano"; cax=[0 100000];  C=([CYi.biovol]);
%label=" "; str="cryp"; cax=[0 800000];  C=([CRi.biovol]);
%label="Dinoflagellates"; str="dino"; cax=[0 800000];  C=([DIi.biovol]);

xax=[datenum('2013-01-01') datenum('2019-12-31')];     

if str == "FvFm"    
    X = [Pi.dn]';Y=[Pi(1).d18]';
elseif str == "diatom"
    X = [BAi.dn]'; Y = [BAi(1).d18]';
elseif str == "cyano"
    X = [CYi.dn]'; Y = [CYi(1).d18]'; 
elseif str == "cryp"
    X = [CRi.dn]'; Y = [CRi(1).d18]';     
elseif str == "dino"
    X = [DIi.dn]'; Y = [DIi(1).d18]'; 
else
    X = [Si.dn]'; Y = [Si(1).d18]';
end

subplot(4,1,1);
    plot(DN,OUT,'-k','linewidth',1.5);
    datetick('x', 'yyyy', 'keeplimits')
    set(gca,'tickdir','out','ytick',200000:200000:400000,'ylim',[0 400000],...
        'yticklabel',{'2','4'},'xlim',[xax(1) xax(2)],'fontsize', 14,'xticklabels',{});   
    ax=gca; ax.YAxis(1).Exponent = 0;    
    ylabel('(m^3 s^{-1})', 'fontsize', 14, 'fontname', 'arial')
    hold on

subplot(4,1,[2 3 4]);
    pcolor(X,Y,C); shading interp;
    %contourf(X,Y,C,'edgecolor','none'); shading interp;
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],...
        'ylim',[0 max(Y)],'ytick',0:20:80,'fontsize', 14,'tickdir','out');
    datetick('x', 'yyyy', 'keeplimits')  
    ylabel('Distance (km) from Angel Island)', 'fontsize', 14)    
    hold on
    
    if str == "Sal"    
        color=brewermap([],'YlGnBu');  
    elseif str == "Chl" || str == "diatom" || str == "cyano" || str == "cryp" || str == "dino"
        color=brewermap([],'YlGn');       
    elseif str == "SPM" || str == "Obs" || str == "Light"
        color=brewermap([],'YlOrBr');  
    elseif str == "FvFm"
        color=(brewermap([],'RdYlGn'));            
    elseif str == "Temp"
        color=flipud(brewermap([],'RdBu'));               
    else
        color=brewermap([],'RdPu');     
    end
    colormap(color);
    
    caxis(cax);    
    h=colorbar('south'); 
    h.Label.String = label;
    h.Label.FontSize = 14;               
    hp=get(h,'pos'); 
    hp(1)=hp(1); hp(2)=.2*hp(2); hp(3)=.54*hp(3); hp(4)=.8*hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on
    if str == "Sal"    
        h.Label.Position = [hp(1)+43 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),7);  
    elseif str == "Chl"
        h.Label.Position = [hp(1)+20 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),4);   
    elseif str == "Nina"  
        h.Label.Position = [hp(1)+84 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),6);    
    elseif str == "Ni"  
        h.Label.Position = [hp(1)+7 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),6);   
    elseif str == "Obs"  
        h.Label.Position = [hp(1)+4.5 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),4);  
    elseif str == "SPM"  
        h.Label.Position = [hp(1)+150 hp(2)+1.8]; 
        h.Ticks=linspace(cax(1),cax(2),5);       
    elseif str == "Light"  
        h.Label.Position = [hp(1)+7 hp(2)+1.8]; 
        h.Ticks=linspace(cax(1),cax(2),6);   
    elseif str == "FvFm"  
        h.Label.Position = [hp(1)+.6 hp(2)+1]; 
        h.Ticks=linspace(cax(1),.6,6);          
    elseif str == "diatom" || str == "cyano" || str == "cryp"
        h.Label.Position = [hp(1)+30  hp(2)+1];
        h.Ticks=linspace(cax(1),cax(2),6);      
    elseif str == "temp"
        h.Label.Position = [hp(1)+40 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);              
    else
        h.Label.Position = [hp(1)+30 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);         
    end
    
    h.Label.FontSize = 14;           
    hold on;
    plot([datenum('01-Jan-2014') datenum('01-Jan-2014')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2014') datenum('01-Jan-2014')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2015') datenum('01-Jan-2015')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2016') datenum('01-Jan-2016')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2017') datenum('01-Jan-2017')],[0 100],'k-','linewidth',1);
    plot([datenum('01-Jan-2018') datenum('01-Jan-2018')],[0 100],'k-','linewidth',1);    
    plot([datenum('01-Jan-2019') datenum('01-Jan-2019')],[0 100],'k-','linewidth',1);    
    
    hold on
    plot(DN,(X2-6.43738),'k-','linewidth',3); %adjust X2 so distance from Angel island, not GG

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/' num2str(str) '_space_time_2013-2019.tif'])
hold off

%%
C=[Si.sal];
Sal=C(:);

C=([Si.chl]);
Chl=C(:);

figure;
scatter(Sal,log(Chl))
ylabel('log Chlorophyll')
xlabel('Salinity')