filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';

% plot Monterey bay

figure('Units','inches','Position',[1 1 6 6],'PaperPositionMode','auto');        
m_proj('albers equal-area','lat',[36.56 37.05],'long',[-122.15 -121.7],'rect','on');
m_gshhs_f('patch',[.8 .8 .8],'edgecolor','none');  
m_grid('linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','top','yaxisloc','left','fontsize',16);  
    m_ruler([.05 .4],.1,2,'fontsize',12);
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\SCW_map.tif']);
hold off 

