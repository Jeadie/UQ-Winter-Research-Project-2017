function return_data = batch_density_data( obj, iterations, no_of_cells )
%{
    Plots and returns the density data of the obj's density data for a
    certain number of iterations for the fartherest no_of_cells cells.
%}

    %Initiate the return matrix and turn off the runtime display.
    density_data = zeros(max(1, no_of_cells- 1) , obj.duration/obj.timesteps);
    obj.change_graph_mode(0)
    
    %Batch test. Sum results and reset the obj after each iteration. 
    for i = 1:iterations
        obj.run_simulation();
        % density_data = vertcat(density_data, obj.get_density_data(obj.no_of_cells));
        density_data = density_data + obj.get_density_data(no_of_cells);
        obj.reset_system();
    end
    
    % divide by iterations to find an average density over the batch. 
    density_data = density_data/iterations;
    
    %Plot results on the current subplot
    plot([obj.timesteps: obj.timesteps: obj.duration], density_data.');
    
    %Create legend for each junction, numbered. 
    for c = 1:no_of_cells
        legendInfo{c} = ['Junction = ' num2str(c + obj.no_of_cells-no_of_cells)];
    end
    legend(legendInfo)
    
    title(strcat('Density Data for cell tension constant=', num2str(obj.Cell_Tension_Constant)))
    return_data = density_data;
end
