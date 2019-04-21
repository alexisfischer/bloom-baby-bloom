% plot DD
filepath = '~/Documents/MATLAB/WoodsHole/';
load([filepath 'Data/NausetBottomTemp'],'DN','Tb');


yr=(2012:1:2019)';

for i=1:length(yr)
    i0=find(DN==datenum(['01-Jan-' num2str(yr(i)) ''])); %find January 01 each year
    
    if yr(i) == 2019
        iend=length(DN);
    else
        iend=find(DN==datenum(['31-Dec-' num2str(yr(i)) '']));
    end
    
    dn=DN(i0:iend); tb=Tb(i0:iend);
    
    ttmp=tb; ttmp(ttmp<0)=0; % don't grow if below t0
    dd=cumsum(ttmp);    
    
    D(i).yr=yr(i);
    D(i).dn=dn;
    D(i).tb=tb;
    D(i).dd=dd;
    
end
    
%%
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.08 0.04], [0.12 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum(datenum('01-Jan-2019')); xax2= datenum('01-May-2019'); 
col=flipud(brewermap(8,'Dark2'));


subplot(2,1,1)
h = plot(D(1).dn+7*365,D(1).tb,D(2).dn+6*365,D(2).tb,D(3).dn+5*365,D(3).tb,...
    D(4).dn+4*365,D(4).tb,D(5).dn+3*365,D(5).tb,...
    D(6).dn+2*365,D(6).tb,D(7).dn+365,D(7).tb,D(8).dn,D(8).tb,'linewidth',1);

for i=1:length(yr)
    set(h(i),'Color',col(i,:));
end
    set(h(i),'linewidth',2.5); %make 2019 darker

datetick('x', 'mmm', 'keeplimits')
set(gca,'ylim',[-1 15],'ytick',0:5:15,'xlim',[xax1 xax2],'xticklabel',{},...
    'tickdir','out','fontsize',12)
ylabel('Temperature (^oC)','fontsize',14)
hold on

subplot(2,1,2)
h = plot(D(1).dn+7*365,D(1).dd,D(2).dn+6*365,D(2).dd,D(3).dn+5*365,D(3).dd,...
    D(4).dn+4*365,D(4).dd,D(5).dn+3*365,D(5).dd,...
    D(6).dn+2*365,D(6).dd,D(7).dn+365,D(7).dd,D(8).dn,D(8).dd,'linewidth',1);

for i=1:length(yr)
    set(h(i),'Color',col(i,:));
end
    set(h(i),'linewidth',2.5); %make 2019 darker

datetick('x', 'mmm', 'keeplimits')
set(gca,'ylim',[0 800],'ytick',0:200:800,'xlim',[xax1 xax2],...
    'tickdir','out','fontsize',12)
ylabel('Degree-days since 01 Jan','fontsize',14)
legend(['' num2str(yr) ''],'Location','NW'); legend boxoff

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/DD_bottomSP_2012-2019']);
hold off