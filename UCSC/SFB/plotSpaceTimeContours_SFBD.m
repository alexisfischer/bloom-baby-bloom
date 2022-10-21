%% plot Space & Time Contours
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

clear;
filepath = '/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/UCSC/SFB/';
load([filepath 'Data/physical_param'],'Si'); % parameters

load([filepath 'Data/NetDeltaFlow'],'DN','X2','OUT');
OUT=OUT*60*60*24; %convert from m^3/s to m^3/day
%RT=.001*6.54e11./OUT; % daily

load([filepath 'Data/microscopy_SFB_v2'],'G','P');
[~,ia,ib] = intersect([Si.dn],[P.dn]); % add select microscopy data to Si
for i=1:length(ia)
    Si(ia(i)).DIAT=P(ib(i)).BACI; Si(ia(i)).CYAN=P(ib(i)).CYAN; Si(ia(i)).CRYP=P(ib(i)).CRYP; Si(ia(i)).DINO=P(ib(i)).DINO; Si(ia(i)).ent=G(ib(i)).ENT; Si(ia(i)).tha=G(ib(i)).THA;       
end
for i=1:length(Si) %fill gaps with NaNs
    if isempty(Si(i).DIAT)
        Si(i).DIAT=NaN*Si(1).st; Si(i).CYAN=NaN*Si(1).st; Si(i).CRYP=NaN*Si(1).st; Si(i).DINO=NaN*Si(1).st; Si(i).ent=NaN*Si(1).st; Si(i).tha=NaN*Si(1).st;
    else
    end
end
clearvars i ia ib G P;

%% select variables
%Y=[Si(1).sal]';  
Y=[Si(1).d19]';

%label="FvFm"; str="FvFm"; cax=[.1 .7]; F=[Si.FvFmA]';
label="Surface Salinity (psu)"; str="Sal"; cax=[0 35]; F=[Si.sal]';
%label="Temperature (^oC)"; str="Temp"; cax=[8 24]; F=[Si.temp]';
%label="Chl \ita \rm(mg m^{-3})"; str="Chl"; cax=[0 15]; F=[Si.chl]';
%label="Ammonium (\muM)"; str="Amm"; cax=[0 20]; F=[Si.amm]';
%label="Nitrate+Nitrite (\muM)"; str="Nina"; cax=[10 60]; F=[Si.nina]';
%label="Nitrite (\muM)"; str="Ni"; cax=[0 5]; F=[Si.ni]';
%label="Optical Backscatter (V)"; str="Obs"; cax=[0 3]; F=[Si.obs]';
%label="Mixed Layer Depth (m)"; str="mld"; cax=[0 12]; F=[Si.mld]';
%label=["Suspended Sediments";"(mg L^{-1})"]; str="SPM"; cax=[0 100]; F=[Si.spm]';
%label=["Light Attenuation";"Coefficient (m^{-1})"]; str="Light"; cax=[0 5]; F=[Si.light]';
%label=["Diatom biomass";"(um^3 mL^{-1})"]; str="diatom"; cax=[0 4000000]; F=[Si.DIAT]';
%label=["Cryptophyte biomass";"(um^3 mL^{-1})"]; str="cryp"; cax=[0 1000000]; F=[Si.CRYP]';
%label=["Cyanobacteria biomass";"(um^3 mL^{-1})"]; str="cyan"; cax=[0 100000]; F=[Si.CYAN]';
%label=["Dinoflagellate biomass";"(um^3 mL^{-1})"]; str="dino"; cax=[0 1000000]; F=[Si.DINO]';
%label=["Entomoneis biomass";"(um^3 mL^{-1})"]; str="ent"; cax=[0 100000]; F=[Si.ent]';
%label=["Thalassiosira biomass";"(um^3 mL^{-1})"]; str="tha"; cax=[0 1000000];  F=[Si.tha]';

D = [Si.dn]'; 
[~,y_ydmat,yearlist,~]=timeseries2ydmat(D,F(:,1));
[~,mdate_wkmat,~]=ydmat2interval(y_ydmat,yearlist,30);    
X=reshape(mdate_wkmat,[size(mdate_wkmat,1)*size(mdate_wkmat,2),1]);
C=NaN*ones(length(Y),length(X)); %preallocate
for i=1:length(Y) %organize data into a week x location matrix 
    [~, y_ydmat,yearlist,~]=timeseries2ydmat(D,F(:,i));
    [y_wkmat,~,~]=ydmat2interval(y_ydmat,yearlist,30);           
    C(i,:) = reshape(y_wkmat,[length(C),1]);
end

clearvars y_ydmat yearlist y_wkmat D mdate_wkmat i F

