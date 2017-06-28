classdef Fixed_Force_Tension_Single_Cell
    %Fixed_Force_Tension_Single_Cell 
    
    properties (GetAccess = 'public', SetAccess = 'private')
        tension_constant; 
        current_pos;
        previous_pos; 
        internal_cell_force; 
    end
    
    methods
        function obj = Fixed_Force_Tension_Single_Cell(...
            % tension_constant, current and initial extension >0
            % frictional_cell_force >=0
            tension_constant,... % >0
            current_pos,... % 
            previous_pos,...
            internal_cell_force)
            obj.tension_constant= tension_constant;
            obj.current_pos= current_pos;
            obj.previous_pos =previous_pos; 
            obj.internal_cell_force =internal_cell_force; 
        end 
        
        function change_current_pos(obj, dx)
            obj.previous_pos = obj.current_pos;
            if (obj.current_extension + dx) > 0;
                obj.current_pos = obj.current_pos + dx;
            else
                obj.current_pos = 0;
            end 
        end 
        
        function set_cell_force(obj, force)
            if obj.internal_cell_force >0;
                obj.internal_cell_force = force;
            end 
        end
        
        function update_previous_pos(obj)
        obj.previous_pos = obj.current_pos;
        end
    end
end 
