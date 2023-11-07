%% Data importing and cleaning
data = readtable("cognitive_v3.csv");

% Make a new dataset, first get ID's that are complete
data_complete = data(data.complete==1,:);

%294 for smaller set
%469 for larger set
groupData = array2table( zeros(469,41) ...
                       , 'VariableNames' ...
                       , {'id','schoolid','control','meat', 'milk','calorie', 'male', 'age_at_time0', 'ses',...
                       'raven_r1', 'raven_r2','raven_r3','raven_r4','raven_r5',...
                       'vmean_r1', 'vmean_r2','vmean_r3','vmean_r4','vmean_r5',...
                       'arithmetic_r1', 'arithmetic_r2','arithmetic_r3','arithmetic_r4','arithmetic_r5',...
                       'rn1_year','rn2_year','rn3_year','rn4_year','rn5_year', 'milk_2','milk_3','milk_4','milk_5',...
                       'meat_2','meat_3','meat_4','meat_5', 'calorie_2','calorie_3','calorie_4','calorie_5'} ...
                       );
counter = 1;
invalid = 0;

for i = 1:5:height(data_complete)
    obs = data_complete(i:i+4,:);
    if obs.ses1(1) == "NA"
       invalid = invalid + 1;
       continue
       
    end
    groupData.id(counter,:) = obs.id(1);
    groupData.schoolid(counter,:) = obs.schoolid(1);
    groupData.age_at_time0(counter,:) = str2double(obs.age_at_time0(1));
    groupData.ses(counter,:) = str2double(obs.ses1(1));

    groupData.raven_r1(counter,:) = str2double(obs.ravens(1));
    groupData.raven_r2(counter,:) = str2double(obs.ravens(2));
    groupData.raven_r3(counter,:) = str2double(obs.ravens(3));
    groupData.raven_r4(counter,:) = str2double(obs.ravens(4));
    groupData.raven_r5(counter,:) = str2double(obs.ravens(5));
    
    groupData.arithmetic_r1(counter,:) = str2double(obs.arithmetic(1));
    groupData.arithmetic_r2(counter,:) = str2double(obs.arithmetic(2));
    groupData.arithmetic_r3(counter,:) = str2double(obs.arithmetic(3));
    groupData.arithmetic_r4(counter,:) = str2double(obs.arithmetic(4));
    groupData.arithmetic_r5(counter,:) = str2double(obs.arithmetic(5));
    
    groupData.vmean_r1(counter,:) = str2double(obs.vmeaning(1));
    groupData.vmean_r2(counter,:) = str2double(obs.vmeaning(2));
    groupData.vmean_r3(counter,:) = str2double(obs.vmeaning(3));
    groupData.vmean_r4(counter,:) = str2double(obs.vmeaning(4));
    groupData.vmean_r5(counter,:) = str2double(obs.vmeaning(5));
    
    groupData.rn1_year(counter,:) = str2double(obs.relyear(1));
    groupData.rn2_year(counter,:) = str2double(obs.relyear(2));
    groupData.rn3_year(counter,:) = str2double(obs.relyear(3));
    groupData.rn4_year(counter,:) = str2double(obs.relyear(4));
    groupData.rn5_year(counter,:) = str2double(obs.relyear(5));
    
    if obs.treatment == "meat"
       groupData.meat(counter,:) = 1; 
       groupData.meat_2(counter,:) = str2double(obs.relyear(2));
       groupData.meat_3(counter,:) = str2double(obs.relyear(3));
       groupData.meat_4(counter,:) = str2double(obs.relyear(4));
       groupData.meat_5(counter,:) = str2double(obs.relyear(5));
       
    elseif obs.treatment == "calorie"
       groupData.calorie(counter,:) = 1; 
       groupData.calorie_2(counter,:) = str2double(obs.relyear(2));
       groupData.calorie_3(counter,:) = str2double(obs.relyear(3));
       groupData.calorie_4(counter,:) = str2double(obs.relyear(4));
       groupData.calorie_5(counter,:) = str2double(obs.relyear(5));
    elseif obs.treatment == "milk"
       groupData.milk(counter,:) = 1; 
       groupData.milk_2(counter,:) = str2double(obs.relyear(2));
       groupData.milk_3(counter,:) = str2double(obs.relyear(3));
       groupData.milk_4(counter,:) = str2double(obs.relyear(4));
       groupData.milk_5(counter,:) = str2double(obs.relyear(5));
    else
        groupData.control(counter,:) = 1; 
    end
    
    if obs.sex == "boy"
        groupData.male(counter,:) = 1;
    end
    counter = counter + 1;
end

