classdef One_Dim_Single_Force_Cell_System
    %One_Dim_Single_Force_Cell_System
    properties (GetAccess = 'public', SetAccess = 'private')
        no_of_cells;
        duration; 
        d_time = 0.1; 
        position_time_matrix;
    end 
    
    properties (GetAccess = 'private', SetAccess = 'private')
        cell_array; 
    end
        
    properties (Constant) 
        default_tension_constant = 10; 
        default_initial_extension = 10;
        default_internal_cell_force = 0;
        default_free_edge_cell_force = 20; 
    end 
    
    methods
        function obj = One_Dim_Single_Force_Cell_System(Cell_Number,duration)
            obj.duration = duration; 
            obj.no_of_cells = Cell_Number;
            obj.cell_array = Fixed_Force_Tension_Single_Cell.empty(0, 0); 
            for i = 1:Cell_Number;
                % Create array of Fixed_Force_Tension_Single_Cell Objects
                cell = Fixed_Force_Tension_Single_Cell(obj.default_tension_constant,...
                                                                    (i*obj.default_initial_extension),...
                                                                    (i*obj.default_initial_extension),...
                                                                    obj.default_internal_cell_force);
                obj.cell_array(i) = cell; 
            end 
            % Set furtherest Right to have a fricitonal force as of default
            obj.cell_array(Cell_Number).set_cell_force(obj.default_free_edge_cell_force);
         end 
        
        function run_simulation(obj)
            iteration_total = ceil(obj.duration/ obj.d_time);
            obj.position_time_matrix = zeros(obj.no_of_cells, iteration_total); 
            for i = 1:iteration_total
                obj.run_single_iteration();
                obj.store_position_time_matrix(); 
            end 
            obj.graph_position_time_matrix(); 
        end 
        
        function run_single_iteration(obj)
            for cell = 1:obj.no_of_cells;
               obj.single_cell_iteration(cell)
            end 
            obj.update_previous_pos();
        end 
        
        function update_previous_pos(obj)
            for cell_ind = 1:obj.no_of_cells;
                cell = obj.cell_array(cell_ind);
                cell.update_previous_pos();
            end 
        end 
        % -o-o-o-o
        function single_cell_iteration(obj, cell_ind)
            obj.cell_array(cell_ind);
 
            right_junction_force= obj.right_junction_force(cell_ind);
            left_junction_force = obj.left_junction_force(cell_ind);
                     
            Net_force = obj.cell_array(cell_ind).internal_cell_force+ right_junction_force- left_junction_force;
            dx = obj.d_time * Net_force;
            obj.cell_array(cell_ind).previous_pos = obj.cell_array(cell_ind).current_pos;
            obj.cell_array(cell_ind).current_pos = obj.cell_array(cell_ind).current_pos + dx;
        end
        function change_current_pos(obj, cell, dx)
            cell.previous_pos = cell.current_pos;
            cell.current_pos = (cell.current_pos + dx);  
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
            Current_Cell_Position = zeros(obj.no_of_cells,1); 
            for cell = 1:obj.no_of_cells;
                Current_Cell_Position(cell) = obj.cell_array(cell).current_pos;
            end 
            Current_Cell_Position
            plot([1:obj.no_of_cells], Current_Cell_Position, '*');
            pause(0.01);
        end
        
        function graph_position_time_matrix(obj)
            obj.store_position_time_matrix();
        end
    end
end



