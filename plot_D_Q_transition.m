%plot days of cold storage at 2ºC for dormant and second dormant cysts


figure('Units','inches','Position',[1 1 4 2.5],'PaperPositionMode','auto');

h = plot(...
    g(1).cday,g(1).g7dNorm,'-ro',...
    g(3).cday,g(3).g7dNorm,'-b*',...
    g(4).cday,g(4).g7dNorm,'--bs',...
    g(5).cday,g(5).g7dNorm,':b^',...
    'LineWidth',1,'MarkerSize',4); 
    
    hold on
    set(gca,...
        'ylim',[0 1.07],'ytick',0:.25:1,...
        'xlim',[0 400],'xtick',0:100:400,...
        'YTickLabel',{'0','25','50','75','100'},...        
        'fontsize',7); 
    xlabel('Days of cold storage','fontsize',8,'Color','black');
    ylabel('Germination (%) ','fontsize',8,'Color','black');
    set(gca,'XAxisLocation','bottom','TickDir','out');  
    hold on
        hleg = legend('D-Q','10C SD-Q','15C SD-Q','20C SD-Q','Location','SE');
    legend boxoff
    set(hleg,'fontsize',9);
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600','~/Documents/MATLAB/WoodsHole/Figs/day_GOM_2_D_SD.tif');
hold off