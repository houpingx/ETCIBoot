clear;
clc;
%% load data
 load('step_dataset.txt') % name of variable is step_dataset
 load('step_ground_truth.txt') % name of variable: step_ground_truth
 dataset = step_dataset;
 gd_truth = step_ground_truth;
 if (~issorted(gd_truth(:,1)))
     gd_truth = sortrows(gd_truth,1);
 end
 [list_enty,entry_ia,entry_ic] = unique(gd_truth(:,1));
 gd_truth = gd_truth(entry_ia,:);

% set parameters
iteration=2; % number of iterations
alpha=0.025; % significant level
%%
disp('running ETCIBoot on')
[truth,CI,boot_t] = ETCIBootV2( dataset,200,alpha,10);
label_truth1 = truth(find( ismember(truth(:,1),gd_truth(:,1)) ),:);
mad_boot = MAD( gd_truth(:,2),label_truth1(:,2) );
rmse_boot = RMSE( gd_truth(:,2),label_truth1(:,2) );
[mad_boot rmse_boot]