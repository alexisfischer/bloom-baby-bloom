filepath = '~/MATLAB/bloom-baby-bloom/SCW/';

%% save Monterey Bay map
m_proj('albers equal-area','lat',[36.7 37.05],'long',[-122.2 -121.75],'rect','on');
m_gshhs_f('save',[filepath 'Figs/coast_montereybay']);

%% plot Monterey bay

filepath = '~/MATLAB/bloom-baby-bloom/'; 
load([filepath 'SCW/Figs/coast_montereybay'],'ncst');

figure('Units','inches','Position',[1 1 7 7],'PaperPositionMode','auto');        
%m_proj('albers equal-area','lat',[36.5 37.14],'long',[-122.44 -121.7],'rect','on');
m_proj('albers equal-area','lat',[36.5 37.14],'long',[-122.44 -121.7],'rect','on');

m_gshhs_f('patch',[.8 .8 .8],'edgecolor','none');  
m_grid('linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','top','yaxisloc','left','fontsize',16);  
    m_ruler([.05 .4],.1,2,'fontsize',12);
m_line(-122.04,36.974,'marker','s','markersize',6,'color','k');
m_text(-122.11,36.978,{'Santa';'Cruz'},'fontsize',12,'fontweight','bold');

m_line(-121.895,36.6,'marker','s','markersize',6,'color','k');
m_text(-121.95,36.586,'Monterey','fontsize',12,'fontweight','bold');

m_line(-122.42,36.75,'marker','.','markersize',14,'color','k');
m_text(-122.41,36.76,'NDBC 46042','fontsize',12);

m_line(-122.013,36.964,'marker','.','markersize',14,'color','k');
m_text(-122.013,37.005,{'San';'Lorenzo';'River'},'fontsize',12);

m_line(-121.907,36.972,'marker','.','markersize',14,'color','k');
m_text(-121.892,36.972,{'Soquel River'},'fontsize',12);

m_line(-121.807,36.845,'marker','.','markersize',14,'color','k');
m_text(-121.79,36.845,{'Pajaro';'River'},'fontsize',12);

m_line(-121.803,36.748,'marker','.','markersize',14,'color','k');
m_text(-121.79,36.748,{'Salinas';'River'},'fontsize',12);

m_line(-122.335,37.116,'marker','.','markersize',14,'color','k');
m_text(-122.32,37.125,{'Ano Nuevo'},'fontsize',12);
%m_text(-122.42,37.105,{'Ano';'Nuevo'},'fontsize',12);

m_vec(100,-122.008,36.93,-8,27,'shaftwidth', 1,'headlength',8,'EdgeColor','k','FaceColor','k')
m_text(-122.008,36.92,'wharf','color','k','fontsize',12)

%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'SCW/Figs/SCW_map.tif']);
hold off 

