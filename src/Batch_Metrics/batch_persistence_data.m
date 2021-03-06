function return_data = batch_persistence_data( obj, iterations )
%{ 
    Batch simulate a single object that is an One_Dim_Vary_Force_System
    object or a subclass. 
%} 

%  Creates a (1,partitions) subplot of angular histograms for the obj,
%  after all iterations. Created for specifed bins. 
    persistence_data = [];
    obj.change_graph_mode(0)
    
    %Batch test. Append results and reset obj each iteration. 
    for i = 1:iterations
        obj.run_simulation();
        persistence_data = vertcat(persistence_data, obj.get_persistence_data());
        obj.reset_system();
    end
    
    %Plot the result on the current subplot
    plot([obj.timesteps: obj.timesteps: obj.duration-obj.timesteps],persistence_data.');
    title(strcat('Persistence Data for cell tension constant=', num2str(obj.Cell_Tension_Constant)))

    return_data = persistence_data;
end

