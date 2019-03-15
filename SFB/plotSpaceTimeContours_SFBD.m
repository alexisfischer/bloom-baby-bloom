%% plot Space & Time Contours
%addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

filepath = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/NetDeltaFlow'],'DN','X2','OUT');
load([filepath 'Data/physical_param'],'S','Si'); % parameters
load([filepath 'Data/Phytoflash_summary'],'P','Pi'); % parameters
load([filepath 'Data/microscopy_SFB'],'BAi','CYi','CRi','DIi');

%% Physical, Chemical, Phytoflash, and Microscopy
figure('Units','inches','Position',[1 1 6 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.16 0.02], [0.13 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%label="FvFm"; str="FvFm"; cax=[.1 .6];  C=([Pi.FvFm]);%
%label="Surface Salinity (psu)"; str="Sal"; cax=[0 30]; C=[Si.sal];%
label="Temperature (^oC)"; str="Temp"; cax=[8 24]; C=[Si.temp];%
%label="log Chlorophyll (mg m^{-3})"; str="Chl"; cax=[0 3]; C=log([Si.chl]);
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

xax=[datenum('2013-01-01') datenum('2019-01-01')];     

if str == "FvFm"    
    X = [Pi.dn]';
    Y=[Pi(1).d18]';
    
    bad1 = 25; 
    C = [C(:,1:bad1), NaN*C(:,1:2), C(:,bad1+1:end)];
    X = [X(1:bad1); datenum('10-Jun-2015'); datenum('20-Jul-2015'); X(bad1+1:end)];    
    
    bad1 = 29;  %insert nans between Jun 2015 and Oct 2016
    C = [C(:,1:bad1), NaN*C(:,1:2), C(:,bad1+1:end)];
    X = [X(1:bad1); datenum('01-Dec-2015'); datenum('01-Oct-2016'); X(bad1+1:end)];
    
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
    plot(DN,OUT);
    datetick('x', 'yyyy', 'keeplimits')
    set(gca,'tickdir','out',...
        'xlim',[xax(1) xax(2)],'fontsize', 10,'xticklabels',{});   
    ax=gca; ax.YAxis(1).Exponent = 0;    
  %  ylabel('Delta Outflow (m^3 s^{-1})', 'fontsize', 14, 'fontname', 'arial','fontweight','bold')
    hold on

subplot(4,1,[2 3 4]);
    pcolor(X,Y,C); shading interp;
   % contourf(X,Y,C,'edgecolor','none'); shading interp;
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
        h.Label.Position = [hp(1)+3.8 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),3);   
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
    hold on
    plot(DN,(X2-6.43738),'k-','linewidth',3); %adjust X2 so distance from Angel island, not GG

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/' num2str(str) '_space_time_2013-2018.tif'])
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