%% 
mean_r2 = mean(groupData.rn2_year);
mean_r3 = mean(groupData.rn3_year);
mean_r4 = mean(groupData.rn4_year);
mean_r5 = mean(groupData.rn5_year);
counter = 1;
invalid = 0;
for i = 1:5:height(data_complete)
    obs = data_complete(i:i+4,:);
    if obs.ses1(1) == "NA"
       invalid = invalid + 1;
       continue
       
    end
    
    if obs.treatment == "meat"
       groupData.meat(counter,:) = 1; 
       groupData.meat_2(counter,:) = mean_r2;
       groupData.meat_3(counter,:) = mean_r3;
       groupData.meat_4(counter,:) = mean_r4;
       groupData.meat_5(counter,:) = mean_r5;
       
    elseif obs.treatment == "calorie"
       groupData.calorie(counter,:) = 1; 
       groupData.calorie_2(counter,:) = mean_r2;
       groupData.calorie_3(counter,:) = mean_r3;
       groupData.calorie_4(counter,:) = mean_r4;
       groupData.calorie_5(counter,:) = mean_r5;
    elseif obs.treatment == "milk"
       groupData.milk(counter,:) = 1; 
       groupData.milk_2(counter,:) = mean_r2;
       groupData.milk_3(counter,:) = mean_r3;
       groupData.milk_4(counter,:) = mean_r4;
       groupData.milk_5(counter,:) = mean_r5;
    else
        groupData.control(counter,:) = 1; 
    end
    
    if obs.sex == "boy"
        groupData.male(counter,:) = 1;
    end
    counter = counter + 1;
end



%% Taking a subset of the data

to_use = 469;
subset_data = groupData(1:to_use,:);


%% 
links = cell(1, 4);
for i = 1:4
   links{i} = 'id'; 
end

%formulas_raven =  "(raven_r2,raven_r3,raven_r4,raven_r5) ~ (age_at_time0, ses, raven_r1, male, (rn2_year & rn3_year & rn4_year & rn5_year), (milk_2 & milk_3 & milk_4 & milk_5), (meat_2 & meat_3 & meat_4 & meat_5), (calorie_2 & calorie_3 & calorie_4 & calorie_5))";
formulas_arithmetic =  "(arithmetic_r2,arithmetic_r3,arithmetic_r4,arithmetic_r5) ~ (age_at_time0, ses, arithmetic_r1, male, (rn2_year & rn3_year & rn4_year & rn5_year), (milk_2 & milk_3 & milk_4 & milk_5), (meat_2 & meat_3 & meat_4 & meat_5), (calorie_2 & calorie_3 & calorie_4 & calorie_5))";
%formulas_vmean =  "(vmean_r2,vmean_r3,vmean_r4,vmean_r5) ~ (age_at_time0, ses, vmean_r1, male, (rn2_year & rn3_year & rn4_year & rn5_year), (milk_2 & milk_3 & milk_4 & milk_5), (meat_2 & meat_3 & meat_4 & meat_5), (calorie_2 & calorie_3 & calorie_4 & calorie_5))"
%% 
cognitive_model_arithmetic = fit_vspglm(formulas_arithmetic, subset_data, links);
%links2 = cell(1, 8);
%for i = 1:8
%   links2{i} = 'id'; 
%end
%cognitive_model_joint = fit_vspglm([formulas_raven, formulas_arithmetic], subset_data, links2);
%% 
cognitive_model.coefficients
%% 
fig = figure(1);

calorie_data = groupData(groupData.calorie==1,:);
calorie_mean = mean(table2array(calorie_data(:,10:14)),1);
subplot(1,4,1)
plot(calorie_mean, 'r', 'linewidth', 1.5)
hold on
plot(calorie_mean, 'k.', 'MarkerSize', 12)
title("Calorie")
ylim([0,31])
xticks(1:5)

milk_data = groupData(groupData.milk==1,:);
milk_mean = mean(table2array(milk_data(:,10:14)),1);
subplot(1,4,3)
plot(milk_mean, 'r', 'linewidth', 1.5)
hold on
plot(milk_mean, 'k.', 'MarkerSize', 12)
title("Milk")
ylim([0,31])
xticks(1:5)

meat_data = groupData(groupData.meat==1,:);
meat_mean = mean(table2array(meat_data(:,10:14)),1);
subplot(1,4,2)
plot(meat_mean,'r', 'linewidth', 1.5)
hold on
plot(meat_mean, 'k.', 'MarkerSize', 12)
title("Meat")
ylim([0,31])
xticks(1:5)

control_data = groupData(groupData.control==1,:);
control_mean = mean(table2array(control_data(:,10:14)),1);
subplot(1,4,4)
plot(control_mean, 'r', 'linewidth', 1.5)
hold on
plot(control_mean, 'k.', 'MarkerSize', 12)
title("Control")
ylim([0,31])
xticks(1:5)

