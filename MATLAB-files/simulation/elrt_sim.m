%% Generate the data
N = 1000;
beta_est = zeros(N, 4);
beta_est_param_1 = zeros(N,4);
beta_est_param_2 = zeros(N,4);
beta_est_param_3 = zeros(N,4);
se_est = zeros(N,4);
se_est_param_1 = zeros(N,4);
se_est_param_2 = zeros(N,4);
se_est_param_3 = zeros(N,4);
loglik = zeros(N,4);
formulas = ["(Y1,Y2) ~ (X11 & X21),(X12 & X22),(X13 & X23))"];
%formulas = ["Y1 ~ X11, X12", "Y2 ~ X21, X22"];
links = {'id', 'id'};
true_param = [1,-1,0,0.67];
%% 
for j = 1:N
    fprintf("Iteration %d", j);
n = 50;
% simData = array2table( zeros(n,6) ...
%                       , 'VariableNames' ...
%                      , {'X11', 'X12', 'X21', 'X22', 'Y1', 'Y2'});
simData = array2table( zeros(n,8) ...
                       , 'VariableNames' ...
                       , {'X11', 'X12', 'X13', 'X21', 'X22',  'X23', 'Y1', 'Y2'});
covar = [0.8, 0.4; 0.4, 1.2];
%beta_1 = [-1;0];
%beta_2 = [0.5; 2.2];

beta_1 = [-1;0;0.67];
%beta_2 = [0.5; 2.2;-1.25];

sim = zeros(n, 2);
for i = 1:n
%     X = 2*rand(2,2)-1;
%     sim(i,:) = mvnrnd([1 + X(1,:)*beta_1, 1 + X(2,:)*beta_2], covar);
%     simData(i,:) = array2table([X(1,:),X(2,:),sim(i,:)]);
%     
   X = 2*rand(2,3)-1;
   sim(i,:) = mvnrnd([1 + X(1,:)*beta_1, 1 + X(2,:)*beta_1], covar);
   simData(i,:) = array2table([X(1,:),X(2,:),sim(i,:)]);
end
[sim_model] = fit_vspglm(formulas, simData, links);
beta_est(j,1:4) = sim_model.coefficients.estimates';
se_est(j,1:4) = sim_model.coefficients.StdError';
loglik(j,1) = sim_model.loglike;

[sim_model2] = fit_vspglm_constraint(formulas, simData, links,2,-1);
[sim_model3] = fit_vspglm_constraint(formulas, simData, links,3,0);
[sim_model4] = fit_vspglm_constraint(formulas, simData, links,4,0.67);
beta_est_param_1(j,1:4) = sim_model2.coefficients.estimates';
beta_est_param_2(j,1:4) = sim_model3.coefficients.estimates';
beta_est_param_3(j,1:4) = sim_model4.coefficients.estimates';
se_est_param_1(j,1:4) = sim_model2.coefficients.StdError';
se_est_param_2(j,1:4) = sim_model3.coefficients.StdError';
se_est_param_3(j,1:4) = sim_model4.coefficients.StdError';
loglik(j,2) = sim_model2.loglike;
loglik(j,3) = sim_model3.loglike;
loglik(j,4) = sim_model4.loglike;

end

%% 

