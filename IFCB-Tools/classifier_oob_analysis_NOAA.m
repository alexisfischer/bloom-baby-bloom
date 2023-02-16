function [ ] = classifier_oob_analysis_NOAA( classifiername,outpath )
%[ ] = classifier_oob_analysis_NOAA( classifername )
%For example:
% determine_classifier_performance('D:\Shimada\classifier\summary\Trees_12Oct2021')
% input classifier file name with full path
% expects output from make_TreeBaggerClassifier*.m
%   Alexis D. Fischer, NOAA NWFSC, September 2021
%
% Example Inputs
%classifiername='D:\general\classifier\summary\Trees_CCS_NOAA-OSU_v4';
%outpath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\';

load(classifiername,'b','classes','featitles','maxthre','targets');
%%
[Yfit,Sfit,Sstdfit] = oobPredict(b);
[mSfit, ii] = max(Sfit');
for count = 1:length(mSfit) 
    mSstdfit(count) = Sstdfit(count,ii(count)); 
    t(count)= Sfit(count,ii(count)); 
end
if isempty(find(mSfit(:)-t(:), 1))
    clear t 
else disp('check for error...'); 
end

%% winner takes all interpretation of scores
[c_all, class] = confusionmat(b.Y,Yfit); 
total = sum(c_all')'; 
[TP TN FP FN] = conf_mat_props(c_all); % true positive (TP), true negative (TN), false positive (FP), false negative (FN)

R = TP./(TP+FN); %recall (or probability of detection)
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c_all)./sum(c_all)'
F1= 2*((P.*R)./(P+R));

all=table(class,total,R,P,F1);
disp(['winner-takes-all error rate = ' num2str(1-sum(TP)./sum(total)) '']);

clearvars TP TN FP FN total Pm P R ii F1 count class

%% optimal threshold interpretation of scores
t = repmat(maxthre,length(Yfit),1);
win = (Sfit > t);
[i,j] = find(win);
Yfit_max = NaN(size(Yfit));
Yfit_max(i) = j;
ind = find(sum(win')>1);
for count = 1:length(ind)
    [~,Yfit_max(ind(count))] = max(Sfit(ind(count),:));
end
ind = find(isnan(Yfit_max));
Yfit_max(ind) = length(classes)+1; %unclassified set to last class
ind = find(Yfit_max);
classes2 = [classes(:); 'unclassified'];
[c_opt, class] = confusionmat(b.Y,classes2(Yfit_max));
total = sum(c_opt')';
[TP TN FP FN] = conf_mat_props(c_opt);
R = TP./(TP+FN); %recall
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
F1= 2*((P.*R)./(P+R));
disp(['optimal error rate = ' num2str(1-sum(TP)./sum(total)) '']);

totalfxun=length(find(Yfit_max==length(classes2)))./length(Yfit_max);
fxUnclass = c_opt(:,end)./total;
fxUnclass(end)=totalfxun;
opt=table(class,total,R,P,F1,fxUnclass);

% ignore unclassified
c_optb = c_opt(1:end-1,1:end-1); %ignore the instances in 'unknown'
total = sum(c_optb')';
[TP TN FP FN] = conf_mat_props(c_optb);
R = TP./(TP+FN); %recall
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
F1= 2*((P.*R)./(P+R));
disp(['optimal error rate (ignore unclassified) = ' num2str(1-sum(TP)./sum(total)) '']);

optb=table(class(1:end-1),total,R,P,F1);

clearvars TP TN FP FN total ind count i ii t j classes2 class Pm P R ind F1 totalfxun fxUnclass


%% how did regional classifier do on NWFSC dataset
idx = contains(targets,{'IFCB777' 'IFCB117' 'IFCB150'});

MC=b.Y;
[C, class] = confusionmat(MC(idx),Yfit(idx)); 
[~,idx]=sort(class);class=class(idx);C=C(idx,idx);
total = sum(C')'; 
[TP TN FP FN] = conf_mat_props(C);
R= TP./(TP+FN); %recall (or probability of detection)
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
P(P==0)=NaN;
F1= 2*((P.*R)./(P+R));

%find gaps, if they exist
NOAA=all;
[~,ib]=ismember(classes,class);
for i=1:length(ib)
    if ib(i)>0
        NOAA.total(i)= total(ib(i));
        NOAA.R(i)= R(ib(i));
        NOAA.P(i)= P(ib(i));        
        NOAA.F1(i)= F1(ib(i));                
    else
        NOAA.total(i)=0;
        NOAA.R(i)=NaN;
        NOAA.P(i)=NaN;        
        NOAA.F1(i)=NaN;                
    end
end

%% how did regional classifier do on the OSU dataset
idx = find(contains(targets,'IFCB122'));
MC=b.Y;
[C, class] = confusionmat(MC(idx),Yfit(idx)); 
[~,idx]=sort(class);class=class(idx);C=C(idx,idx);
total = sum(C')'; 
[TP TN FP FN] = conf_mat_props(C);
R= TP./(TP+FN); %recall (or probability of detection)
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
P(P==0)=NaN;
F1= 2*((P.*R)./(P+R));

%find gaps, if they exist
OSU=all;
[~,ib]=ismember(classes,class);
for i=1:length(ib)
    if ib(i)>0
        OSU.total(i)= total(ib(i));
        OSU.R(i)= R(ib(i));
        OSU.P(i)= P(ib(i));        
        OSU.F1(i)= F1(ib(i));                
    else
        OSU.total(i)=0;
        OSU.R(i)=NaN;
        OSU.P(i)=NaN;        
        OSU.F1(i)=NaN;                
    end
end

%% how did regional classifier do on UCSC dataset
idx = contains(targets,'IFCB104');
MC=b.Y;
[C, class] = confusionmat(MC(idx),Yfit(idx)); 
[~,idx]=sort(class);class=class(idx);C=C(idx,idx);
total = sum(C')';
[TP TN FP FN] = conf_mat_props(C);

R= TP./(TP+FN); %recall (or probability of detection)
P= TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
P(P==0)=NaN;
F1= 2*((P.*R)./(P+R));

%find gaps, if they exist
UCSC=all;
[~,ib]=ismember(classes,class);
for i=1:length(ib)
    if ib(i)>0
        UCSC.total(i)= total(ib(i));
        UCSC.R(i)= R(ib(i));
        UCSC.P(i)= P(ib(i));        
        UCSC.F1(i)= F1(ib(i));                
    else
        UCSC.total(i)=0;
        UCSC.R(i)=NaN;
        UCSC.P(i)=NaN;        
        UCSC.F1(i)=NaN;                
    end
end

clearvars TP TN FP FN R P MC idx total classi

%% sorting features according to the best ones
figure('Units','inches','Position',[1 1 3.5 3],'PaperPositionMode','auto');
[~,ind]=sort(b.OOBPermutedVarDeltaError,2,'descend');
bar(sort(b.OOBPermutedVarDeltaError,2,'descend'))
ylabel('Feature importance')
xlabel('Feature ranked index')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\Feature_importance.png']);
hold off

disp(['Most important features: ' ])
topfeat=featitles(ind(1:20))'

%% plot threshold scores
figure('Units','inches','Position',[1 1 6 4.5],'PaperPositionMode','auto');
boxplot(max(Sfit'),b.Y)
ylabel('Out-of-bag winning scores')
set(gca, 'xtick', 1:length(classes), 'xticklabel', [], 'ylim', [0 1])
text(1:length(classes), -.1*ones(size(classes)), classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
hold on, plot(1:length(classes), maxthre, '*g')

title('score threshold = 0')
lh = legend('optimal threshold score','Location','NE'); set(lh, 'fontsize', 10)

set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\class_vs_thresholdscores.png']);
hold off

save([outpath 'performance_classifier_' classifiername(37:end) ''],...
    'topfeat','NOAA','UCSC','OSU','all','opt','optb','c_all','c_opt','c_optb','maxthre');

end