for i = 1:height(groupData)
    obs = table2array(groupData(i,10:14));
    if groupData(i,:).calorie == 1
        subplot(1,4,1)
    elseif groupData(i,:).meat == 1
        subplot(1,4,2)
        
    elseif groupData(i,:).milk == 1
        subplot(1,4,3)
      
    else
        subplot(1,4,4)
       
    end
    plot(obs, 'Color',  [0.5 0.5 0.5, 0.5])
    hold on
end
han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,"Raven's Score");
xlabel(han,'Round');
%% Correlation of the actual observed responses
disp("Overall")
corrcoef(Y2)
disp("Control")
corrcoef(Y2(subset_data.control==1,:))
disp("Milk")
corrcoef(Y2(subset_data.milk==1,:))
disp("Meat")
corrcoef(Y2(subset_data.meat==1,:))
disp("Calorie")
corrcoef(Y2(subset_data.calorie==1,:))
%% 

figure(1)
names_label = ["R2", "R3", "R4", "R5"];
Y_arr = subset_data(:,11:14);
%Y_arr = subset_data(:,21:24);
Y2 = table2array(Y_arr);
%Maybe write the prediction for the particular output
%control group, 
disp("Control")
control_data = subset_data(subset_data.control==1,:);
beta = cognitive_model.betas;
mu2 = beta(1) + mean(control_data.age_at_time0)*beta(2) + mean(control_data.ses)*beta(3) ...
    + mean(control_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(control_data.rn2_year);
mu3 = beta(1) + mean(control_data.age_at_time0)*beta(2) + mean(control_data.ses)*beta(3) ...
    + mean(control_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(control_data.rn3_year);
mu4 = beta(1) + mean(control_data.age_at_time0)*beta(2) + mean(control_data.ses)*beta(3) ...
    + mean(control_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(control_data.rn4_year);
mu5 = beta(1) + mean(control_data.age_at_time0)*beta(2) + mean(control_data.ses)*beta(3) ...
    + mean(control_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(control_data.rn5_year);
corr_mat = cognitive_corr(mu2,mu3,mu4,mu5, cognitive_model, Y2, Y_arr);
subplot(2,2,1)
heatmap(names_label, names_label, corr_mat)
title("Control")
%% Milk group

calorie_data = subset_data(subset_data.milk==1,:);
disp("Milk")
beta = cognitive_model.betas;
mu2 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn2_year)+ beta(7)*mean(calorie_data.rn2_year);
mu3 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn3_year)+ beta(7)*mean(calorie_data.rn3_year);
mu4 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn4_year)+ beta(7)*mean(calorie_data.rn4_year);
mu5 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn5_year)+ beta(7)*mean(calorie_data.rn5_year);
corr_mat = cognitive_corr(mu2,mu3,mu4,mu5, cognitive_model, Y2, Y_arr);
subplot(2,2,2)
heatmap(names_label, names_label,  corr_mat)
title("Milk")
%% 
calorie_data = subset_data(subset_data.meat==1,:);
disp("Meat")
beta = cognitive_model.betas;
mu2 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn2_year)+ beta(8)*mean(calorie_data.rn2_year);
mu3 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn3_year)+ beta(8)*mean(calorie_data.rn3_year);
mu4 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn4_year)+ beta(8)*mean(calorie_data.rn4_year);
mu5 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn5_year)+ beta(8)*mean(calorie_data.rn5_year);

corr_mat = cognitive_corr(mu2,mu3,mu4,mu5, cognitive_model, Y2, Y_arr);
subplot(2,2,3)
heatmap(names_label, names_label, corr_mat)
title("Meat")
%% 
calorie_data = subset_data(subset_data.calorie==1,:);
disp("Energy")
beta = cognitive_model.betas;
mu2 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn2_year)+ beta(9)*mean(calorie_data.rn2_year);
mu3 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn3_year)+ beta(9)*mean(calorie_data.rn3_year);
mu4 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn4_year)+ beta(9)*mean(calorie_data.rn4_year);
mu5 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn5_year)+ beta(9)*mean(calorie_data.rn5_year);

corr_mat = cognitive_corr(mu2,mu3,mu4,mu5, cognitive_model, Y2, Y_arr);
subplot(2,2,4)
heatmap(names_label, names_label, corr_mat)
title("Energy")
%% 
scatter(groupData.rn1_year, groupData.id)
hold on
scatter(groupData.rn2_year, groupData.id)

scatter(groupData.rn3_year, groupData.id)
scatter(groupData.rn4_year, groupData.id)
scatter(groupData.rn5_year, groupData.id)
title("Relative time of measurements to baseline vs Observations")
ylabel("Observation ID")
xlabel("Relative time of measurements from baseline visit (years)")
legend('Baseline Round', '2nd Round', '3rd Round', '4th Round', '5th Round')

