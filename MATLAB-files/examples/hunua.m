data = readtable("hunua.csv");
links = {'logit', 'logit', 'logit'};
%links = {'logit', 'logit'};
[plant_model, formulas]= fit_vspglm(["cyadea ~ altitude", "beitaw ~ altitude", "kniexc ~ altitude"],data,links);
%[plant_model, formulas]= fit_vspglm(["cyadea ~ altitude", "beitaw ~ altitude"],data,links);
%% Kinda matches VGAM, but not GEE paper?
plant_model.coefficients

%% 
plant_model2= fit_vspglm_constraint(["cyadea ~ altitude", "beitaw ~ altitude", "kniexc ~ altitude"],data,links, [2],[0]);
plant_model3= fit_vspglm_constraint(["cyadea ~ altitude", "beitaw ~ altitude", "kniexc ~ altitude"],data,links,[4],[0]);
plant_model4= fit_vspglm_constraint(["cyadea ~ altitude", "beitaw ~ altitude", "kniexc ~ altitude"],data,links,[6],[0]);
%% Standard Correlation Plot
correlation_plot_pred(plant_model, 2,3)
%% Fitted mean models

%% Fitted model and correlation plots
%Conditional mean plots
fig = figure(1);
subplot(1,3,1)
sc1 = scatter(data.altitude, data.cyadea, 'o','MarkerEdgeAlpha',0.6);
hold on
beta_plant = plant_model(1).betas;
linear_pred = beta_plant(1) +  beta_plant(2)*data.altitude;
link_pred = exp(linear_pred)./(1+exp(linear_pred));
[sorted_alt,ind] = sortrows(data.altitude);
plot(sorted_alt,link_pred(ind),'LineWidth',1.5);

title("Altitude vs Probability of Cyadea Presense")
xlabel("Altitude (m)")
ylabel("Probability of Cyadea Presense")
grid on

subplot(1,3,2)
sc1 = scatter(data.altitude, data.beitaw, 'o','MarkerEdgeAlpha',0.6);
hold on
beta_plant = plant_model(2).betas;
linear_pred = beta_plant(1) +  beta_plant(2)*data.altitude;
link_pred = exp(linear_pred)./(1+exp(linear_pred));
[sorted_alt,ind] = sortrows(data.altitude);
plot(sorted_alt,link_pred(ind),'LineWidth',1.5);

title("Altitude vs Probability of Beitaw Presense")
xlabel("Altitude (m)")
ylabel("Probability of Beitaw Presense")
grid on

subplot(1,3,3)
sc1 = scatter(data.altitude, data.kniexc, 'o','MarkerEdgeAlpha',0.6);
hold on
beta_plant = plant_model(3).betas;
linear_pred = beta_plant(1) +  beta_plant(2)*data.altitude;
link_pred = exp(linear_pred)./(1+exp(linear_pred));
[sorted_alt,ind] = sortrows(data.altitude);
plot(sorted_alt,link_pred(ind),'LineWidth',1.5);


title("Altitude vs Probability of Kniexc Presense")
xlabel("Altitude (m)")
ylabel("Probability of Kniexc Presense")
grid on

fig.PaperPositionMode = 'auto';
width=1200;
height=350
set(fig,'position',[0,0,width,height])
orient(fig,'landscape')
print(fig,'LandscapePage.pdf','-dpdf')

%% 
%correlation_surface(plant_model, 1, 2, 500)
%% 
%correlation_surface_theta(plant_model, 1,2, 100)
links = {'logit', 'logit', 'logit','logit','logit','logit'};
[plant_model_big]= fit_vspglm(["cyadea ~ altitude", "beitaw ~ altitude", "kniexc ~ altitude", "kuneri ~ altitude", "daccup ~ altitude", "cyamed ~ altitude"],data,links);