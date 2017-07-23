function return_data = batch_density_data( obj, iterations, no_of_cells )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    density_data = zeros(max(1, no_of_cells- 1) , obj.duration/obj.timesteps);
    obj.change_graph_mode(0)
    for i = 1:iterations
        obj.run_simulation();
        % density_data = vertcat(density_data, obj.get_density_data(obj.no_of_cells));
        density_data = density_data + obj.get_density_data(no_of_cells);
        obj.reset_system();
    end
    density_data = density_data/iterations;
    plot([obj.timesteps: obj.timesteps: obj.duration], density_data.');
    
    for c = 1:no_of_cells
        legendInfo{c} = ['Junction = ' num2str(c + obj.no_of_cells-no_of_cells)];
    end
    legend(legendInfo)
    title(strcat('Density Data for cell tension constant=', num2str(obj.Cell_Tension_Constant)))
    
    return_data = density_data;
end
