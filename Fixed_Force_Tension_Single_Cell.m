classdef Fixed_Force_Tension_Single_Cell
    %Fixed_Force_Tension_Single_Cell 
    
    properties (GetAccess = 'public', SetAccess = 'private')
        tension_constant; 
        current_extension;
        initial_extension; 
        frictional_cell_force; 
    end
    
    methods
        function obj = Fixed_Force_Tension_Single_Cell(...
            % tension_constant, current and initial extension >0
            % frictional_cell_force >=0
            tension_constant,... % >0
            current_extension,... % 
            initial_extension,...
            frictional_cell_force...
            )
            obj.tension_constant= tension_constant;
            obj.current_extension= current_extension;
            obj.initial_extension =initial_extension; 
            obj.frictional_cell_force =frictional_cell_force; 
        end 
        
        function change_current_extension(obj, dx)
            if (obj.current_extension + dx) > 0;
                obj.current_extension = obj.current_extension + dx;
            else
                obj.current_extension = 0;
            end 
        end 
        
        function tension_length = delta_extension(obj)
            tension_length = obj.current_extension - obj.initial_extension;
        end 
        
        function force = current_junction_force(obj)
            force = obj.tension_constant*(obj.delta_extension())
        end
        
        function set_frictional_force(obj, force)
            if obj.frictional_cell_force >0;
                obj.frictional_cell_force = force
            end 
        end 
    end
end 

