%% Generate the data
N = 2;
beta_est = zeros(N, 8);
se_est = zeros(N,8);
%formulas = ["Y1 ~ X11, X12, X13", "Y2 ~ X21, X22, X23"];
formulas = ["Y1 ~ X11, X12", "Y2 ~ X21, X22"];
links = {'id', 'id'};
%% 
for j = 1:N
n = 100;
simData = array2table( zeros(n,6) ...
                      , 'VariableNames' ...
                     , {'X11', 'X12', 'X21', 'X22', 'Y1', 'Y2'});
% simData = array2table( zeros(n,8) ...
%                        , 'VariableNames' ...
%                        , {'X11', 'X12', 'X13', 'X21', 'X22',  'X23', 'Y1', 'Y2'});
covar = [0.8, 0.4; 0.4, 1.2];
beta_1 = [-1;0];
beta_2 = [0.5; 2.2];

% beta_1 = [-1;0;0.67];
% beta_2 = [0.5; 2.2;-1.25];

sim = zeros(n, 2);
for i = 1:n
    X = 2*rand(2,2)-1;
    sim(i,:) = mvnrnd([1 + X(1,:)*beta_1, 1 + X(2,:)*beta_2], covar);
    simData(i,:) = array2table([X(1,:),X(2,:),sim(i,:)]);
%     
%    X = 2*rand(2,3)-1;
%    sim(i,:) = mvnrnd([1 + X(1,:)*beta_1, 1 + X(2,:)*beta_2], covar);
%    simData(i,:) = array2table([X(1,:),X(2,:),sim(i,:)]);
end
[sim_model, f] = fit_vspglm(formulas, simData, links);
beta_est(j,1:3) = sim_model(1).coefficients.estimates';
beta_est(j,4:6) = sim_model(2).coefficients.estimates';
se_est(j,1:3) = sim_model(1).coefficients.StdError';
se_est(j,4:6) = sim_model(2).coefficients.StdError';

% beta_est(j,1:4) = sim_model(1).coefficients.estimates';
% beta_est(j,5:8) = sim_model(2).coefficients.estimates';
% se_est(j,1:4) = sim_model(1).coefficients.StdError';
% se_est(j,5:8) = sim_model(2).coefficients.StdError';

end

%% 

