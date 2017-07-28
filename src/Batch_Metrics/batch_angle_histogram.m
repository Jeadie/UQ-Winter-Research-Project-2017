function angle_data = batch_angle_histogram( obj, iterations, plot_dim, bins)
%{
    Batch simulate a single object that is an One_Dim_Vary_Force_System
    object or a subclass. 

    Creates a (1,partitions) subplot of angular histograms for the obj,
    after all iterations. Created for specifed bins. 
%}

    % Set up return data, turn off the runtime displaly
    angle_data = [];
    obj.change_graph_mode(0)
    
    % number of partitions is product of dimensions
    % i.e. 2x3 plot has 6 angular histograms. 
    partitions = plot_dim(1) * plot_dim(2);
    
    %Batch simulate the model, appending data and reseting the obj on each
    %iteration. 
    for i = 1:iterations
        obj.run_simulation();
        angle_data = vertcat(angle_data, obj.dirn_time_data);
        obj.reset_system();
        %obj.dirn_time_data = [];
    end

    % the number of steps in each histogram is: 
    % total number of steps/number of histograms
    no_of_steps = obj.duration/obj.timesteps;
    steps_per_histograms = no_of_steps/partitions;           

    for i = 1:partitions
        % data for each histogram is not cumulative. Just the data in that
        % time period. i.e. 6 secs with 5 histograms has times 0-2, 2-4,
        % 4-6. 
        data = angle_data(:,steps_per_histograms*(i-1) +1:steps_per_histograms*i);
        subplot(plot_dim(1), plot_dim(2), i )
        rose(data(:).', bins)
    end
end

