%prep Budd Inlet summary class file for Emilie
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';

load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB_2021-2022'])


% remove all classes that are not Dinophysis or Mesodinium
idx=contains(class2useTB,'Mesodinium');
Mesodinium_cellsmL=classC_TB_above_optthresh(:,idx)./ml_analyzedTB;

idx=contains(class2useTB,'Dinophysis');
Dinophysis_cellsmL=classC_TB_above_optthresh(:,idx)./ml_analyzedTB;

save([filepath 'IFCB-Data/BuddInlet/class/BI_Dino-Meso_4Emilie'],...
    'Dinophysis_cellsmL','Mesodinium_cellsmL','filelistTB','runtypeTB','filecommentTB','mdateTB');

%% figure

plot(mdateTB,Mesodinium_cellsmL,'o',mdateTB,Dinophysis_cellsmL,'^')

