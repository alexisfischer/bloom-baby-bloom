%% Pearson Correlation of the factors associated with Pseudo-nitzschia and particulate DA
% Shimada 2019 and 2021
% Fig 4 in Fischer et al. 2024
% A.D. Fischer, May 2024
%
clear;

%%%%USER
fprint = 1; % 1 = print; 0 = don't
%var='\itPseudo-nitzschia';
var='Particulate DA';
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/';

% load in data
load([filepath 'Data/summary_19-21Hake_cells'],'P');
addpath(genpath(filepath)); % add new data to search path

%split data into 2019 and 2021
P1=P((P.DT.Year==2019),:);
P2=P((P.DT.Year==2021),:);

%format data for pearson correlation
Xlabel={'Temperature' 'Salinity' 'pCO_2' 'NO_3^- + NO_2^-' 'Si[OH]_4' 'PO_4^{3−}' 'Si:N' 'P:N' };
Ylabel={'2019','2021','both'};
X1=[P1.TEMP,P1.SAL,P1.PCO2,P1.Nitrate_uM,P1.Silicate_uM,P1.Phosphate_uM,P1.S2N,P1.P2N];
X2=[P2.TEMP,P2.SAL,P2.PCO2,P2.Nitrate_uM,P2.Silicate_uM,P2.Phosphate_uM,P2.S2N,P2.P2N];
X=[P.TEMP,P.SAL,P.PCO2,P.Nitrate_uM,P.Silicate_uM,P.Phosphate_uM,P.S2N,P.P2N];

if strcmp(var,'\itPseudo-nitzschia')
    Y1=[P1.Pseudonitzschia];
    Y2=[P2.Pseudonitzschia];
    Y=[P.Pseudonitzschia];
elseif strcmp(var,'Particulate DA')
    Y1=[P1.pDA_pgmL];
    Y2=[P2.pDA_pgmL];
    Y=[P.pDA_pgmL];
end    

[rho,pval] = corr(X,Y,'Type','Pearson','Rows','pairwise');
[rho1,pval1] = corr(X1,Y1,'Type','Pearson','Rows','pairwise');
[rho2,pval2] = corr(X2,Y2,'Type','Pearson','Rows','pairwise');
R=[rho1,rho2,rho];
PV=[pval1,pval2,pval];

%%%% plot
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 4.4]); 
imagesc(R); xtickangle(45)
col=flipud(brewermap(256,'RdBu'));%col(120:136,:)=[]; 
colormap(gca,col); h=colorbar('XTick',-1:.5:1,'xticklabel',{'-1','-.5','0','.5','1'},'FontSize',10);
    hp=get(h,'pos');     
    hp=[1.05*hp(1) hp(2) .8*hp(3) .85*hp(4)]; % [left, bottom, width, height].
    %    hp=[1.05*hp(1) hp(2) .8*hp(3) .6*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','right','tickdir','out','fontsize',10);

h.Title.String = 'r';
h.Title.FontSize = 12;

clim([-1 1]);
title(var,'fontsize',12);
axis tight; axis equal; 
set(gca,'Xtick',1:1:length(R),'xticklabel',Ylabel,'xaxislocation','top',...
   'ytick',1:1:length(R),'yticklabel',Xlabel,'fontsize',11,'tickdir','out')

for i=1:size(R,2)
    for j=1:size(R,1)
        if PV(j,i)<=0.01
            text(i-.25,j+.1,strrep(num2str(round(R(j,i),2)),'0.','.'),'fontsize',9,'fontweight','bold'); 
            text(i-.1,j-.1,'**','fontsize',12);            
        elseif PV(j,i)<=0.05
            text(i-.25,j+.1,strrep(num2str(round(R(j,i),2)),'0.','.'),'fontsize',9,'fontweight','bold');  
            text(i-.1,j-.1,'*','fontsize',12);            
        else
            text(i-.25,j+.1,strrep(num2str(round(R(j,i),2)),'0.','.'),'fontsize',9);            
        end    
    end
end

if fprint
    if strcmp(var,'\itPseudo-nitzschia')
        exportgraphics(fig,[filepath 'Figs/PN_correlation_2019-2021.png'],'Resolution',300)    
    elseif strcmp(var,'Particulate DA')
        exportgraphics(fig,[filepath 'Figs/pDA_correlation_2019-2021.png'],'Resolution',300)    
    end
end
hold off 

