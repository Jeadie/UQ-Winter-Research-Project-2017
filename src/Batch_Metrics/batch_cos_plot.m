function angle_data = batch_cos_plot( obj, iterations, no_of_cells )
%{ 
    Plots the cosine of the angle data for the fartherest no_of_cells
    cells for a number of iterations for the obj and returns the angle
    data.
%}

    %Set up data matrix and turn off runtime display. 
    angle_data = [];
    obj.change_graph_mode(0)
    
    % Simulation system, append data after every iteration through and
    % reset the obj. 
    for i = 1:iterations
        obj.run_simulation();
        if numel(angle_data) ==0
            angle_data = obj.dirn_time_data;
        else
            angle_data = vertcat(angle_data, obj.get_dirn_data(no_of_cells));
        end
        obj.reset_system();
    end
    
    % Plot the results of the data
    plot([0: obj.timesteps: obj.duration],cos(angle_data).');
    title(strcat('Cos(theta) vs timefor cell tension constant=', num2str(obj.Cell_Tension_Constant)));
    xlabel('Time');
    ylabel('cos(theta)'); 
end

