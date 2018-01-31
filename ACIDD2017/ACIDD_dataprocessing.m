%% Compile features for the training set

manualpath = 'F:\IFCB104\manual\'; % manual annotation file location
feapath_base = 'F:\IFCB104\features\'; %feature file location, assumes \yyyy\ organization
maxn = 100; %maximum number of images per class to include
minn = 50; %minimum number for inclusion

class2skip = {'unclassified' 'Fragilariopsis' 'Navicula' 'Beads' 'bubbles'...
    'Amy_Gony_Ling_Proc' 'Rhiz_Prob' 'Det_Cer_Lau' 'Entomoneis'};
class2group = {'Cryptophyte' 'NanoP_less10'}; %use nested cells for multiple groups of 2 or more classes 

compile_train_features_user_training(manualpath, feapath_base, maxn, minn,class2skip,class2group);

%% ACIDD2017 - Extract blobs and features and apply classifier

start_blob_batch_user_training(...
    'F:\IFCB104\data\2017\',...
    'F:\IFCB104\blobs\2017\',true);

start_feature_batch_user_training(...
    'F:\IFCB104\data\2017\',...
    'F:\IFCB104\blobs\2017\',...
    'F:\IFCB104\features\2017\',true)

start_classify_batch_user_training(...
    'F:\IFCB104\manual\summary\UserExample_Trees_21Jan2018',...
    'F:\IFCB104\features\2017\',...
    'F:\IFCB104\class\class2017_v1\')

%%
countcells_allTBnew_user_training(...
    'F:\IFCB104\class\classxxxx_v1\',...
    'F:\IFCB104\data\',2017);

%%
load 'F:\IFCB104\class\summary\summary_allTB';

for i=1:(length(class2useTB)-1)
    figure(i)
    classind = i;
    plot(mdateTB, classcountTB(:,classind)./ml_analyzedTB, '.-')
    hold on
    plot(mdateTB, classcountTB_above_optthresh(:,classind)./ml_analyzedTB, 'g.-')
    plot(mdateTB, classcountTB_above_adhocthresh(:,classind)./ml_analyzedTB, 'r.-')
    hold on
    set(gca,'xlim',[datenum('2017-12-17') datenum('2017-12-22')],...   
        'xtick',datenum('2017-12-17'):1:datenum('2017-12-22'),...
        'XTickLabel',{'17-Dec','18-Dec','19-Dec','20-Dec','21-Dec','22-Dec'},...
        'tickdir','out');
    hold on
    legend('All wins', 'Wins above optimal threshold', 'Wins above adhoc threshold')
    ylabel([class2useTB{classind} ', mL^{ -1}'])
   % datetick('x')

    set(gcf,'color','w');
    print(gcf,'-dtiff','-r600',...
        ['C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\ACIDD2017\Figs\WinThrSummary_' class2useTB{classind} '.tif'])
    hold off
end