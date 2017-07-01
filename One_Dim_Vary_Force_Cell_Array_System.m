classdef One_Dim_Vary_Force_Cell_Array_System < One_Dim_Cell_Array_System
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = 'public')
        dirn_vector
    end
    
    properties (Constant)
        delta_dir_magnitude = 0.35;
    end
    
    methods
        
        function obj = One_Dim_Vary_Force_Cell_Array_System(no_of_cells,...
                                                            duration,...
                                                            time_steps)
            obj.duration = duration; 
            obj.timesteps = time_steps;                                
            obj.no_of_cells = no_of_cells;
            obj.array_set_up();

        end
        
        % Set all cells to have internal cell forces equal magnitude to the
        % final cell
        function force_vect = set_internal_cell_force(obj)
            force_vect = obj.default_free_end_force*  ones(obj.no_of_cells, 1);
            obj.dirn_vector = obj.set_up_dirn_vector();
        end
        
        % Returns the directed magnitude of the cell's force in the x plane
        % Fx = |F|*cos(dirn)
        function force = internal_cell_force(obj, cell_ind)
            force  = obj.Cell_Force(cell_ind) * cos(obj.dirn_vector(cell_ind));
        end
        
        function finish_iteration (obj)
            obj.Previous_Cell_Pos = obj.Current_Cell_Pos;
            obj.alter_dirn_vector()
        end
        
        function dirn_vector = set_up_dirn_vector(obj)
            dirn_vector = zeros(obj.no_of_cells, 1);
            for cell_ind = 1:obj.no_of_cells-1
                dirn_vector(cell_ind) = rem(randn, pi);
            end 
        end
        
        function alter_dirn_vector(obj)
            for i = 1:obj.no_of_cells-1
                obj.dirn_vector(i) =obj.dirn_vector(i)
                                    +obj.delta_dir_magnitude*(rem(randn, 1));  
            end 
        end 
    end
end

