function  phat_max = preprocess_max(model, formulas,Y, stem_flag, pause)
    
    ypred2 = model.means;
    phat_max = 0;

    %Goal, for each of the groups, look at how the probability masses are
    %tilted? Groups are associated with unique covariate pairs?
    groups = uniquetol(ypred2,1e-8,'ByRows',true); %Change tolerance!
    [~, ind] = sortrows(round(groups, 4));
    groups = groups(ind,:);
    unique_cov = 1:length(groups);
    unique_vals = uniquetol(Y,1e-5,'ByRows',true);
    
   
    masses_per_val = zeros(length(groups), length(unique_vals));
    phat = model.pTiltMatrix;
    
    %Is there a way for me to find the max mass?

    for i = unique_cov
       
       obs_in_group = find(all(ismembertol( ypred2,groups(i,:), 1e-8, 'ByRows', true),2)==1);
       %Plotting the unique pairs


       %masses = sum(phat(obs_in_group,:),1);
       
       masses = phat(obs_in_group,:);
       masses = masses(1,:);
        
       %masses = sum(phat(obs_in_group,:),1);
       for j = 1:length(unique_vals)
           index_to_sum = find(ismember( Y,unique_vals(j,:), 'rows') == 1);
           %disp(index_to_sum)
           masses_per_val(i,j) = sum(masses(index_to_sum));
           
           %Do we need to re-weight???
           %masses_per_val(i,j) = sum(masses(index_to_sum))/length(index_to_sum);
       end
       %hist3(Y, 'Nbins', [5,100])
       
       % If we re-scale, make sure it's actually a pdf by re-scaling.
       masses_per_val(i,:) = masses_per_val(i,:)/sum(masses_per_val(i,:));
       
       
    end

    phat_max = max(max(masses_per_val));
end

