function vspglmJointPlot(model, formulas,Y, stem_flag, pause)
    K = length(formulas);  
    X = model.X;
    min_Y = min(min(Y));
    max_Y = max(max(Y));
    
    min_Y_1 = min(Y(:,1));
    min_Y_2 = min(Y(:,2));
    max_Y_1 = max(Y(:,1));
    max_Y_2 = max(Y(:,2));

    offset = 0.5;
    ypred2 = model.means;

    %Goal, for each of the groups, look at how the probability masses are
    %tilted? Groups are associated with unique covariate pairs?
    groups = uniquetol(ypred2,1e-8,'ByRows',true); %Change tolerance!
    [~, ind] = sortrows(round(groups, 4));
    groups = groups(ind,:)
    
    unique_vals = uniquetol(Y,1e-5,'ByRows',true);
    unique_cov = 1:length(groups);
    plot_number = length(groups);
    phat_max = preprocess_max(model, formulas,Y, stem_flag, pause)
    masses_per_val = zeros(plot_number, length(unique_vals));
    phat = model.pTiltMatrix;
    
    %Is there a way for me to find the max mass?

    for i = unique_cov
       if plot_number <= 4
          figure(1);
          subplot(2,2,i);
       else
           if ~pause
            figure; 
           end
           
       end
       
       obs_in_group = find(all(ismembertol( ypred2,groups(i,:), 1e-8, 'ByRows', true),2)==1);
       %Plotting the unique pairs


       %masses = sum(phat(obs_in_group,:),1);
       
       masses = phat(obs_in_group,:);
       masses = masses(1,:);
        
       %masses = sum(phat(obs_in_group,:),1);
       for j = 1:length(unique_vals)
           index_to_sum = find(ismember( Y,unique_vals(j,:), 'rows') == 1);
           %disp(index_to_sum)
           masses_per_val(i,j) = sum(masses(index_to_sum));
           
           %Do we need to re-weight???
           %masses_per_val(i,j) = sum(masses(index_to_sum))/length(index_to_sum);
       end
       %hist3(Y, 'Nbins', [5,100])
       
       % If we re-scale, make sure it's actually a pdf by re-scaling.
       masses_per_val(i,:) = masses_per_val(i,:)/sum(masses_per_val(i,:));
       
       
       sizes = masses_per_val(i,:)*((length(unique_vals)-1)/phat_max);
       
       %Colouring scale is per plot
       %indexes = round(rescale(sizes, 1, length(unique_vals)));
       %colormap_length = length(unique_vals);
       
       indexes = round(sizes+1);
       colormap_length = round(length(unique_vals));

       
       %colors = jet(colormap_length); %For burns and UN
       colors = parula(colormap_length); %For burns and UN
       %colors = winter(length(unique_vals)); % For sorbinal
       
       colors_plot = colors(indexes,:);
       %Make scaling w.r.t area 
       sizes = (masses_per_val(i,:))*8000;
       if stem_flag == '3d'
           %stem3(unique_vals(:,2), unique_vals(:,1), masses_per_val(i,:), 'filled', 'LineWidth', 1.5)
%            hold on
%            l = plot(groups(i,2),groups(i,1), '+k', 'linewidth',2);
           
           stem3(unique_vals(:,1), unique_vals(:,2), 2*masses_per_val(i,:), 'filled', 'LineWidth', 1.5)
           zlim([0, phat_max]);
           hold on
           l = plot(groups(i,1),groups(i,2), '+k', 'linewidth',2);
          
           
       else 
           %scatter(unique_vals(:,2), unique_vals(:,1), sizes, colors_plot,'filled');
           %hold on
           %l = plot(groups(i,2),groups(i,1), '+k', 'linewidth',2);
           
           scatter(unique_vals(:,1), unique_vals(:,2), sizes, colors_plot,'filled');
           hold on
           l = plot(groups(i,1),groups(i,2), '+k', 'linewidth',2);
           
       end
       
  
       
       %l = plot(groups(i,2),groups(i,1), '+k', 'linewidth',2);
       %l = plot(groups(i,1),groups(i,2), '+k', 'linewidth',2);
       
       %axis([min_Y-offset, max_Y+offset, min_Y-offset, max_Y+offset]);
       %axis([min_Y_2-offset, max_Y_2+offset, min_Y_1-offset, max_Y_1+offset]);
       axis([min_Y_1-offset, max_Y_1+offset, min_Y_2-offset, max_Y_2+offset]);
       if stem_flag ~= "3d"
            %colorbar;
       end
       
       caxis([0, phat_max]);
       %Specific titles
       %title(['Group ', num2str(i)])
       %xlabel("logGDPpp")
       %ylabel("logFertility")
       %urban = unique(sortrows(X{1}(:,2)));
       %title(num2str(urban(i)) + "% of Population in Urban Areas");
       hold off
       
       l.MarkerSize = 12;
       if pause
           w = waitforbuttonpress;
       end
       
    end
    
    
%     fig = figure(2);
%     %Picking 3 for the report
%     counter = 1;
%     for j = [1,100,177]
%         subplot(1,3,counter)
%         sizes = masses_per_val(j,:)*((length(unique_vals)-1)/phat_max);
%        
%            %Colouring scale is per plot
%            %indexes = round(rescale(sizes, 1, length(unique_vals)));
%            %colormap_length = length(unique_vals);
% 
%            indexes = round(sizes+1);
%            colormap_length = round(length(unique_vals));
% 
% 
%            %colors = jet(colormap_length); %For burns and UN
%            colors = parula(colormap_length); %For burns and UN
%            %colors = winter(length(unique_vals)); % For sorbinal
% 
%            colors_plot = colors(indexes,:);
%            %Make scaling w.r.t area 
%            sizes = (masses_per_val(j,:))*10000;
%         scatter(unique_vals(:,1), unique_vals(:,2),sizes, colors_plot,'filled');
%         hold on
%         l = plot(groups(j,1),groups(j,2), '+k', 'linewidth',3, 'MarkerSize',12);
%         xlabel("logGDPpp")
%         xlim([4,12.5]);
%         ylabel("logFertility")
%         ylim([0,2.25]);
%         urban = unique(sortrows(X{1}(:,2)));
%         title(num2str(urban(j)) + "% Urban Population",'interpreter','latex')
%         hold off
%         counter = counter + 1;
%     end
%     h = axes(fig,'visible','off'); 
%     h.Title.Visible = 'on';
%     h.XLabel.Visible = 'on';
%     h.YLabel.Visible = 'on';
%     colorbar(h,'Position',[0.93 0.11 0.022 0.82]);  % attach colorbar to h
%     caxis(h,[0,phat_max]);   

end