%% Plotting fitted means on observations
fig = figure(2);

Y_arr = subset_data(:,11:14);
Y2 = table2array(Y_arr);
%Maybe write the prediction for the particular output
%control group, 

calorie_data = subset_data(subset_data.calorie==1,:);
disp("Calorie")
beta = cognitive_model.betas;
mu2 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn2_year)+ beta(9)*mean(calorie_data.rn2_year);
mu3 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn3_year)+ beta(9)*mean(calorie_data.rn3_year);
mu4 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn4_year)+ beta(9)*mean(calorie_data.rn4_year);
mu5 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn5_year)+ beta(9)*mean(calorie_data.rn5_year);
data_mean = [mean(calorie_data.raven_r1), mu2, mu3, mu4, mu5];

%calorie_mean = mean(table2array(calorie_data(:,10:14)),1);
subplot(1,4,4)
plot(data_mean, 'r', 'linewidth', 1.5)
hold on
plot(data_mean, 'k.', 'MarkerSize', 12)
title("Energy")
ylim([0,31])
xticks(1:5)

calorie_data = subset_data(subset_data.milk==1,:);
disp("Milk")
beta = cognitive_model.betas;
mu2 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn2_year)+ beta(7)*mean(calorie_data.rn2_year);
mu3 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn3_year)+ beta(7)*mean(calorie_data.rn3_year);
mu4 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn4_year)+ beta(7)*mean(calorie_data.rn4_year);
mu5 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn5_year)+ beta(7)*mean(calorie_data.rn5_year);
data_mean = [mean(calorie_data.raven_r1), mu2, mu3, mu4, mu5];

subplot(1,4,3)
plot(data_mean, 'r', 'linewidth', 1.5)
hold on
plot(data_mean, 'k.', 'MarkerSize', 12)
title("Milk")
ylim([0,31])
xticks(1:5)

calorie_data = subset_data(subset_data.meat==1,:);
disp("Meat")
beta = cognitive_model.betas;
mu2 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn2_year)+ beta(8)*mean(calorie_data.rn2_year);
mu3 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn3_year)+ beta(8)*mean(calorie_data.rn3_year);
mu4 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn4_year)+ beta(8)*mean(calorie_data.rn4_year);
mu5 = beta(1) + mean(calorie_data.age_at_time0)*beta(2) + mean(calorie_data.ses)*beta(3) ...
    + mean(calorie_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(calorie_data.rn5_year)+ beta(8)*mean(calorie_data.rn5_year);
data_mean = [mean(calorie_data.raven_r1), mu2, mu3, mu4, mu5];

subplot(1,4,2)
plot(data_mean,'r', 'linewidth', 1.5)
hold on
plot(data_mean, 'k.', 'MarkerSize', 12)
title("Meat")
ylim([0,31])
xticks(1:5)

control_data = subset_data(subset_data.control==1,:);
beta = cognitive_model.betas;
mu2 = beta(1) + mean(control_data.age_at_time0)*beta(2) + mean(control_data.ses)*beta(3) ...
    + mean(control_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(control_data.rn2_year);
mu3 = beta(1) + mean(control_data.age_at_time0)*beta(2) + mean(control_data.ses)*beta(3) ...
    + mean(control_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(control_data.rn3_year);
mu4 = beta(1) + mean(control_data.age_at_time0)*beta(2) + mean(control_data.ses)*beta(3) ...
    + mean(control_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(control_data.rn4_year);
mu5 = beta(1) + mean(control_data.age_at_time0)*beta(2) + mean(control_data.ses)*beta(3) ...
    + mean(control_data.raven_r1)*beta(4) + beta(5) + beta(6)*mean(control_data.rn5_year);
data_mean = [mean(calorie_data.raven_r1), mu2, mu3, mu4, mu5];

subplot(1,4,1)
plot(data_mean, 'r', 'linewidth', 1.5)
hold on
plot(data_mean, 'k.', 'MarkerSize', 12)
title("Control")
ylim([0,31])
xticks(1:5)

for i = 1:height(groupData)
    obs = table2array(groupData(i,10:14));
    if groupData(i,:).calorie == 1
        subplot(1,4,1)
    elseif groupData(i,:).meat == 1
        subplot(1,4,2)
        
    elseif groupData(i,:).milk == 1
        subplot(1,4,3)
      
    else
        subplot(1,4,4)
       
    end
    plot(obs, 'Color',  [0.5 0.5 0.5, 0.3])
    hold on
    grid on
end
han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,"Raven's Score");
xlabel(han,'Round');
set(gcf,'Position',[100 100 500 500])

%% 


