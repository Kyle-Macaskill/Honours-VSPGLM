mean(beta_est(:,1:6)) - [1, -1, 0, 1, 0.5, 2.2]
length_sum = 1000;
fprintf("Estimated standard errors\n")
mean(se_est(1:length_sum,1:6))
fprintf("Std of estimates\n")
std(beta_est(1:length_sum,1:6))
%% 

subplot(2,4,1)
hist(beta_est(1:length_sum,2))
title('Histogram of $\hat{\beta}$ for $\beta = -1$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(2,4,2)
qqplot(beta_est(1:length_sum,2))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(2,4,3)
hist(beta_est(1:length_sum,3))
title('Histogram of $\hat{\beta}$ for $\beta = 0$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(2,4,4)
qqplot(beta_est(1:length_sum,3))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(2,4,5)
hist(beta_est(1:length_sum,5))
title('Histogram of $\hat{\beta}$ for $\beta = 0.5$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(2,4,6)
qqplot(beta_est(1:length_sum,5))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(2,4,7)
hist(beta_est(1:length_sum,6))
title('Histogram of $\hat{\beta}$ for $\beta = 2.2$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(2,4,8)
qqplot(beta_est(1:length_sum,6))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')


%% 
t_mat = [1.660881,1.984984,2.628016; %qt([0.95, 0.975, 0.995, 100-4)
1.652665,1.972141, 2.601145; %qt([0.95, 0.975, 0.995, 200-4)
1.661226,1.985523,2.629148; %qt([0.95, 0.975, 0.995, 100-6)
1.652746,1.972268,2.601409 %qt([0.95, 0.975, 0.995, 200-6)
]; 
z_score = [1.644854, 1.959964, 2.575829];
t = t_mat(2,:);
%t = z_score;

for c = 1:3
    if c == 1
        fprintf("90 percent CI \n")
    elseif c == 2
        fprintf("95 percent CI\n")
    else
        fprintf("99 percent CI\n")
    end
    for i = 1:6
        if i == 1 || i == 4
            continue
            
        end
    length_sim = length_sum;
    index = i;
    %true_param = [1, -1, 0, 0.67, 1, 0.5, 2.2, -1.25];
    true_param = [1, -1, 0, 1, 0.5, 2.2];
    t_cutoff = t(c);
  
    lower_ci = beta_est(1:length_sim,index)-t_cutoff*se_est(1:length_sim,index);
    upper_ci = beta_est(1:length_sim,index)+t_cutoff*se_est(1:length_sim,index);
    coverage = sum((lower_ci < true_param(index)) & (upper_ci > true_param(index)));
    fprintf("param %d coverage %.3f\n", i, coverage/length_sim);
    end
end

%%
mean(beta_est(:,1:8)) - [1, -1, 0,0.67, 1, 0.5, 2.2, -1.25]
%mean(beta_est(:,1:6)) - [1, -1, 0, 1, 0.5, 2.2]
length_sum = 1000;
fprintf("Estimated standard errors\n")
mean(se_est(1:length_sum,1:8))
fprintf("Std of estimates\n")
std(beta_est(1:length_sum,1:8))
%% 

subplot(3,4,1)
hist(beta_est(1:length_sum,2))
title('Histogram of $\hat{\beta}$ for $\beta = -1$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(3,4,2)
qqplot(beta_est(1:length_sum,2))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(3,4,3)
hist(beta_est(1:length_sum,3))
title('Histogram of $\hat{\beta}$ for $\beta = 0$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(3,4,4)
qqplot(beta_est(1:length_sum,3))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(3,4,5)
hist(beta_est(1:length_sum,4))
title('Histogram of $\hat{\beta}$ for $\beta = 0.67$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(3,4,6)
qqplot(beta_est(1:length_sum,4))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(3,4,7)
hist(beta_est(1:length_sum,6))
title('Histogram of $\hat{\beta}$ for $\beta = 0.5$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(3,4,8)
qqplot(beta_est(1:length_sum,6))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(3,4,9)
hist(beta_est(1:length_sum,7))
title('Histogram of $\hat{\beta}$ for $\beta = 2.2$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(3,4,10)
qqplot(beta_est(1:length_sum,7))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(3,4,11)
hist(beta_est(1:length_sum,8))
title('Histogram of $\hat{\beta}$ for $\beta = -1.25$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(3,4,12)
qqplot(beta_est(1:length_sum,8))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
%% 
t_mat = [1.660881,1.984984,2.628016; %qt([0.95, 0.975, 0.995, 100-4)
1.652665,1.972141, 2.601145; %qt([0.95, 0.975, 0.995, 200-4)
1.661226,1.985523,2.629148; %qt([0.95, 0.975, 0.995, 100-6)
1.652746,1.972268,2.601409 %qt([0.95, 0.975, 0.995, 200-6)
]; 
t = t_mat(3,:);
%t = z_score;

for c = 1:3
    if c == 1
        fprintf("90 percent CI \n")
    elseif c == 2
        fprintf("95 percent CI\n")
    else
        fprintf("99 percent CI\n")
    end
    for i = 1:8
    length_sim = length_sum;
    index = i;
    true_param = [1, -1, 0, 0.67, 1, 0.5, 2.2, -1.25];
    %true_param = [1, -1, 0, 1, 0.5, 2.2];
    t_cutoff = t(c);
  
    lower_ci = beta_est(1:length_sim,index)-t_cutoff*se_est(1:length_sim,index);
    upper_ci = beta_est(1:length_sim,index)+t_cutoff*se_est(1:length_sim,index);
    coverage = sum((lower_ci < true_param(index)) & (upper_ci > true_param(index)));
    fprintf("param %d coverage %.3f\n", i, coverage/length_sim);
    end
end
