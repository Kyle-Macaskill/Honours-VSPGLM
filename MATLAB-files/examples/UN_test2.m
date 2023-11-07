
%% 
un2 = readtable('UN2.txt');
%% 
un = readtable("country_profile_variables.csv");
gdp_per_cap = un.GDPPerCapita_currentUS__;
complete_gdp = gdp_per_cap > 0;
urban_pop_total = un.UrbanPopulation__OfTotalPopulation_;
fertility = un.FertilityRate_Total_liveBirthsPerWoman_;
fertility = string(fertility);
fertility = str2double(fertility);
fertility_complete = fertility > 0;
total_complete = fertility_complete & complete_gdp;

un_subset = un(total_complete,[1,9,25,27]);
un_subset.fertility = fertility(total_complete);
un_subset.logGDPpp = log(un_subset.GDPPerCapita_currentUS__);
un_subset.logFertility = log(un_subset.fertility);
un_subset.Purban = un_subset.UrbanPopulation__OfTotalPopulation_;
%to_remove = [9,72,73,167,176]; %Countries not in UN
%un_subset(to_remove,:) = [];
un_subset.one = ones(height(un_subset),1);

%% 
links = {'id', 'id'};

formulas = ["logGDPpp ~ Purban", "logFertility ~ Purban"];

%formulas = ["logGDPpp ~ one", "logFertility ~ one"]; %Intercept only model
un_model_2 = fit_vspglm(formulas, un_subset, links);
un_model_2.coefficients
%% Compositie hypothesis
un_model_3 = fit_vspglm_constraint(formulas, un_subset, links, [2,4], [0,0]);
un_model_3.coefficients
un_model_3.loglike
%% Visualisations, joint density plot

Y = [un_subset.logGDPpp, un_subset.logFertility];

vspglmJointPlot(un_model_2, formulas, Y, '3d',  true)

%% Correlation plot
correlation_plot_pred(un_model_2, 1, 2)
%% Correlation surface 
correlation_surface(un_model_2, 1,2, 10)

%% Plotting the marginal mean models
subplot(1,3,1)
scatter(un_subset.Purban, un_subset.logGDPpp,'filled');
hold on
beta_gdp = un_model_2(1).betas;
linear_pred = beta_gdp(1) +  beta_gdp(2)*un_subset.Purban;
plot(un_subset.Purban,linear_pred,'LineWidth',1.5);
title("Percentage Urban vs logGDPpp")
xlabel("Percentage of Population in Urban Area")
ylabel("log GDP Per Capita")
xlim([0,104])
grid on

%scatter(linear_pred, un_subset.logGDPpp);
subplot(1,3,2)
scatter(un_subset.Purban, un_subset.logFertility, 'filled');
hold on
beta_fert = un_model_2(2).betas;
linear_pred2 = beta_fert(1) +  beta_fert(2)*un_subset.Purban;
plot(un_subset.Purban,linear_pred2, 'LineWidth',1.5);
title("Percentage Urban vs Fertility Rates")
xlabel("Percentage of Population in Urban Area")
ylabel("log Fertility Rates")
xlim([0,104])
ylim([0,2.1])

grid on

subh3 = subplot(1,3,3);
dim_1 = 1;
dim_2 = 2;
pred = un_model_2.means;
count = 1;
%figure(1)

y1lin = linspace(min(pred(:,dim_1)), max(pred(:,dim_1)), 100);
y2lin = linspace(min(pred(:,dim_2)), max(pred(:,dim_2)), 100);
[X,Y] = meshgrid(y1lin, y2lin);
z = zeros(1,length(pred));

% Extract the correlations
for n = 1:length(pred)
    covar = un_model_2.yCovariance;
    covar_n = covar{n};
    z(n) = covar_n(dim_1,dim_2)/(sqrt(covar_n(dim_1,dim_1))*sqrt(covar_n(dim_2,dim_2)));
end

