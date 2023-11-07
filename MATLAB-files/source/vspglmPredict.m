function y_predict = vspglmPredict(fitted_model, Xcell)
    %Xcell stores covariates for each mean model to be predicted. If we
    %have components with a shared mean model but with different
    %covariates, as the coefficient is the same right now you have to
    %re-fit it but with the different covariate.
    K = length(fitted_model);
    y_predict = zeros(height(Xcell{1}), K);
    
    for k = 1:K
        betas = fitted_model(k).betas;
        covariate = Xcell{k};
        Intercept = ones(height(covariate), 1);
        covariate = [table(Intercept), covariate];
        XB = table2array(covariate)*betas;
        switch fitted_model(k).link           
            case 'id'                
                y_predict(:,k) = XB;
            case 'inv'
                y_predict(:,k) = 1./XB;
            case 'log'
                y_predict(:,k) = exp(XB);
            case 'logit'
                y_predict(:,k) = exp(XB)./(1 + exp(XB));
        end
    end
end