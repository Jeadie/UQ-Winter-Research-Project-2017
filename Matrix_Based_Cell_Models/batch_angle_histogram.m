function batch_angle_histogram( obj, iterations, plot_dim, bins )
%  Batch simulate a single object that is an One_Dim_Vary_Force_System
%  object or a subclass. 

%  Creates a (1,partitions) subplot of angular histograms for the obj,
%  after all iterations. Created for specifed bins. 
HISTOGRAMS_PER_ROW = 5;
angle_data = [];
obj.change_graph_mode(0)
partitions = plot_dim(1) * plot_dim(2);
for i = 1:iterations
    obj.run_simulation();
    angle_data = vertcat(angle_data, obj.dirn_time_data);
    obj.reset_system();
    %obj.dirn_time_data = [];
end

iterations = obj.duration/obj.timesteps;
columns = iterations/partitions ;           

for i = 1:partitions
    data = angle_data(:,columns*(i-1) +1:columns*i);
    subplot(plot_dim(1), plot_dim(2), i)
    rose(data(:).', bins)
    
end


end

