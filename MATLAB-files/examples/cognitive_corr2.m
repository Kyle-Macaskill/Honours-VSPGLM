function corr_mat = cognitive_corr2(mu2,mu3,mu4,mu5, mu22,mu23,mu24,mu25, cognitive_model,Y2,Y_arr)
    pred = [mu2, mu3,mu4,mu5, mu22,mu23,mu24,mu25];
phat = cognitive_model(1).pTilt';
thetas = zeros(1, 8);

options = optimoptions(@fsolve, 'Display', 'off');

mean_con = @(theta) pred(1,:)' - sum((Y2'.*phat)*exp(theta*Y2')'*exp(-log(sum(phat*exp(theta*Y2')',2))),2);
thetas(1,:) = fsolve(mean_con, zeros(1,8), options);
b = -log(sum(phat*exp(thetas(1,:)*Y2')',2));
phat_new = phat.*exp(b + thetas(1,:)*Y2');

Yvar = cell(1, 1);
Y = table2array(Y_arr);
minMax = cell(1, 8);    
for i = 1:8
    m = min(Y(:,i));
    M = max(Y(:,i));
    Y(:,i) = (Y(:,i) - (m + M)/2)*(2/(M-m));
    pred(:,i) = (pred(:,i) - (m+M)/2)*(2/(M-m));
    thetas(:,i) = thetas(:,i)*(M-m)/2;
    minMax{i} = [m, M];
end
      
t = zeros(8);
for j = 1:length(Y)
    %t = t + pexp(i,j)*outerY{j};
    phat_new_term = phat.*exp(-log(sum(phat*exp(thetas*Y')',2)) + thetas*Y');
    t = t + phat_new_term(j)*(Y(j,:).' - pred.')*(Y(j,:).' - pred.').';

end
     
corr_mat = zeros(8);
for i = 1:8
    for j = 1:8
        corr_mat(i,j) = t(i,j)/(sqrt(t(i,i))*sqrt(t(j,j)));
    end
end
%corr_mat
% Interested in correlation between time 2-3, 3-4, 4-5, 
corr_mat

corr_mat = round(corr_mat, 2);
end