%% plot a histogram of PN chain length from 2019 and 2021 Hake surveys
% input IFCB manually annotated data
% Shimada 2019 and 2021
% A.D. Fischer, May 2024
%
clear;

filepath = '~/Documents/MATLAB/';
addpath(genpath(filepath));

load([filepath 'ifcb-data-science/IFCB-Data/Shimada/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');

label={'1cell','2cell','3cell','4cell','5cell'};
for i=1:length(label)
    ax(i)=subplot(1,5,i);   
    val(:,i)=sum(classcount(:,contains(class2use,label(i))),2);
end

%%%% plot 
figure('Units','inches','Position',[1 1 3 3],'PaperPositionMode','auto');

Y=sum(val,1);
X = categorical(label);
X = reordercats(X,label);
bar(X,Y)
set(gca,'fontsize',10)

ylabel('image frequency','fontsize',12)
title('\itPseudo-nitzschia \rmspp.','fontsize',12)

% set figure parameters
exportgraphics(gcf,[filepath 'bloom-baby-bloom/Shimada/Figs/PN_histogram_CCS.png'],'Resolution',100)    
hold off