figure('Units','inches','Position',[1 1 6. 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.015 0.015], [0.2 0.04], [0.13 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax=[datenum('2013-01-01') datenum('2020-01-01')];     

subplot(5,1,1);
    plot(DN,OUT,'-k','linewidth',1.5);
    datetick('x', 'yyyy', 'keeplimits')
    set(gca,'tickdir','out','ylim',[0 3.3e10],'ytick',1e10:1e10:3e10,...
        'xlim',[xax(1) xax(2)],'fontsize', 14,'xticklabels',{},'ycolor','k');   
    ylabel('m^3 day^{-1}', 'fontsize', 14, 'fontname', 'arial')
    hold on

subplot(5,1,[2 3 4 5]);
    pcolor(X,Y,C); caxis(cax); shading flat; 
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],...
        'ylim',[min(Y) 100],'ytick',0:20:100,'fontsize', 14,'tickdir','out');
    datetick('x', 'yyyy', 'keeplimits')  
    ylabel('Distance from Golden Gate  (km)', 'fontsize', 14)    
    hold on
    
    if str == "Sal"      
        low=6; high=15;        
        cS=brewermap(3,'Dark2'); 
        color=brewermap(cax(end),'Dark2'); 
        len1=length(color(1:low,:)); len2=length(color((low+1):high,:)); len3=length(color((high+1):end,:));
        color(1:low,:)=[repelem(cS(1,1),len1); repelem(cS(1,2),len1); repelem(cS(1,3),len1)]';
        color((low+1):high,:)=[repelem(cS(2,1),len2); repelem(cS(2,2),len2); repelem(cS(2,3),len2)]';
        color((high+1):end,:)=[repelem(cS(3,1),len3); repelem(cS(3,2),len3); repelem(cS(3,3),len3)]';         
    elseif str == "mld"
        color=(brewermap([],'RdBu'));
    elseif str=="Chl" || str=="diatom" || str=="cyan" || str=="cryp" || str=="dino" || str=="ent" || str=="tha"  
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
    hp(1)=hp(1); hp(2)=.3*hp(2); hp(3)=.54*hp(3); hp(4)=.8*hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on
    
 if str == "Sal"    
        h.Label.Position = [hp(1)+50 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),8);
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
        h.Label.Position = [hp(1)+.7 hp(2)+1]; 
        h.Ticks=linspace(cax(1),.7,7);                        
    elseif str == "temp"
        h.Label.Position = [hp(1)+40 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);     
    elseif str == "diatom"
        h.Label.Position = [hp(1)*40000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),5);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);    
    elseif str == "cryp"
        h.Label.Position = [hp(1)*10000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),6);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]); 
    elseif str == "cyan"
        h.Label.Position = [hp(1)*1000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),4);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);  
    elseif str == "dino"
        h.Label.Position = [hp(1)*10000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),6);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);          
    elseif str == "ent"
        h.Label.Position = [hp(1)*1000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),6);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);              
    elseif str == "tha"
        h.Label.Position = [hp(1)*10000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),6);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);  
    elseif str =="mld"
        h.Label.Position = [hp(1)+18 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),7);       
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
    plot([datenum('01-Jan-2020') datenum('01-Jan-2020')],[0 100],'k-','linewidth',1);    
    plot(DN,X2,'k-','linewidth',2);

%% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/' num2str(str) '_RT_space_time_2013-2019.tif'])
hold off

%% variable vs time vs salinity
figure('Units','inches','Position',[1 1 6. 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.2 0.04], [0.13 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax=[datenum('2013-01-01') datenum('2019-12-31')];     

subplot(5,1,[1 2 3 4 5]);
    pcolor(X,Y,C);        
    caxis(cax); shading flat; 
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],'Ydir','reverse',...
        'ylim',[0 35],'ytick',0:5:35,'fontsize', 14,'tickdir','out');  
    datetick('x', 'yyyy', 'keeplimits')  
    ylabel('Surface Salinity (psu)', 'fontsize', 14); hold on
    
    if str == "Sal"    
        color=brewermap([],'YlGnBu');  
    elseif str == "Chl" || str == "diatom" || str == "cyan" || str == "cryp" || str == "dino" || str == "ent" || str == "tha"  
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
    hp(1)=hp(1); hp(2)=.3*hp(2); hp(3)=.54*hp(3); hp(4)=.8*hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on
    
 if str == "Sal"    
        h.Label.Position = [hp(1)+43 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),7);  
        shading interp;        
    elseif str == "Chl"
        h.Label.Position = [hp(1)+17 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),4);   
    elseif str == "Nina"  
        h.Label.Position = [hp(1)+84 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),6);    
    elseif str == "Ni"  
        h.Label.Position = [hp(1)+7 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),6);   
    elseif str == "Amm"  
        h.Label.Position = [hp(1)+30 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);           
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
        h.Label.Position = [hp(1)+.7 hp(2)+1]; 
        h.Ticks=linspace(cax(1),.7,7);           
    elseif str == "diatom"
        h.Label.Position = [hp(1)*40000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),5);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);    
    elseif str == "cryp"
        h.Label.Position = [hp(1)*10000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),6);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]); 
    elseif str == "cyan"
        h.Label.Position = [hp(1)*1000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),6);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);  
    elseif str == "dino"
        h.Label.Position = [hp(1)*10000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),6);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);          
    elseif str == "ent"
        h.Label.Position = [hp(1)*1000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),6);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);              
    elseif str == "tha"
        h.Label.Position = [hp(1)*10000000  hp(2)*30];
        h.Ticks=linspace(cax(1),cax(2),6);      
        set(gca,'xlim',[datenum('01-Jan-2015') xax(2)]);            
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

%% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/' num2str(str) '_vsSAL_space_time_2013-2019.tif'])
hold off
