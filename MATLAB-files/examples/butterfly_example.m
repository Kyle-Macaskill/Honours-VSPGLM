%%  
% Import the data
x = readtable("butterfly_X.xlsx");
y = readtable("butterfly_Y.xlsx");

% Get the largest
Y = table2array(y);
sums = sum(Y, 1);

[~, ids] = sort(sums, 'descend');
N = 14;
y = y(:,ids(1:N));


%%
% Paste the data together in a table
tbl = [x, y];

%% For archetypes for 14
tbl_data = table2array(y);
arch_1_index = [6 7 8 12 14 15] - 5;
arch_2_index = [9 10 11 13 16 17 18 19] - 5;
arch_1 = sum(tbl_data(:,arch_1_index),2);
arch_2 = sum(tbl_data(:,arch_2_index),2);

tbl = [x,y,array2table(arch_1), array2table(arch_2)];
%% Extract the names to use
names_X = convertStringsToChars(sprintf("%s,", string(string(x.Properties.VariableNames(1:5)))));
names_X = names_X(1:end-1);
names_X_split = split(names_X, ',');
names_X = strjoin(names_X_split(1:end), ',');
names_Y = convertStringsToChars(sprintf("%s,", string(string(y.Properties.VariableNames))));
names_Y = names_Y(1:end-1);
y_ind = split(names_Y, ',');

%Symmetric
%formula = sprintf("(%s) ~ (%s)", names_Y, names_X);

%Not symmetric
formula = strings(1,N);
for n = 1:N
   formula(n) = sprintf("%s ~ (%s)", y_ind{n}, names_X);
end

%NEED TO FIX THIS, NOT WORKING BUT SYMMETRIC CASE WORKING FOR BETA INDEX
% first_str = sprintf("%s ~ (%s)", y_ind{1}, names_X);
% second_str = sprintf("%s ~ (%s)", y_ind{2}, names_X);
% third_str = sprintf("%s ~ (%s)", y_ind{3}, names_X);
% formula = [first_str, second_str, third_str]

%formula = sprintf("(%s, %s, %s) ~ (%s)", y_ind{1},y_ind{2} ,y_ind{3},names_X);

%% Testing an idea, combining the counts for the two archetypes

formula_arch = ["arch_1 ~ (Building,Urban_Vegetation,Habitat_Mixed,Habitat_Short,Habitat_Tall)", "arch_2 ~ (Building,Urban_Vegetation,Habitat_Mixed,Habitat_Short,Habitat_Tall)"];

links = cell(1, N);
links(:) = {"log"};
[butterfly_model_arch, formulas_arch] = fit_vspglm([formula_1, formula_2], tbl, links);
butterfly_model_arch.coefficeints
%% Run VSPGLM
links = cell(1, N);
links(:) = {"log"};
[butterfly_model, formulas] = fit_vspglm(formula, tbl, links);
butterfly_model.coefficients
%%  Print out the model
butterfly_model.coefficients
%% Constrained model
butterfly_model_con = fit_vspglm_constraint(formula, tbl, links, [2,3,8,9,14,15], [0,0,0,0,0,0]);

%% Try this correlation plot
correlation_plot(butterfly_model, 1,2)

%% Trying to predict inside the convex hull for 2d 
correlation_surface(butterfly_model, 1,2, 500)
%% 
correlation_surface_theta(butterfly_model, 1,2, 100)
%% Plot the mean models and predictions?
fig = figure(1);
subplot(1,3,1)
% Plot X^T \beta on the X and counts on the right
butterfly_1 = tbl.Colias_philodice;
covariates = table2array(tbl(:,1:5));
covariates = [ones(66,1), covariates];
beta_1 = butterfly_model(1).betas;
linear_pred = covariates*beta_1;
scatter(linear_pred, butterfly_1)
hold on
x_1 = linspace(min(linear_pred), max(linear_pred), 100);
plot(x_1, exp(x_1),'LineWidth',1.5)
xlabel("Linear Predictors \boldmath$\bf X^T \hat{\beta}$", 'interpreter', 'latex');
ylabel("Observed and Predicted Counts",'interpreter', 'latex')
title("Colias Philodice")
grid on
ylim([0,65])

subplot(1,3,2)
% Plot X^T \beta on the X and counts on the right
butterfly_1 = tbl.Pieris_rapae;
covariates = table2array(tbl(:,1:5));
covariates = [ones(66,1), covariates];
beta_1 = butterfly_model(2).betas;
linear_pred = covariates*beta_1;
scatter(linear_pred, butterfly_1)
hold on
x_1 = linspace(min(linear_pred), max(linear_pred), 100);
plot(x_1, exp(x_1),'LineWidth',1.5)
xlabel("Linear Predictors \boldmath$\bf X^T \hat{\beta}$", 'interpreter', 'latex');
ylabel("Observed and Predicted Counts",'interpreter', 'latex')
title("Pieris Rapae")
grid on
ylim([0,30])


subplot(1,3,3)
% Plot X^T \beta on the X and counts on the right
butterfly_1 = tbl.Colias_eurytheme;
covariates = table2array(tbl(:,1:5));
covariates = [ones(66,1), covariates];
beta_1 = butterfly_model(3).betas;
linear_pred = covariates*beta_1;
scatter(linear_pred, butterfly_1)
hold on
x_1 = linspace(min(linear_pred), max(linear_pred), 100);
plot(x_1, exp(x_1),'LineWidth',1.5)
xlabel("Linear Predictors \boldmath$\bf X^T \hat{\beta}$", 'interpreter', 'latex');
ylabel("Observed and Predicted Counts",'interpreter', 'latex')
title("Colias Eurytheme")
grid on

%% 
correlation_surface(butterfly_model_arch, 1,2, 400)
title('Correlation Surface')
xlabel('Archetype 1')
ylabel('Archetype 2')
zlabel('Estimated Correlation')
cb = colorbar