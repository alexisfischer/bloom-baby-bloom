resultpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
load([resultpath 'Data\RAI_SCW']);


%%

figure('Units','inches','Position',[1 1 8 3],'PaperPositionMode','auto');        

for i=1:length(r)
    sz=linspace(1,150,100); 
    A=r(i).rai';
    ii=~isnan(A); %which values are not NaNs
    Aok=A(ii);
    iii=find(Aok);
    Aook=Aok(iii);
    Asz=zeros(length(Aook),1); %preallocate space   
    for j=1:length(Asz)  % define sizes according to cyst abundance
         Asz(j)=sz(round(Aook(j)*length(sz)));
    end
    scatter(r(i).dn(iii)',i*ones(size(Asz)),Asz,'m','filled');
    hold on    
end  

datetick,set(gca, 'xgrid', 'on')
set(gca,'ylim',[0 13],'ytick',0:1:13,...
    'xlim',[datenum('2016-08-01') datenum('2017-07-31')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01'),...
        datenum('2016-12-01'),datenum('2017-01-01'),...
        datenum('2017-02-01'),datenum('2017-03-01'),...
        datenum('2017-04-01'),datenum('2017-05-01'),...
        datenum('2017-06-01'),datenum('2017-07-01')],...
        'XTickLabel',{'Aug','Sep','Oct','Nov','Dec','Jan17',...
        'Feb','Mar','Apr','May','Jun','Jul'},...
        'YTickLabel',['0', {r.name}],'tickdir','out');   
    
    % set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\Figs\RAI_2016-present.tif')
hold off 