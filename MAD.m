function mad_value = MAD(truth, estimated_truth)

%temp = abs(truth - estimated_truth);


%mad_value = mean(temp)/size(truth, 1);
mad_value=sum(abs(estimated_truth - truth))/length(truth);
%return mae_value