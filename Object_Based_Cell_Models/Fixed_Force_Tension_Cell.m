classdef Fixed_Force_Tension_Cell<handle
    %Fixed_Force_Tension_Single_Cell describes a single cell in a one
    %dimenaional cell System. 
       
    properties (GetAccess = 'public', SetAccess = 'public')
        % The junction tension constant for the cell. This constant
        % is for the junction to the left of the cell.
        tension_constant; 
        
        % x-position for the cell at the start and end of the timestep
        current_pos;
        previous_pos; 
        
        % migrative force of the cell
        internal_cell_force; 
    end
    
    methods
            % Constructor
        function obj = Fixed_Force_Tension_Cell(tension_constant,...
            current_pos,... 
            previous_pos,...
            internal_cell_force)
            if(nargin ~= 0)
                obj.tension_constant= tension_constant;
                obj.current_pos= current_pos;
                obj.previous_pos =previous_pos; 
                obj.internal_cell_force =internal_cell_force; 
            end
        end
        % change the current_pos of the cell, not the previous pos so
        % that cells referencing this one in the same timestep take the
        % previous, start position
        function change_current_pos(obj, dx)
            obj.current_pos = (obj.current_pos + dx);
        end 
        
        % Set the cell force
        function set_cell_force(obj, force)
            obj.internal_cell_force = force;
        end
        
        function force = cell_force(obj)
            force = obj.internal_cell_force;
        end
        
        % updates the previous position to the current. i.e used at the end
        % of each timestep
        function update_previous_pos(obj)
            obj.previous_pos = obj.current_pos;
        end
    end
end 