caxis(subh3,[-1,1])
dotsize = 15;
scatter3(pred(:,dim_1),pred(:,dim_2),z, dotsize, z, 'filled')
hold on
%scatter3(pred_mu_final(:,1), pred_mu_final(:,2),corr_mu, dotsize, 'r', 'filled')
view(0, 90)
axis tight
cb = colorbar;
cb.Position = cb.Position + [0.1,0,0,0]; %[left, bottom, width, height]
xlabel("log GDP Per Capita")
ylabel("log Fertility Rates")
xlim([6.5,10.5])
ylim([0.45,1.5])
title("Fitted Values and Correlation")

%% Trying to predict
subplot(1,3,1)
scatter(un_subset.Purban, un_subset.logGDPpp);
hold on
urban_predict = linspace(0,100,1000)';
beta_gdp = un_model_2(1).betas;
linear_pred = beta_gdp(1) +  beta_gdp(2)*urban_predict;
plot(urban_predict,linear_pred,'LineWidth',1.5);
title("Percentage Urban vs logGDPpp")
xlabel("Percentage of Population in Urban Area")
ylabel("log GDP Per Capita")
xlim([0,104])
grid on

%scatter(linear_pred, un_subset.logGDPpp);
subplot(1,3,2)
scatter(un_subset.Purban, un_subset.logFertility);
hold on
beta_fert = un_model_2(2).betas;
linear_pred2 = beta_fert(1) +  beta_fert(2)*urban_predict;
plot(urban_predict,linear_pred2, 'LineWidth',1.5);
title("Percentage Urban vs Fertility Rates")
xlabel("Percentage of Population in Urban Area")
ylabel("log Fertility Rates")
xlim([0,104])
ylim([0,2.1])

grid on

X_new = array2table(linspace(0,100,1000)');
Y_arr = un_subset(:,[6,7]);
predict_output = predict_vspglm(un_model_2, X_new, Y_arr);


subh3 = subplot(1,3,3);
dim_1 = 1;
dim_2 = 2;
pred = predict_output.fitted;
count = 1;
%figure(1)

z = zeros(1,length(pred));
% Extract the correlations
for n = 1:length(pred)
    covar = predict_output.yCov;
    covar_n = covar{n};
    z(n) = covar_n(dim_1,dim_2)/(sqrt(covar_n(dim_1,dim_1))*sqrt(covar_n(dim_2,dim_2)));
end

caxis(subh3,[-1,1])
dotsize = 15;
scatter3(pred(:,dim_1),pred(:,dim_2),z, dotsize, z, 'filled')
hold on
%scatter3(pred_mu_final(:,1), pred_mu_final(:,2),corr_mu, dotsize, 'r', 'filled')
view(0, 90)
axis tight
cb = colorbar;
cb.Position = cb.Position + [0.1,0,0,0]; %[left, bottom, width, height]
xlabel("log GDP Per Capita")
ylabel("log Fertility Rates")
xlim([6.2,10.5])
ylim([0.45,1.55])
title("Fitted Values and Correlation")

%% Predicting a new density
Y_table = un_subset(:,[6,7]);
fig = figure(1);
subplot(1,3,1)
mu_pred = [6.8,1.65];
vspglmJointPredict(un_model_2,Y_table, mu_pred, '2d');
title('$\hat{\mu} = (6.8, 1.65)^T$','interpreter','latex')
xlabel('logGDPpp')
ylabel('logFertility')
subplot(1,3,2)
mu_pred = [9.8, 0.8];
vspglmJointPredict(un_model_2,Y_table, mu_pred, '2d');
xlabel('logGDPpp')
ylabel('logFertility')
title('$\hat{\mu} = (9.8, 0.8)^T$','interpreter','latex')
subplot(1,3,3)
mu_pred = [8, 0.8];
vspglmJointPredict(un_model_2,Y_table, mu_pred, '2d'); 
title('$\hat{\mu} = (8, 0.8)^T$','interpreter','latex')
xlabel('logGDPpp')
ylabel('logFertility')

h = axes(fig,'visible','off'); 
h.Title.Visible = 'on';
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
colorbar(h,'Position',[0.93 0.11 0.022 0.82]);
caxis([0,0.1169]); %Max phat from the 3 plots
