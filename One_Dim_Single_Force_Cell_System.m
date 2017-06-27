classdef One_Dim_Single_Force_Cell_System
    %One_Dim_Single_Force_Cell_System
    properties (GetAccess = 'public', SetAccess = 'private')
        no_of_cells;
        duration; 
        d_time = 0.5; 
        
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
        cell_array = zeros(Cell_Number, 1); 
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
            
        end 
        
    
end

