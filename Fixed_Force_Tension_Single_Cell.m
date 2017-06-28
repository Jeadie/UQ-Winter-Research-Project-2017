classdef Fixed_Force_Tension_Single_Cell
    %Fixed_Force_Tension_Single_Cell 
    
    properties (GetAccess = 'public', SetAccess = 'public')
        tension_constant; 
        current_pos;
        previous_pos; 
        internal_cell_force; 
    end
    
    methods
            % tension_constant, current and initial extension >0
            % frictional_cell_force >=0
        function obj = Fixed_Force_Tension_Single_Cell(tension_constant,... % >0
            current_pos,... 
            previous_pos,...
            internal_cell_force)
            obj.tension_constant= tension_constant;
            obj.current_pos= current_pos;
            obj.previous_pos =previous_pos; 
            obj.internal_cell_force =internal_cell_force; 
        end 
        
        function change_current_pos(obj, dx)
            obj.previous_pos = obj.current_pos;
            obj.current_pos = (obj.current_pos + dx);
        end 
        
        function set_cell_force(obj, force)
            obj.internal_cell_force = force
        end
        
        function update_previous_pos(obj)
        obj.previous_pos = obj.current_pos;
        end
    end
end 

