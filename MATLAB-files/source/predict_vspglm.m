function  vspglm_predict_output = predict_vspglm(model, X_new,Y)
    %X_new needs to be the correct shape
    %Original Y's
    Y2 = table2array(Y);
    num_models = length(model);
    X_new_arr = table2array(X_new);
    X_new_arr = [ones(height(X_new),1),X_new_arr];
    pred = zeros(height(X_new), num_models);
    for k = 1:num_models
       comp_model_beta = model(k).betas;
       comp_link = model(k).link;
       
       if comp_link == "id"
           pred(:,k) = X_new_arr*comp_model_beta;
       elseif comp_link == "logit"
           pred(:,k) = exp(X_new_arr*comp_model_beta)./(1+exp(X_new_arr*comp_model_beta));
       elseif comp_link == "log"
           pred(:,k) = exp(X_new_arr*comp_model_beta);
       elseif comp_list == "inv"
           pred(:,k) = 1./(X_new_arr*comp_model_beta);
       end
    end
    %Backsolve for theta
    %sum_{i=1}^n (Y_i - \mu) exp(Y_i^T \theta)
    phat = model(1).pTilt';
    vspglm_predict_output = struct([]); 
    vspglm_predict_output(1).fitted = pred;
    thetas = zeros(height(X_new), num_models);
    phat_new = zeros(height(X_new), length(Y2));
    b = zeros(height(X_new),1);
    options = optimoptions(@fsolve, 'Display', 'off');
    for j = 1:height(X_new)
        mean_con = @(theta) pred(j,:)' - sum((Y2'.*phat)*exp(theta*Y2')'*exp(-log(sum(phat*exp(theta*Y2')',2))),2);
        thetas(j,:) = fsolve(mean_con, zeros(1,num_models), options);
        b(j) = -log(sum(phat*exp(thetas(j,:)*Y2')',2));
        phat_new(j,:) = phat.*exp(b(j) + thetas(j,:)*Y2');
    end
    vspglm_predict_output(1).thetas = thetas;
    vspglm_predict_output(1).b = b; 
    vspglm_predict_output(1).phat_new = phat_new;
    % Find the covariance matrix for each new observation
    Yvar = cell(1, height(X_new) );
    Y = table2array(Y);
    minMax = cell(1, num_models);    
    for i = 1:num_models
        m = min(Y(:,i));
        M = max(Y(:,i));
        Y(:,i) = (Y(:,i) - (m + M)/2)*(2/(M-m));
        pred(:,i) = (pred(:,i) - (m+M)/2)*(2/(M-m));
        thetas(:,i) = thetas(:,i)*(M-m)/2;
        minMax{i} = [m, M];
    end
    for i = 1:height(X_new)        
        t = zeros(num_models);
        for j = 1:length(Y)
            %t = t + pexp(i,j)*outerY{j};
            phat_new_term = phat.*exp(-log(sum(phat*exp(thetas(i,:)*Y')',2)) + thetas(i,:)*Y');
            t = t + phat_new_term(j)*(Y(j,:).' - pred(i, :).')*(Y(j,:).' - pred(i, :).').';
            % SHOULD IT BE J,I OR I,J. LET'S THINK. No (i,j) is right
            
        end
        Yvar{i} = t;  
        %d = eig(t);
        %assert(all(d >=0), "Not PSD");        
        %lambdas(:, i) = d;        
    end
    vspglm_predict_output(1).yCov= Yvar;
end