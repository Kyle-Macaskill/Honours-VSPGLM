function [c, ceq, gradc, gradceq] = constraints2(param,X,Y,dims, links, minMax, index, fixed)
%[c, ceq, gradc, gradceq] = constraints(param,X,Y,links) 
% computes and returns the equality and inequality constraints
% for fmincons optimization. The gradients of each constraint 
% are also computed and returned.
% The arguments to this function are 
% param = [betas, logp, b, thetas] which is of dimension
% 1 x (4 * N + sum(dims))

% Normalization constraints
[normConstraint, normConstraintGrad] = normConstraints(Y,X, param,dims);

% Mean Constraints
[meanConstraint, meanConstraintGrad]= meanConstraints(Y,X,param,dims,links, minMax);


% param_cont2 = param(2);
% param_cont_grad2 =  zeros(1,length(param));
% param_cont_grad2(2) = 1;
% Augment both vectors and return them 
c = [];
gradc = [];
%ceq = [meanConstraint;normConstraint].';
%gradceq = [meanConstraintGrad;normConstraintGrad].';   

ceq = [meanConstraint;normConstraint];
gradceq = [meanConstraintGrad;normConstraintGrad];
for i = 1:length(index)
    param_cont = param(index(i))-fixed(i);
    param_cont_grad = zeros(1,length(param));
    param_cont_grad(index(i)) = 1;
    ceq = [ceq;param_cont];
    gradceq = [gradceq; param_cont_grad];
end
ceq = ceq.';
gradceq = gradceq.';
%ceq = [meanConstraint;normConstraint;param_cont;param_cont2].';
%gradceq = [meanConstraintGrad;normConstraintGrad; param_cont_grad;param_cont_grad2].';


end