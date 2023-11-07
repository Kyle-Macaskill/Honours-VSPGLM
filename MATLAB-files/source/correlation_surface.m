function correlation_surface(model, dim_1, dim_2, sim)
    pred = model.means;
    
    mu_con = [pred(:,dim_1),pred(:,dim_2)];
    [k,av] = convhull(mu_con);

    min_theta_1 = min(model(1).thetas{dim_1});
    max_theta_1 = max(model(1).thetas{dim_1});

    min_theta_2 = min(model(1).thetas{dim_2});
    max_theta_2 = max(model(1).thetas{dim_2});
    
    pred_mu_final = zeros(sim.^2, 2);
    corr_mu = zeros(sim.^2,1);
    corr_mat = zeros(sim,sim);
    mu_X = zeros(sim, sim);
    mu_Y = zeros(sim, sim);
    theta_1_val = linspace(min_theta_1, max_theta_1, sim);
    theta_2_val = linspace(min_theta_2, max_theta_2, sim);
    [theta_X, theta_Y] = meshgrid(theta_1_val, theta_2_val);
    counter = 1;

    %IN = inpolygon(theta_X, theta_Y, theta_con(k,1), theta_con(k,2));
    for i = 1:sim
        for p = 1:sim
            theta_1 = theta_X(i,p);
            theta_2 = theta_Y(i,p);

            phat = model(1).pTilt;
            Y_1 = model(1).Y{dim_1};
            Y_2 = model(1).Y{dim_2};

            % %Re-scale Y's
            max_1 = max(Y_1);
            min_1 = min(Y_1);
            max_2 = max(Y_2);
            min_2 = min(Y_2);

            Y_1 = (Y_1 - (max_1+min_1)/2)*(2/(max_1-min_1));
            Y_2 = (Y_2 - (max_2+min_2)/2)*(2/(max_2-min_2));

            theta_1 = theta_1*(max_1-min_1)/2;
            theta_2 = theta_2*(max_2-min_2)/2;

            Y_vec = [Y_1, Y_2];
            theta = [theta_1; theta_2];
            % Find the new value for b

            b = 0;
            for j = 1:length(Y_1)
               b = b + phat(j)*exp(theta'*Y_vec(j,:)');
            end
            b_norm = -log(b);

            pred_mu = zeros(2,1);
            for j = 1:length(Y_1)
               pred_mu = pred_mu + phat(j)*Y_vec(j,:)'*exp(b_norm + theta'*Y_vec(j,:)');
            end
            mu_trans = [pred_mu(1)*(max_1-min_1)/2 + (max_1+min_1)/2 ; pred_mu(2)*(max_2-min_2)/2 + (max_2+min_2)/2];
            if not(inpolygon(mu_trans(1), mu_trans(2), mu_con(k,1), mu_con(k,2)))
                corr_mu(counter) = NaN;
                mu_X(i,p) =  pred_mu(1)*(max_1-min_1)/2 + (max_1+min_1)/2;
                mu_Y(i,p) = pred_mu(2)*(max_2-min_2)/2 + (max_2+min_2)/2;
                pred_mu_final(counter,1) = pred_mu(1)*(max_1-min_1)/2 + (max_1+min_1)/2;
                pred_mu_final(counter,2) =  pred_mu(2)*(max_2-min_2)/2 + (max_2+min_2)/2;
                counter = counter + 1;
                continue
            end

            covar_test = zeros(2,2);
            for j = 1:length(Y_1)
               covar_test = covar_test + phat(j)*(Y_vec(j,:)' - pred_mu)*(Y_vec(j,:)' - pred_mu)'*exp(b_norm + theta'*Y_vec(j,:)');
            end
            corr_mu(counter) = covar_test(1,2)/(sqrt(covar_test(2,2))*sqrt(covar_test(1,1)));
            corr_mat(i,p) = corr_mu(counter);
            pred_mu_final(counter,1) =  pred_mu(1)*(max_1-min_1)/2 + (max_1+min_1)/2;
            pred_mu_final(counter,2) =  pred_mu(2)*(max_2-min_2)/2 + (max_2+min_2)/2;
            mu_X(i,p) =  pred_mu(1)*(max_1-min_1)/2 + (max_1+min_1)/2;
            mu_Y(i,p) = pred_mu(2)*(max_2-min_2)/2 + (max_2+min_2)/2;
            counter = counter + 1;
        end
    end


    pred = model.means;
    z = zeros(1,length(pred));

    % Extract the correlations
    for n = 1:length(pred)
        covar = model.yCovariance;
        covar_n = covar{n};
        z(n) = covar_n(dim_1,dim_2)/(sqrt(covar_n(dim_1,dim_1))*sqrt(covar_n(dim_2,dim_2)));
    end

    figure(1)
    dotsize = 30;
    scatter3(pred_mu_final(:,1), pred_mu_final(:,2),corr_mu, dotsize, corr_mu, 'filled')
    hold on
    scatter3(pred(:,dim_1),pred(:,dim_2),z, dotsize, z, 'filled')
    %plot(mu_con(k,1),mu_con(k,2), 'k')
    view(0, 90)
    %colorbar
    %xlabel("logGDPpp")
    %ylabel("logFertility")
    %title("Fitted Model and Correlation")
%     
%     figure(2)
%     contourf(mu_X, mu_Y,corr_mat);
%     
%     pred_mu_final = [pred_mu_final;pred];
%     corr_mu = [corr_mu;z'];
%     figure(2)
%     y1lin = linspace(min(pred(:,dim_1)), max(pred(:,dim_1)), 500);
%     y2lin = linspace(min(pred(:,dim_2)), max(pred(:,dim_2)), 500);
%     [X,Y] = meshgrid(y1lin, y2lin);
%     Z = griddata(pred_mu_final(:,1),pred_mu_final(:,2),corr_mu,X,Y, 'cubic');
%     mesh(X,Y,Z)
%     view(0, 90)

end