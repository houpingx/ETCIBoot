function [truth,CI,tt] = ETCIBootV2( dataset,iteration,alpha,K)
% clear
% % load data
% load('step_dataset.txt') % name of variable is step_dataset
% load('step_ground_truth.txt') % name of variable: step_ground_truth
% dataset = step_dataset;
% gd_truth = step_ground_truth;
% set parameters
%iteration=2; % number of iterations
%alpha=0.025; % significant level
%psuedo_count = 0.1;
t1 = tic;
% reorganize data so that entity IDs are ordered
if (~issorted(dataset(:,1)))
	dataset=sortrows(dataset,1);
end

% get basic structures of the dataset
[list_entry,entry_ia,entry_ic]=unique(dataset(:,1),'rows','first'); % for structure of entities
[list_source,~,source_ic]=unique(dataset(:,3)); % for structure of sources
nof=size(dataset,1); % number of fact
nos=max(list_source);% number of sources
noe=length(entry_ia);% number of entities
entry_ia(noe+1)=nof+1;%modify entry_ia s.t. we know the beginning and ending rows of each entity

%initialize weight
weight=1/nos*ones(nos,1);
weight_matrix=weight(source_ic);

%initial truth
% calculate the inital truth
for i=1:noe % for each entity, do:
    tempvalue=dataset(entry_ia(i):(entry_ia(i+1)-1),2); % get the chunk of the claims from all sources
    truth_median(i,:)=median(tempvalue); % get median
    standerror(i,:)=std(tempvalue); % get standard divination
    if standerror(i,:)==0
        standerror(i,:)=0.1;
    end
end
% update truth
truth=truth_median;
truth_matrix=truth((entry_ic),:); 
std_matrix=standerror(entry_ic);

% start iteration
ii=1;
while(ii<= iteration)
    ii=ii+1;
    con_count=zeros(nos,1);
    score2=zeros(nos,1);
    score3 = zeros( nos,1 );
    score4 = zeros( nos,1 );
    
    % ----------------------------------------------------------------------
    %update weight
    for j=1:nof % for each fact
        score3(dataset(j,3)) = score3(dataset(j,3))+sum((dataset(j,2)-truth_matrix(j,:)).^2);
        score2(dataset(j,3)) = score2(dataset(j,3))+sum((dataset(j,2)-truth_matrix(j,:)).^2/std_matrix(j)); % update sum of distance for the corresponding source
        con_count(dataset(j,3)) = con_count(dataset(j,3))+1; % update count of claims for the corresponding source
    end
    % remove empty sources
    score2(con_count==0)=[];
    con_count(con_count==0)=[];
    
    for source_i=1:length(con_count) % for each source
        score4( source_i ) = score3( source_i ) / con_count( source_i );
        weight(source_i)=chi2inv(alpha,con_count(source_i))/(score2(source_i)+0.0001); % calculate weight
    end

    weight_matrix=weight(source_ic); 
	% ----------------------------------------------------------------------
    %update truth
    CI = [];
    for i=1:noe % for each entity
        % calculate the truth for each object using the original data
        sn = entry_ia(i):(entry_ia(i+1)-1);
        tempvalue = dataset( sn,2 );
        tempweight = weight_matrix( sn );
        theta = (tempvalue'*tempweight) / sum(tempweight);
        
        tsource = dataset( sn,3 );
        tvariance = score4( tsource );
        tweight = weight_matrix( sn );
        variance = sqrt( sum( (tweight.^2).* tvariance )/ (sum( tweight)^2 ));
        % bootstrapping
        T = K * length( sn );
        jack_truth = zeros( T,1 );
        theta_dist = zeros( T,1 );
        for t = 1 : T
            seed = unidrnd( length( sn ), 1, length( sn ) );
            snn = sn ( seed );
            tempvalue_b = dataset( snn,2 );
            tempweight_b = weight_matrix( snn );
            theta_b = ( tempvalue_b' * tempweight_b ) / sum( tempweight_b );
            jack_truth( t,: ) = theta_b;
            
            tempsource = dataset( snn,3 );
            tempvariance = score4( tempsource );
            tempweight2 = weight_matrix( snn );
            estvariance = sqrt( sum( (tempweight2.^2).* tempvariance )/ (sum( tempweight2)^2 ));
            
            theta_dist( t,: ) = (theta_b - theta) / estvariance * sqrt(length(sn));
        end
        truth( i,: ) = mean( jack_truth );
        
        
        if (ii >= iteration-1)
        dist = sort( theta_dist );
%         ci_l = truth( i,: ) - dist( floor(T*(1-alpha/2))+1 )*std(jack_truth)/sqrt( length( sn ) );
%         ci_r = truth( i,: ) - dist( floor(T*(alpha/2))+1 )*std(jack_truth)/sqrt( length( sn ) );
        ci_l = truth( i,: ) - dist( floor(T*(1-alpha/2))+1 )*variance/sqrt(length(sn));
        ci_r = truth( i,: ) - dist( floor(T*(alpha/2))+1 )*variance/sqrt(length(sn));
        CI = [CI; ci_l ci_r];
        end
    end
   
	
    truth_matrix=truth((entry_ic),:);
	% ----------------------------------------------------------------------
end
% put truth with entity index
truth=[list_entry,truth];
tt = toc(t1);
end
% label_truth = truth(gd_truth(:,1),:);
% MAD( gd_truth(:,2),label_truth(:,2) )
% RMSE( gd_truth(:,2),label_truth(:,2) )
