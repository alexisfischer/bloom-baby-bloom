%% create table of classifier output
%IFCB classifier analysis: return number of true positive (TP), true
%negative (TN), false positive (FP), and false negative (FN) instances in
%an input confusion matrix (c), with convention as produced by confusionmat

%Pd = Probability of Detection TP./(TP+FN)
%Pr = Precision TP/(TP+FP)
    
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/'; 
load([filepath 'Data/IFCB_summary/summary_classifier'],'classes2','total','Pd3','Pr3','FP','FN','TP','TN')

classes2(end)=[];
Pd3(end)=[];
Pr3(end)=[];

disp('error rate for accepted classifications (no unclassified, optimal score threshold):')
disp(1-sum(TP)./sum(total))

[TOTAL,i] = sort(total,'descend');
classes=classes2(i);
Pd=round(Pd3(i),2,'significant');
Pr=round(Pr3(i),2,'significant');
FP=FP(i); FN=FN(i); TP=TP(i); TN=TN(i);

clearvars Pd3 Pr3 total classes2 i;