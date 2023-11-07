% Song (2007) Burns Injury data set example
%% Import Data 
% Song Burns Data set
data = readtable('burns.txt');

% Rename the data
data.Properties.VariableNames = {'age', 'gender',...
                                'burn_severity', 'death'};
% Transform the variables 
data.death = abs(data.death - 2);

data.burn_severity  = log(data.burn_severity + 1);
old_data = data;
data.zeros = zeros(height(data),1);
% Cannot handle the whole data set.
%data = data(1:200, :);

%%  Run the model
links = {'logit', 'id'};
[burns_model, formulas]= fit_vspglm(["death ~ age", "burn_severity ~ age"],data,links);
burns_model.coefficients
%% 
[burns_model_age] = fit_vspglm_constraint(["death ~ age", "burn_severity ~ age"],data,links,4,0);
burns_model_age.coefficients
%% 
[burns_model_none] = fit_vspglm_constraint(["death ~ age", "burn_severity ~ age"],data,links,[2,4],[0,0]);
burns_model_none.coefficients
%% 
Y = [data.death, data.burn_severity];
%2nd 3d plot kinda cool
vspglmJointPlot(burns_model, formulas, Y, '2d',  true)


%% Fitted model and correlation plots
%Conditional mean plots
subplot(1,3,1)
sc1 = scatter(data.age, data.burn_severity, 'o','MarkerEdgeAlpha',0.6);
hold on
beta_burn = burns_model(2).betas;
linear_pred = beta_burn(1) +  beta_burn(2)*data.age;
plot(data.age,linear_pred,'LineWidth',1.5);
xlim([0,95])
title("Age vs Burn Severity")
xlabel("Age in Weeks")
ylabel("Burn Severity = log(Burn Area + 1)")
grid on

%scatter(linear_pred, un_subset.logGDPpp);
subplot(1,3,2)
scatter(data.age, data.death,'o','MarkerEdgeAlpha',0.6);
hold on
beta_death = burns_model(1).betas;
ages = 1:150;
linear_pred_2 = beta_death(1) +  beta_death(2)*data.age;
linear_pred_3 = beta_death(1) +  beta_death(2)*ages;

link_pred = exp(linear_pred_2)./(1+exp(linear_pred_2));
%link_pred = exp(linear_pred_3)./(1+exp(linear_pred_3));
[sorted_age,ind] = sortrows(data.age);
plot(sorted_age,link_pred(ind),'LineWidth',1.5);
%plot(ages,link_pred,'LineWidth',1.5);
xlim([0,95])
title("Age vs Probability of Death")
xlabel("Age in Weeks")
ylabel("Disposition of Death / Probability of Death")
grid on
%Correlation plot but with the right labels 

X_new = array2table(linspace(0,99,300)');
Y_arr = data(:,[4,3]);
predict_output = predict_vspglm(burns_model, X_new, Y_arr);


subh3 = subplot(1,3,3);
correlation_surface(burns_model, 2,1, 400)
xlabel("Burn Severity")
ylabel("Probability of Death")
title("Estimated Correlation Surface")
axis tight
cb = colorbar;
cb.Position = cb.Position + [0.1,0,0,0];
