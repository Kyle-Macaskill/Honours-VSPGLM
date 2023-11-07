%% Fitted Model Using Rossner  data
%% Data 
yL = [2,1,0.5,2.5,3,2,1,2,3,2,3,2,3,0.5,3,3,3,1,1,1.5,2.5,2.5,3,2.5,1,2,3,...
    3,2,0.5,2.5,2,2.5,2.5,3,2,2.5,1,2,2,2]' ;
yR = [2,1,2,1,2.5,2.5,1.5,2.5,1,3,2.5,3,3,1.5,3,3,3,2,2,2.5,2,2.5,3,2,0.5,...
    0,2.5,1,1.5,0,1.5,2,2.5,2.5,3,3,2.5,3,2.5,1,2]';
xL = [ones(20,1); zeros(21,1)] ;
xR = [ones(6,1); zeros(14,1); ones(14,1); zeros(7,1)] ;
interaction = xL .* xR;
%X = table(xL, xR, interaction);
X = table(xL, xR);
Y = table(yL, yR);
tbl = [X, Y];
%% 

links = {'id', 'id'};
[rossner_model, formulas] = fit_vspglm(["yL ~ xL", "yR ~ xR"], tbl, links);
%[rossner_model, formulas] = fit_vspglm(["(yL, yR) ~ ((xL & xR))"], tbl, links);
%[rossner_model, formulas] = fit_vspglm(["(yL, yR) ~ ((xL & xR), (xR & xL))"], tbl, links);
%[rossner_model, formulas]= fit_vspglm(["(yL, yR) ~ ((xL & xR), (xR & xL), (interaction))"], tbl, links);
rossner_model.coefficients
%% Plotting for Sorbinal
Y2 = table2array(Y);
vspglmJointPlot(rossner_model, formulas, Y2, '2d', false)

subplot(2,2,1)
xlabel('R: Sorbinil')
xticks(0:0.5:4)
yticks(0:0.5:4)
ylabel('L: Sorbinil')
grid on
subplot(2,2,2)
xlabel('R: Sorbinil')
ylabel('L: Placebo')
xticks(0:0.5:4)
yticks(0:0.5:4)
grid on
subplot(2,2,3)
xlabel('R: Placebo')
ylabel('L: Sorbinil')
xticks(0:0.5:4)
yticks(0:0.5:4)
grid on
subplot(2,2,4)
xlabel('R: Placebo')
ylabel('L: Placebo')
xticks(0:0.5:4)
yticks(0:0.5:4)
cb = colorbar;
cb.Position = cb.Position + [0.13,0,0,0.475];%[left, bottom, width, height]
grid on
%% Mean PIT
vspglmMeanPIT(rossner_model, yR, 11)

%% Random PIT
vspglmRandomPIT(rossner_model, yR, 10)
%% Trying a covaraince plot
correlation_plot_data(rossner_model, 1, 2)
%% Correlation surface plot
correlation_surface(rossner_model, 1, 2, 200)

%% 
rossner_predict = predict_vspglm(rossner_model, X,Y)