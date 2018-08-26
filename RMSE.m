function rmse_value = RMSE(truth, estimated_truth)


%temp = (truth - estimated_truth)' *(truth - estimated_truth);


%rmse_value = sqrt(temp);
rmse_value = sqrt(sum((estimated_truth-truth).^2)/length(truth));