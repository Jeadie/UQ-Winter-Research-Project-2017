function return_data = batch_density_data( obj, iterations )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    density_data = [];
    obj.change_graph_mode(0)
    for i = 1:iterations
        obj.run_simulation();
        density_data = vertcat(density_data, obj.get_density_data(obj.no_of_cells));
        obj.reset_system();
        obj.dirn_time_data = [];
    end
    plot([obj.timesteps: obj.timesteps: obj.duration], density_data.');
    return_data = density_data;
end