clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
addpath(genpath('~/MATLAB/UCSC/ACIDD/')); % add new data to search path

filepath = '~/MATLAB/bloom-baby-bloom/IFCB-Data/ACIDD/'; 
outpath = '~/MATLAB/UCSC/ACIDD/Figs/'; 

val=[1:3,51:56,69:78,85:90,97:98,111:122,147:156];

% 2017 classified data
[class2useTB,classcountTB,~,ml_analyzedTB,mdateTB,filelistTB]=...
    excludeclassbiovolACIDD([filepath 'class/'],'summary_biovol_allTB2017',val);
class2useTB=class2useTB';

% manual classification
[class2use,classcount,~,ml_analyzed,matdate,filelist]=...
    excludebiovolACIDD([filepath 'manual/'],'count_biovol_manual_17Dec2018',val);

% merge manual files for merged classes
idx = strcmp('Cryptophyte',class2use);
classcount(:,idx)=nansum(...
    [classcount(:,strcmp('Cryptophyte',class2use)),...
    classcount(:,strcmp('NanoP_less10',class2use)),...
    classcount(:,strcmp('small_misc',class2use))],2);
class2use(idx)={'Cryptophyte,NanoP_less10,small_misc'};

classcount(:,strcmp('NanoP_less10',class2use))=[];
class2use(strcmp('NanoP_less10',class2use))=[];
classcount(:,strcmp('small_misc',class2use))=[];
class2use(strcmp('small_misc',class2use))=[];

idx = strcmp('Gymnodinium',class2use);
classcount(:,idx)=nansum(...
    [classcount(:,strcmp('Gymnodinium',class2use)),...
    classcount(:,strcmp('Peridinium',class2use))],2);
class2use(idx)={'Gymnodinium,Peridinium'};

classcount(:,strcmp('Peridinium',class2use))=[];
class2use(strcmp('Peridinium',class2use))=[];

% classlist={'Akashiwo','Alexandrium_singlet','Amy_Gony_Protoc','Asterionellopsis',...
%     'Centric','Ceratium','Chaetoceros','Cochlodinium','Cryptophyte',...
%     'Cyl_Nitz','Det_Cer_Lau','Dinophysis','Eucampia','Guin_Dact','Gymnodinium',...
%     'Lingulodinium','NanoP_less10','Pennate','Prorocentrum','Pseudo-nitzschia',...
%     'Scrip_Het','Skeletonema','Thalassionema','Thalassiosira'};
% 

classname={'Akashiwo','Alexandrium','Amy-Gony-Protoc','Asterionellopsis',...
    'Centric','Ceratium','Chaetoceros','Cochlodinium','NanoP-less10',...
    'Cyl-Nitz','Det-Cer-Lau','Dictyocha','Dinophysis','Eucampia','Guin-Dact',...
    'Gymnodinium','Lingulodinium','Pennate','Prorocentrum','Pseudo-nitzschia',...
    'Scrip-Het','Skeletonema','Thalassionema','Thalassiosira','unclassified'};

%%
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.05], [0.07 0.03], [0.05 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

for i=1:length(class2useTB)
    id = strcmp(class2useTB(i), class2use); %change this for whatever class you are analyzing
   % idTB = strcmp(classlistTB(i), class2useTB); %change this for whatever class you are analyzing

    subplot(5,5,i)
    plot(classcount(:,id),classcountTB(:,i),'.','markersize',8); hold on;
    axis square
    
    lin_fit{i} = fitlm(classcount(:,id),classcountTB(:,i));
    Rsq(i) = lin_fit{i}.Rsquared.ordinary;
    Coeffs(i,:) = lin_fit{i}.Coefficients.Estimate;
    coefPs(i,:) = lin_fit{i}.Coefficients.pValue;
    RMSE(i) = lin_fit{i}.RMSE;
    eval(['fplot(@(x)x*' num2str(Coeffs(i,2)) '+' num2str(Coeffs(i,1)) ''' , xlim, ''color'', ''r'')'])
    
   if i==11
       ylabel('Automated','fontsize',16,'fontweight','bold'); 
   else
   end
    
   if i==23
       xlabel('Manual','fontsize',16,'fontweight','bold'); 
   else
   end
   
    m=max(classcount(:,id)); mTB=max(classcountTB(:,i));
    if m>mTB
        set(gca,'xlim',[0 m],'ylim',[0 m]);
    else
        set(gca,'xlim',[0 mTB],'ylim',[0 mTB]);
    end
    title(classname(i),'fontweight','normal');
    
    hold on    
end

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[outpath '/SBC_classifiercompare.tif']);
hold off