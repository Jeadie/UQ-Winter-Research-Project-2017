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
        default_tension_constant = 10; 
        default_initial_extension = 10;
        default_internal_cell_force = 0;
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
                                                                    obj.default_internal_cell_force);
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
            obj.update_current_previous_pos();
        end 
        
        function update_previous_pos(obj)
            for cell = 1:obj.no_of_cells;
               obj.cell_array(cell).update_previous_pos();
            end 
        end 
        % -o-o-o-o
        function single_cell_iteration(obj, cell_ind)
            cell = obj.cell_array(cell_ind);
            right_junction_force= obj.right_junction_force(cell_ind);
            left_junction_force = obj.left_junction_force(cell_ind);
                     
            Net_force = cell.internal_cell_force+ right_junction_force- left_junction_force; 
            dx = obj.d_time * Net_force;
            cell.change_current_pos(dx);    
        end 
        
        function force = right_junction_force(obj, cell_ind)
            if cell_ind ~= obj.no_of_cells;
                cell_pos = obj.cell_array(cell_ind).previous_pos;
                other_pos = obj.cell_array(cell_ind+1).previous_pos;
                extension = (other_pos-cell_pos)-obj.default_initial_extension;
                force =  obj.cell_array(cell_ind).tension_constant * extension;
            else
                force = 0;
            end
        end 
        
        function force = left_junction_force(obj, cell_ind)
            cell_pos = obj.cell_array(cell_ind).previous_pos;
            if cell_ind ==1
                other_pos = 0;
            else
                other_pos = obj.cell_array(cell_ind-1).previous_pos;
            end
            extension = (other_pos-cell_pos)-obj.default_initial_extension;
            force =  obj.cell_array(cell_ind).tension_constant * extension;
        end
        
        function store_position_time_matrix(obj)
            Current_Cell_Position = zeros(CELL_NUMBER,1); 
            for cell = 1:obj.no_of_cells;
                Current_Cell_Position(cell) = obj.cell_array(cell).current_pos;
            end 
            plot([1:obj.no_of_cells], Current_Cell_Position, '*');
            pause(0.1);
        end
        
    
end
