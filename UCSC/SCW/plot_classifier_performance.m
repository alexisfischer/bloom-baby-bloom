%% plot classifier performance
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/IFCB_summary/summary_classifier']);%,'classes2','TP','TN','FP','FN');

classes=classes2(1:end-1);
FN(end-2:end)=[]; FP(end-2:end)=[]; TN(end-2:end)=[]; TP(end-2:end)=[];

%sensitivity, true positive rate  
TPR = TP./(TP+FN); %How "sensitive" is the classifier to detecting positive instances?

%specificity, true negative rate
TNR = TN./(TN+FP); % How "specific" (or "selective") is the classifier in predicting positive instances?

    text_offset = 0.01;

    figure('Units','inches','Position',[1 1 7 5],'PaperPositionMode','auto');
    bar([TPR TNR])
    set(gca, 'xtick', 1:length(classes), 'xticklabel', [])
    text(1:length(classes), -text_offset.*ones(size(classes)), classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45,'fontsize',12) 
    set(gca, 'position', [ 0.13 0.35 0.8 0.6],'fontsize',12)
    legend('Sensitivity (TPR) ', 'Specificity (TNR)','Location','NorthOutside')
    legend boxoff;
    % set figure parameters
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r200',[filepath 'Figs/Sensitivity_Specificity']);
    hold off    
    
    %%
    idx = strmatch('Dinophysis', classes); %classifier index

    TP(idx)
    TN(idx)
    FP(idx)
    FN(idx)
    
    TPR = TP(idx)./(TP(idx)+FN(idx)) 
    Pr = TN(idx)./(TN(idx)+FP(idx)) 