% plot Dinophysis in Budd Inlet
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;
fprint=0;

filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/';
load([filepath 'IFCB-Data/BuddInlet/manual/count_class_manual_04Jan2022'],...
    'class2use','ml_analyzed','matdate','classcount');

load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB2021'],...
    'class2useTB','ml_analyzedTB','mdateTB','classcountTB');
load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy'],'T');

dtTB=datetime(mdateTB,'ConvertFrom','datenum');
dt=datetime(matdate,'ConvertFrom','datenum');

%% find top biomass

sampletotal=repmat(sum(ugCml,2),1,size(ugCml,2));
fxC_all=ugCml./sampletotal;
classtotal=sum(ugCml,1);
[~,idx]=maxk(classtotal,25); %find top carbon highest classes
idx=(sort(idx))';
fxC=fxC_all(:,idx);
class=class2useTB(idx);
save([filepath 'IFCB-Data/BuddInlet/class/TopClasses_BI','class']);


%% plot Dinophysis manual vs classifier
figure('Units','inches','Position',[1 1 3.5 2],'PaperPositionMode','auto'); 

xax1=datetime('2021-08-01'); xax2=datetime('2021-11-20');     

idc=(strcmp('D_acuminata,D_acuta,D_caudata,D_fortii,D_norvegica,D_odiosa,D_parva,D_rotundata,D_tripos,Dinophysis',class2useTB));
classifier=(classcountTB(:,idc)./ml_analyzedTB);
idm=find(ismember(class2use,{'D_acuminata' 'D_acuta' 'D_caudata' 'D_fortii'...
    'D_norvegica' 'D_odiosa' 'D_parva' 'D_rotundata' 'D_tripos' 'Dinophysis'}));
manual=sum(classcount(:,idm),2)./ml_analyzed;

plot(dtTB,classifier,'k-',dt,manual,'r*'); hold on;

set(gca,'xlim',[xax1 xax2])
datetick('x', 'mmm', 'keeplimits');    
ylabel('Dinophysis (cells/mL)','fontsize',12);
legend('Classifier','Manual');

%% plot Dinophysis microscopy
figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.08], [0.09 0.21]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datetime('2021-05-01'); xax2=datetime('2021-11-20');     

subplot(2,1,1);
plot(T.SampleDate,0.001*T.DinophysisConcentrationcellsL,'k*-')
    set(gca,'xlim',[xax1 xax2],...
        'fontsize', 11,'fontname', 'arial','tickdir','out','xaxislocation','top');   
    ylabel('Dinophysis (cells/mL)','fontsize',11);

subplot(2,1,2);
h = bar(T.SampleDate,0.01*[T.DAcuminata T.DFortii T.DNorvegica T.DOdiosa...
    T.DRotundata T.DParva],'stack','Barwidth',4);
c=brewermap(6,'Spectral');
    for i=1:length(h)
        set(h(i),'FaceColor',c(i,:));
    end  

%    datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 11,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'});   
        ylabel('Fx Dinophysis','fontsize',11);


    lh=legend('acuminata','fortii','norvegica','odiosa','rotundata','parva');
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)+.23 hp(2) hp(3) hp(4)]; hold on    
    lh.Title.String='Species';

if fprint
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r300',[filepath 'NOAA/BuddInlet/Figs/Dinophysis_microscopy_BI.tif']);
end
hold off