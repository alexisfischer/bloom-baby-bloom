%quick plot of NZ Alexandrium

filepath = '~/Documents/MATLAB/bloom-baby-bloom/NZ/';
load([filepath 'Data/IFCB_summary/class/summary_allTB_2019'],...
    'classcountTB','filelistTB','ml_analyzedTB','mdateTB','class2useTB'); 

%% Plot automated vs manual classification vs RAI

figure('Units','inches','Position',[1 1 5 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.06 0.03], [0.18 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

xax1=datenum('2019-01-20'); xax2=datenum('2019-04-01');     

subplot(3,1,1)
    class2do_str='Alexandrium_singlet';
    idx = strmatch(class2do_str, class2useTB); %classifier index
    cell=classcountTB(:,idx)./ml_analyzedTB(:); cell((cell<0)) = 0; % cannot have negative numbers 
    plot(mdateTB,cell,'ro','Markersize',5,'Linewidth',1.5); hold on
    datetick('x','mmm','keeplimits');
    set(gca,'xlim',[xax1 xax2],'xgrid','on','xticklabel',{},'fontsize',12,'tickdir','out');  
    ylabel({'Alexandrium';'cells/mL'},'fontsize',14,'fontweight','bold');    
    hold on    
subplot(3,1,2)
    class2do_str='Gymnodinium';
    idx = strmatch(class2do_str, class2useTB); %classifier index
    cell=classcountTB(:,idx)./ml_analyzedTB(:); cell((cell<0)) = 0; % cannot have negative numbers 
    plot(mdateTB,cell,'g^','Markersize',5,'Linewidth',1.5); hold on
    datetick('x','mmm','keeplimits');
    set(gca,'xlim',[xax1 xax2],'xgrid','on','xticklabel',{},'fontsize',12,'tickdir','out');  
    ylabel({'Gymnodinium';'cells/mL'},'fontsize',14,'fontweight','bold');    
    hold on    
subplot(3,1,3)
    class2do_str='Amy_Gony_Protoc';
    idx = strmatch(class2do_str, class2useTB); %classifier index
    cell=classcountTB(:,idx)./ml_analyzedTB(:); cell((cell<0)) = 0; % cannot have negative numbers 
    plot(mdateTB,cell,'bs','Markersize',5,'Linewidth',1.5); hold on
    datetick('x','mmm','keeplimits');
    set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',12,'tickdir','out');  
    ylabel({'Amylax & Gonyaulax';'cells/mL'},'fontsize',14,'fontweight','bold');    
    hold on    
    
%% set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/NZ_Alex_IFCB_classifier.tif']);
hold off