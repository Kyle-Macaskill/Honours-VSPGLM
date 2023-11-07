%% Fitted Model hospital data
%%
X = readtable("hospital.csv");
X.month = X.month;
firstQuarter = ones(height(X), 1);
threeQuarters = zeros(height(X), 1);
X = [X, table(firstQuarter, threeQuarters)];
%% 

links = {'log', 'log', 'log', 'log'};

model = fit_vspglm(["(v1, v2, v3, v4) ~ ((firstQuarter&threeQuarters&threeQuarters&threeQuarters), month,smoking)"], X,  links);
%[model, formulas] = fit_vspglm(["(v1, v2, v3) ~ ((firstQuarter&threeQuarters&threeQuarters), month,smoking)", "v4 ~ (gender)"], X,  links);
%[model, formulas] = fit_vspglm(["(v1,v2) ~ (month,smoking)","v3~ (month,smoking)", "v4 ~ (gender)"], X,  links);
model.coefficients
