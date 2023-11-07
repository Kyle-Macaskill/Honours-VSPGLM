function vspglm_predict_output = vspglmJointPredict(model,Y, mu, stem_flag)
    %X_new needs to be the correct shape
    %Original Y's
    Y2 = table2array(Y);
    
    min_Y_1 = min(Y2(:,1));
    min_Y_2 = min(Y2(:,2));
    max_Y_1 = max(Y2(:,1));
    max_Y_2 = max(Y2(:,2));
    num_models = length(mu);
    offset = 0.5;
    pred = mu;
    %Backsolve for theta
    %sum_{i=1}^n (Y_i - \mu) exp(Y_i^T \theta)
    phat = model(1).pTilt';
    vspglm_predict_output = struct([]); 
    vspglm_predict_output(1).fitted = pred;
    thetas = zeros(1, num_models);
    phat_new = zeros(1, length(Y2));
    b = zeros(1,1);
    options = optimoptions(@fsolve, 'Display', 'off');
    
    mean_con = @(theta) pred' - sum((Y2'.*phat)*exp(theta*Y2')'*exp(-log(sum(phat*exp(theta*Y2')',2))),2);
    thetas= fsolve(mean_con, zeros(1,num_models), options);
    b = -log(sum(phat*exp(thetas*Y2')',2));
    phat_new= phat.*exp(b + thetas*Y2');
   
    vspglm_predict_output(1).thetas = thetas;
    vspglm_predict_output(1).b = b; 
    vspglm_predict_output(1).phat_new = phat_new;
    
    
    unique_vals = uniquetol(Y2,1e-5,'ByRows',true);
    masses_per_val = zeros(length(unique_vals),1);
    
     for j = 1:length(unique_vals)
           index_to_sum = find(ismember( Y2,unique_vals(j,:), 'rows') == 1);
           %disp(index_to_sum)
           masses_per_val(j) = sum(phat_new(index_to_sum));
           
           %Do we need to re-weight???
           %masses_per_val(i,j) = sum(masses(index_to_sum))/length(index_to_sum);
     end
     sizes = masses_per_val*((length(unique_vals)-1)/0.1169);
     indexes = round(sizes+1);
     colormap_length = round(length(unique_vals));
     max(masses_per_val)

       %colors = jet(colormap_length); %For burns and UN
      colors = parula(colormap_length); %For burns and UN
       %colors = winter(length(unique_vals)); % For sorbinal

      colors_plot = colors(indexes,:);
       %Make scaling w.r.t area 
      sizes = (masses_per_val)*10000;
      
      if stem_flag == '3d'
           stem3(unique_vals(:,1), unique_vals(:,2), masses_per_val,'filled','LineWidth', 1.5);
           zlim([0, max(phat_new)]);
           hold on
           plot(mu(1),mu(2), '+k', 'linewidth',3, 'MarkerSize', 12);
           
       else 
            scatter(unique_vals(:,1), unique_vals(:,2), sizes, colors_plot,'filled');
            hold on
            axis([min_Y_1-offset, max_Y_1+offset, min_Y_2-offset, max_Y_2+offset]);
            plot(mu(1),mu(2), '+k', 'linewidth',3, 'MarkerSize', 12);
            %colorbar;
            %caxis([0,max(phat_new)]);
       end
      
       
     

end