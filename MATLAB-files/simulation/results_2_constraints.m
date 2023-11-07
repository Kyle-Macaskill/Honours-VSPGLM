length_sum = 1000;
mean(beta_est(1:length_sum,1:4)) - [1, -1, 0, 0.67]
fprintf("Estimated standard errors\n")
mean(se_est(1:length_sum,1:4))
fprintf("Std of estimates\n")
std(beta_est(1:length_sum,1:4))
%% 
start = 1;
subplot(3,2,1)
hist(beta_est(start:length_sum,2))
title('Histogram of $\hat{\beta}$ for $\beta = -1$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(3,2,2)
qqplot(beta_est(start:length_sum,2))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(3,2,3)
hist(beta_est(start:length_sum,3))
title('Histogram of $\hat{\beta}$ for $\beta = 0$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(3,2,4)
qqplot(beta_est(start:length_sum,3))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')
subplot(3,2,5)
hist(beta_est(start:length_sum,4))
title('Histogram of $\hat{\beta}$ for $\beta = 0.67$','interpreter','latex')
xlabel("$\hat{\beta}$ ",'interpreter','latex')
ylabel("Count",'interpreter', 'latex')
subplot(3,2,6)
qqplot(beta_est(start:length_sum,4))
title('QQ-plot','interpreter','latex')
xlabel('Standard Normal Quantiles','interpreter','latex')
ylabel('Quantiles of Input Sample','interpreter','latex')


%% 
fprintf("Wald\n");
start = 1;
length_sim = 1000;
t_mat = [1.660715,1.984723,2.627468; %qt([0.95,0.975,0.995],97) checked
        1.652625,1.972079, 2.601016; %qt([0.95,0.975,0.995],197) checked
        1.677927,2.011741,2.684556];%qt([0.95,0.975,0.995],50-3) checked
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
    for i = 1:4
        if i == 1
           continue 
        end
    
    index = i;
    %true_param = [1, -1, 0, 0.67, 1, 0.5, 2.2, -1.25];
    true_param = [1, -1, 0, 0.67];
    t_cutoff = t(c);
  
    lower_ci = beta_est(start:length_sim,index)-t_cutoff*se_est(start:length_sim,index);
    upper_ci = beta_est(start:length_sim,index)+t_cutoff*se_est(start:length_sim,index);
    coverage = sum((lower_ci < true_param(index)) & (upper_ci > true_param(index)));
    fprintf("param %d coverage %.3f\n", i, coverage/length_sim);
    end
end
%% 
length_sim = 1000;
start = 1;
fprintf("ELRT\n");
for p = 1:3
    if p == 1
        fprintf("90 percent CI\n");
    elseif p == 2
        fprintf("95 percent CI\n");
    else
        fprintf("99 percent CI\n");
    end
    for c = 2:4
        LRT1 = -2*(loglik(1:length_sim,c)- loglik(1:length_sim,1));

        %fprintf("90 Coverage param %d %.3f\n",c-1,1-sum(LRT1 > 2.705543)/length_sim); %chisq_{3} at 0.9
        %fprintf("95 Coverage param %d %.3f\n",c-1,1-sum(LRT1 > 3.841459)/length_sim); %chisq_{3} at 0.95
        %fprintf("99 Coverage param %d %.3f\n",c-1,1-sum(LRT1 >6.634897)/length_sim); %chisq_{3} at 0.99
        if p == 1
            
            if n == 100
                fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 2.757973)/(length_sim- start)); 
            elseif n == 200
                fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 2.73117)/(length_sim- start)); 
            else
                fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 2.815438)/(length_sim- start)); 
            end
      
            %fprintf("90 Coverage param %d %.3f",c,1-sum(LRT1 > 2.705543)/length_sim); %chisq_{3} at 0.9
        elseif p == 2
            if n == 100
                fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 3.939126)/(length_sim- start)); 
                %fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 5.183489)/length_sim)
            elseif n == 200 
                fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 3.889096)/(length_sim- start)); 
            else
                 fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 4.0471)/(length_sim- start));
            end

             
            %fprintf("95 Coverage param %d %.3f",c,1-sum(LRT1 > 3.841459)/length_sim)%chisq_{3} at 0.95
        else
            
            if n == 100
                fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 6.903587)/(length_sim- start)); %n = 100
                %fprintf("param %d coverage %.3f",c,1-sum(LRT1 >  8.252183)/length_sim); %n = 100
               
            elseif n == 200
                fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 6.765282)/(length_sim- start));
            else
                fprintf("param %d coverage %.3f",c,1-sum(LRT1 > 7.206839)/(length_sim- start));
            end
            
            %fprintf("99 Coverage param %d %.3f",c,1-sum(LRT1 >6.634897)/length_sim);%chisq_{3} at 0.99
           
        end
        fprintf("\n")

    end
end

