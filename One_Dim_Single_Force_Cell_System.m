classdef One_Dim_Single_Force_Cell_System
    %One_Dim_Single_Force_Cell_System
    properties (GetAccess = 'public', SetAccess = 'private')
        no_of_cells;
        duration; 
        d_time = 0.5; 
        position_time_matrix;
    end 
    
    properties (GetAccess = 'private', SetAccess = 'private')
        cell_array; 
    end
        
    properties (Constant) 
        default_tension_constant = 1; 
        default_initial_extension = 1;
        default_frictional_cell_force = 0;
        default_free_edge_cell_force = 1; 
    end 
    
    methods
        function obj = One_Dim_Single_Force_Cell_System(Cell_Number,...
                                                        duration)
            obj.duration = duration; 
            obj.no_of_cells = Cell_Number;
            obj.cell_array = zeros(Cell_Number, 1); 
            for i = 1:Cell_Number
                % Create array of Fixed_Force_Tension_Single_Cell Objects
                obj.cell_array(i) = Fixed_Force_Tension_Single_Cell(obj.default_tension_constant,...
                                                                    obj.default_initial_extension,...
                                                                    obj.default_initial_extension,...
                                                                    obj.default_frictional_cell_force);
            end 
            % Set furtherest Right to have a fricitonal force as of default
            obj.cell_array(Cell_Number).set_frictional_force(obj.default_free_edge_cell_force); 
         end 
        
        function run_simulation(obj)
            iteration_total = ceil(obj.duration/ obj.d_time);
            obj.position_time_matrix = zeros(obj.no_of_cells, iteration_total); 
            for i = 1:iteration_total
                obj.run_single_iteration();
                obj.store_position_time_matrix(); 
            end 
            graph_position_time_matrix(); 
        end 
        
        function run_single_iteration(obj)
            for cell = 1:obj.no_of_cells;
               obj.single_cell_iteration(cell)
            end 
            
        end 
        -o-o-o-o
        function single_cell_iteration(obj, cell_pos)
            cell = obj.cell_array(cell_pos);
            left_junction_force = 0; 
            right_spring_force= 0; 
            left_junction_force = cell.current_junction_force();
            if cell_pos ~= obj.no_of_cells
                right_junction_force = obj.cell_array(cell_pos+1).current_junction_force();
            end
            
            Net_force = cell.frictional_cell_force+ right_spring_force- left_spring_force; 
            dx = obj.d_time * Net_force;
            cell.change_current_extension(dx);
            end 
        
        end 
        
        function store_position_time_matrix(obj)
        end
        
    
end

