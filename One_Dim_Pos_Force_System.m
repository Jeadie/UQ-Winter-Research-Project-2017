classdef One_Dim_Pos_Force_System
    %UNTITLED8 Summary of this class goes here
    %   Detailed explanation goes here
        
    properties (GetAccess = 'public', SetAccess = 'public')
        Current_Cell_Pos
        Previous_Cell_Pos
        Cell_Tension_Constant
        Cell_Force
        rest_junction_ext
        Cell_number
        timesteps
        duration
        position_time_data
    end
    
    properties(Constant)
    default_cell_tension =10;
    default_rest_ext = 10; 
    default_free_end_force =10;
    end 
    
    methods
        function obj = One_Dim_Pos_Force_System(cell_number,...
                                                duration,...
                                                time_steps)
            obj.duration = duration; 
            obj.timesteps = time_steps;                                
            obj.Cell_number = cell_number;
                               
            obj.rest_junction_ext = obj.default_rest_ext;                            
            obj.Current_Cell_Pos = obj.initial_cell_positions(obj.rest_junction_ext);
            obj.Previous_Cell_Pos = obj.Current_Cell_Pos; 
            obj.Cell_Tension_Constant = obj.default_cell_tension;
            obj.Cell_Force = obj.set_internal_cell_force();
         end
        
        function force_vect = set_internal_cell_force(obj)
            force_vect = zeros(obj.Cell_number, 1);
            force_vect(obj.Cell_number) = obj.default_free_end_force;
            
        end
        
        function pos_vect = initial_cell_positions(obj, cell_separation)
            separation_vect = cell_separation*ones(obj.cell_number,1);
            pos_vect = cumsum(separation_vect);
        end
        
        function run_simulation(obj)
            iterations = obj.duration/obj.time_steps;
            
            for iter =1:iterations
                
            end
        end
          
        
        
    end
end