classdef One_Dim_Vary_Force_Cell_Array_System < One_Dim_Cell_Array_System

    properties(Access = 'public')
        dirn_vector
        delta_dir_magnitude = 0.35;
    end
    
    methods
        
        function obj = One_Dim_Vary_Force_Cell_Array_System(no_of_cells,...
                                                            duration,...
                                                            time_steps)
            if nargin ~= 0                                            
                obj.duration = duration; 
                obj.timesteps = time_steps;                                
                obj.no_of_cells = no_of_cells;
                obj.array_set_up();
            end 
        end
        
        %  Set all cells to have internal cell forces equal magnitude to the
        %  final cell
        function force_vect = set_internal_cell_force(obj)
            force_vect = obj.default_free_end_force*  ones(obj.no_of_cells, 1);
            obj.dirn_vector = obj.set_up_dirn_vector();
        end
        
        %  Returns the directed magnitude of the cell's force in the x plane
        %  Fx = |F|*cos(dirn)
        function force = internal_cell_force(obj, cell_ind)
            force  = obj.Cell_Force(cell_ind) * cos(obj.dirn_vector(cell_ind));
        end
        
        %  After each iteration, update the previous position vector and 
        %  update the direction vectors of all cells.   
        function finish_iteration (obj)
            obj.Previous_Cell_Pos = obj.Current_Cell_Pos;
            obj.alter_dirn_vector()
        end
        
        %  Create a random vector direction where the vectors are a
        %  uniformally distributed over [0, 2pi]
        function dirn_vector = set_up_dirn_vector(obj)
            dirn_vector = 2*pi*rand(obj.no_of_cells, 1);
            dirn_vector(obj.no_of_cells) = 0;
        end
        
        %  increment each direction in obj.dirn_vector by a normally
        %  distributed value of std deviation of  1/3 obj.delta_dir_magnitude
        %  i.e. 3 deviations is at the delta_dir_magnitude
        function alter_dirn_vector(obj)
            delta_dirn = (obj.delta_dir_magnitude/3)*randn(obj.no_of_cells, 1); 
            delta_dirn(obj.no_of_cells) = 0; 
            
            obj.dirn_vector = rem((obj.dirn_vector + delta_dirn),(2*pi));
        end 
       
        %  Plot the run time graph of the following: 
        %   1. a quiver of the cell position and force vector 
        %   2. a position- time graph of each cell
        function plot_run_time_graph(obj)
            if obj.graphs_enabled
                Fx = obj.Cell_Force.*cos(obj.dirn_vector);
                Fy = obj.Cell_Force.*sin(obj.dirn_vector);
                subplot(1,2,1)
                a = quiver(obj.Current_Cell_Pos, ones(obj.no_of_cells,1), Fx, Fy);

                subplot(1,2,2)
                plot(obj.position_time_data');

                pause(.1); 
            end 
        end
        
        %  Reset the direction vector to uniformly random. 
        function reset_direction_vector(obj)
            obj.dirn_vector = obj.set_up_dirn_vector();
        end
    end
end

