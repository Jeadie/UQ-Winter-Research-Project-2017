function batch_cos_plot( obj, iterations, no_of_cells )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    angle_data = [];
    obj.change_graph_mode(0)
    for i = 1:iterations
        obj.run_simulation();
        if numel(angle_data) ==0
            angle_data = obj.dirn_time_data;
        else
            angle_data = vertcat(angle_data, obj.get_dirn_data(no_of_cells));
        end
        obj.reset_system();
    end
    plot([0: obj.timesteps: obj.duration],sin(angle_data).');
    title(strcat('Cos(theta) vs timefor cell tension constant=', num2str(obj.Cell_Tension_Constant)));
    xlabel('Time');
    ylabel('cos(theta)'); 
end

