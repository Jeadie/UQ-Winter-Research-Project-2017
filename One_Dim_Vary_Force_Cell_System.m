classdef One_Dim_Vary_Force_Cell_System < One_Dim_Single_Force_Cell_System
    %UNTITLED10 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant) 
        default_internal_cell_force = obj.default_free_edge_cell_force;
    end 
    
    methods
         function obj = One_Dim_Vary_Force_Cell_System(Cell_Number,duration)
            obj.duration = duration; 
            obj.no_of_cells = Cell_Number;
            obj.cell_array = Fixed_Force_Tension_Single_Cell.empty(0, 0); 
            for i = 1:Cell_Number-1;
                % Create array of Fixed_Force_Tension_Single_Cell Objects
                cell = Varying_Force_Cell(obj.default_tension_constant,...
                                        (i*obj.default_initial_extension),...
                                        (i*obj.default_initial_extension),...
                                        obj.default_internal_cell_force);
                obj.cell_array(i) = cell; 
            end 
            
            % Final right cell has a fixed force constant and no change in
            % direction (always moving horizontally right)
            cell = Fixed_Force_Tension_Cell(obj.default_tension_constant,...
                                            (i*obj.default_initial_extension),...
                                            (i*obj.default_initial_extension),...
                                            obj.default_free_edge_cell_force);
            obj.cell_array(Cell_Number) = cell; 
         end 
        
         % Runs a single timestep iteration of the model
        function run_single_iteration(obj)
            for cell = 1:obj.no_of_cells;
               obj.single_cell_iteration(cell)
            end 
            obj.update_cell_directions(); 
            obj.update_previous_pos();
        end 
        
        function update_cell_directions(obj)
            for i = 1:Cell_Number-1;
                obj.cell_array(i).change_dir(); 
            end
        end
    end
end

