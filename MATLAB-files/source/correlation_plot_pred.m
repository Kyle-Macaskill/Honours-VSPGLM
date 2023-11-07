function correlation_plot_pred(model, dim_1, dim_2)

    pred = model.means;
    count = 1;
    %figure(1)

    y1lin = linspace(min(pred(:,dim_1)), max(pred(:,dim_1)), 100);
    y2lin = linspace(min(pred(:,dim_2)), max(pred(:,dim_2)), 100);
    [X,Y] = meshgrid(y1lin, y2lin);
    z = zeros(1,length(pred));

    % Extract the correlations
    for n = 1:length(pred)
        covar = model.yCovariance;
        covar_n = covar{n};
        z(n) = covar_n(dim_1,dim_2)/(sqrt(covar_n(dim_1,dim_1))*sqrt(covar_n(dim_2,dim_2)));
    end

    subh3 =  subplot(1,1,1);
    caxis(subh3,[-1,1])
    dotsize = 15;
    scatter3(pred(:,dim_1),pred(:,dim_2),z, dotsize, z, 'filled')
    hold on
    %scatter3(pred_mu_final(:,1), pred_mu_final(:,2),corr_mu, dotsize, 'r', 'filled')
    view(0, 90)
    axis tight
    colorbar
    %xlabel("logGDPpp")
    %ylabel("logFertility")
    title("Fitted Model and Correlation")
%     Z = griddata(pred(:,dim_1),pred(:,dim_2),z,X,Y, 'cubic');
%     %         figure
%     subh1 = subplot(1,2,2);
%     caxis(subh1,[-1,1])
%     mesh(X,Y,Z)
%     view(0, 90)
%     axis tight
%     hold on
%     plot3(pred(:,dim_1),pred(:,dim_2),z,'.r','MarkerSize',15)
%     colorbar

    
   
 
end