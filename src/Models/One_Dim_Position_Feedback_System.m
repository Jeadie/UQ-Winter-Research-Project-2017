classdef One_Dim_Position_Feedback_System < One_Dim_Vary_Force_System
    %{
    One_Dim_Position_Feedback_System is the final model, created during
    the winter research period. Has the following stochastic equations: 
    
    d(theta)i/dt = 
    dxi/dt = 
    
    The public interface for the class is (description can be found
    above methods and in ReadME):
    
        -One_Dim_Position_Feedback_System(no_of_cells, duration, time_steps)
        -run_simulation(obj)
        -reset_system(obj)
        -change_tension_constant(obj, constant)
        -change_graph_mode(obj, mode)
        -change_noise(obj, noise)
        -get_simulation_data(obj, no_of_cells)
        -get_persistence_data(obj)
        -get_density_data(obj, no_of_cells)
        -get_dirn_data(obj, no_of_cells)
        -plot_persistence_data(obj)
        -plot_density_data(obj, no_of_cells)
        -plot_dirn_histogram(obj, no_of_cells, bins)
        -plot_dirn_plot(obj, no_of_cells)
    
    Default Values for created objects are: 
        -Feedback_Constant = 4
        -default_tension_constant =2;
        -default_rest_ext = 10; 
        -default_free_end_force =8;
        -delta_dir_magnitude = 10;

    %}
    
    properties(Access = 'public')
        Feedback_Constant = 4
    end
    
    methods
        
        function obj = One_Dim_Position_Feedback_System(no_of_cells,...
                                                            duration,...
                                                            time_steps)
            if nargin ~= 0                                            
                obj.duration = duration; 
                obj.timesteps = time_steps;                                
                obj.no_of_cells = no_of_cells;
                obj.array_set_up();
                obj.default_set_up();
                obj.angle_data_setup();

            end 
        end
        
        function alter_dirn_vector(obj)

            Feedback_delta = zeros(obj.no_of_cells, 1);
            %  Iterate through all Cells and get their feedback directions
            %  from (1,0,-1)
            for ind = 1:obj.no_of_cells-1
                Feedback_delta(ind) = obj.get_feedback_angle(ind);
            end 
            
            obj.dirn_vector = rem((obj.dirn_vector + obj.angle_variance_vector() + Feedback_delta),(2*pi));
        end 
        
        % 1< ind < obj.no_of_cells-1
        function angle = get_feedback_angle(obj, ind)
            if ind~= 1    
                left_pos = obj.Previous_Cell_Pos(ind-1);
            else
                left_pos = 0;
            end
                cell_pos = obj.Previous_Cell_Pos(ind);
                right_pos = obj.Previous_Cell_Pos(ind+1);
                cur_angle = obj.dirn_vector(ind);
                feedback_factor = ((cell_pos-left_pos) -(right_pos-cell_pos));
            
                angle = feedback_factor* sin(obj.dirn_vector(ind)) * obj.timesteps;
        end 
    end
end