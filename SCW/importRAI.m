
load rai_data.mat;

%%

figure('Units','inches','Position',[1 1 7 3],'PaperPositionMode','auto');        

color=flipud(autumn); % define colors
colormap(color);    
 
for i=1:length(r)
    sz=linspace(1,150,100); 
    A=r(i).species';
    A(A<=.01)=.01; %replace values <0 with 0.01       
    Asz=zeros(length(A),1); %preallocate space   
    for j=1:length(Asz)  % define sizes according to cyst abundance
         Asz(j)=sz(round(A(j)*length(sz)));
    end
    scatter(r(i).dn',i*ones(size(r(i).dn')),Asz,'b','filled');
    hold on
end

datetick,set(gca, 'xgrid', 'on')
set(gca,'ylim',[0 13],'ytick',0:1:13,...
    'xlim',[datenum('2016-08-01') datenum('2017-06-30')],...
        'xtick',[datenum('2016-08-01'),datenum('2016-09-01'),...
        datenum('2016-10-01'),datenum('2016-11-01'),...
        datenum('2016-12-01'),datenum('2017-01-01'),...
        datenum('2017-02-01'),datenum('2017-03-01'),...
        datenum('2017-04-01'),datenum('2017-05-01'),...
        datenum('2017-06-01')],...
        'XTickLabel',{'Aug','Sep','Oct','Nov','Dec','Jan17',...
        'Feb','Mar','Apr','May','Jun'},...
        'YTickLabel',['0', {r.name}],'tickdir','out');   
    
    % set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\Figs\RAI_2016-present.tif')
hold off 