classdef Varying_Force_Cell < Fixed_Force_Tension_Cell
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        cell_dir 
    end
    
    properties (Constant)
        delta_dir_magnitude = 0.35;
    end
    
    methods
        function obj = Varying_Force_Cell(tension_constant,...
                                        current_pos,... 
                                        previous_pos,...
                                        internal_cell_force)
                                    
        obj.tension_constant= tension_constant;
        obj.current_pos= current_pos;
        obj.previous_pos =previous_pos; 
        obj.internal_cell_force =internal_cell_force;
        
        obj.cell_dir = rem(randn, (pi/2)); 
        end
                
        % Change the cell direction by a max magnitude of delta_dir_magnitude
        function change_dir(obj)
            obj.cell_dir = obj.cell_dir + obj.delta_dir_magnitude*(rem(randn, 1));
        end
        
        function force = cell_force(obj)
            force = (obj.internal_cell_force * cos(obj.cell_dir));
        end
    end
end
