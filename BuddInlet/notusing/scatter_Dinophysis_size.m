%% plot Dinophysis size vs bloom
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

class2do_string='Dinophysis'; ymax=15;

load([filepath 'NOAA/BuddInlet/Data/BuddInlet_data_summary'],'T','Tc','fli','sci');
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   

[~,label]=get_class_ind(class2do_string,'all',class_indices_path);

% only look at May through September
T(isnan(T.dino_fl),:)=[];
idx=find(T.dt.Month==3 | T.dt.Month==4 | T.dt.Month==10 | T.dt.Month==11 | T.dt.Month==12); 
T(idx,:)=[];

id1=(T.dt.Year==2021); id2=(T.dt.Year==2022); id3=(T.dt.Year==2023); 

figure;
scatter(cumsum(T.dino_fl(id2)),T.dSize_fl(id2)); hold on;
scatter(cumsum(T.dino_fl(id3)),T.dSize_fl(id3)); hold on;
box on;
xlabel('cumulative cells/mL')
ylabel('ESD (um)')
title('Dinophysis')
legend('2022','2023','location','NW')

%%
figure;
scatter((T.dino_fl(id2)),T.dSize_fl(id2)); hold on;
scatter((T.dino_fl(id3)),T.dSize_fl(id3)); hold on;
box on;
xlabel('cells/mL')
ylabel('ESD (um)')
title('Dinophysis')
legend('2022','2023','location','SE')


