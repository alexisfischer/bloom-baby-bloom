%% plot Dinophysis species composition and abundance in Budd Inlet
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2023'; % '2023'
load([filepath 'Data/BuddInlet_data_summary'],'T','fli','dmatrix','ymatrix');

% only select data from year of interest
T(~(T.dt.Year==str2double(yr)),:)=[];
fli(~(fli.dt.Year==str2double(yr)),:)=[];
idx=~(dmatrix.Year==str2double(yr)); dmatrix(idx)=[]; ymatrix(:,idx)=[];

%colorscheme
col=(brewermap(7,'Dark2')); blue=brewermap(1,'Blues');
c=[col(1,:);col(2,:);col(3,:);col(6,:);blue(1,:);col(7,:)];
%greenD orange purple yellow green pink

figure('Units','inches','Position',[1 1 1.8 2.7],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.13], [0.19 0.05]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(2,1,1);
h = bar(T.dt,100*[T.DFortML T.DAcumML T.DNorvML T.DOdioML T.DParvML T.DAcutML]./T.DinoML_micro,'stack','Barwidth',3.5,'linestyle','none');
    for i=1:length(h), set(h(i),'FaceColor',c(i,:)); end  
    set(gca,'xaxislocation','top','xlim',xax,'ylim',[0 100],'ytick',0:50:100,...
        'fontsize', 8,'fontname', 'arial','tickdir','out','ycolor','k')
    datetick('x', 'm', 'keeplimits');      
    ylabel({'species (%)'},'fontsize',9); 
    title(yr,'fontsize', 10)   

subplot(2,1,2); 
P=prctile(ymatrix,[25 50 75],1); x=dmatrix'; y1=P(1,:); y2=P(2,:); y3=P(3,:);
    hf=plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw

    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
    hn=plot(T.dt(idx),val,'s','markersize',2,'linewidth',.5,...
        'color','k','markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.13*ones(size(dti));
        plot(dti,val,'-','color','k','linewidth',2.); hold on;        
    end
hline(3,'k--');

pink=brewermap(2,'RdPu');
    idx=(T.DinoML_micro==0);
    hz=plot(T.dt(idx),T.DinoML_micro(idx),'^','color',pink(2,:),'markerfacecolor','w','Linewidth',.5,'markersize',3); hold on;                
    hm=plot(T.dt(~idx),T.DinoML_micro(~idx),'^','color',pink(2,:),'markerfacecolor',pink(2,:),'Linewidth',.5,'markersize',3); hold on;            
        set(gca,'xgrid','on','tickdir','out','xlim',xax,...
            'ylim',[0 30],'ytick',0:15:30,'fontsize',8,'ycolor','k','box','on');         
    set(gca,'Layer','top'); grid off;   
    ylabel({'cells/mL'},'fontsize',9); hold on;  
    datetick('x', 'm', 'keeplimits');          

% %find when >=3 cells/mL
% idx=find(fli.dino>=3,1); fli.dt(idx)
% %26-Jun-2022
% %01-Jul-2023

%%%% blooms
% vline(datetime('2022-06-26'))
% vline(datetime('2022-07-07'))
% 
% vline(datetime('2022-07-25'))
% vline(datetime('2022-08-05'))
% 
% vline(datetime('2022-08-28'))
% vline(datetime('2022-09-10'))
% 
% vline(datetime('2022-09-21'))
% vline(datetime('2022-09-28'))
% 
% vline(datetime('2023-07-04'))
% vline(datetime('2023-08-19'))

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/DinoSpecies_' yr '.png'],'Resolution',300)    
hold off
