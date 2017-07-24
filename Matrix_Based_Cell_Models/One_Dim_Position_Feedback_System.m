classdef One_Dim_Position_Feedback_System < One_Dim_Vary_Force_System
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here

    properties(Access = 'public')
        Feedback_Constant = 4
    end
    
    methods
        
        function obj = One_Dim_Position_Feedback_System(no_of_cells,...
                                                            duration,...
                                                            time_steps)
            if nargin ~= 0                                            
                obj.duration = duration; 
                obj.timesteps = time_steps;                                
                obj.no_of_cells = no_of_cells;
                obj.array_set_up();
                obj.default_set_up();
                obj.angle_data_setup();

            end 
        end
        
        function alter_dirn_vector(obj)

            Feedback_delta = zeros(obj.no_of_cells, 1);
            %  Iterate through all Cells and get their feedback directions
            %  from (1,0,-1)
            for ind = 1:obj.no_of_cells-1
                Feedback_delta(ind) = obj.get_feedback_angle(ind);
            end 
            
            obj.dirn_vector = rem((obj.dirn_vector + obj.angle_variance_vector() + Feedback_delta),(2*pi));
        end 
        
        % 1< ind < obj.no_of_cells-1
        function angle = get_feedback_angle(obj, ind)
            if ind~= 1    
                left_pos = obj.Previous_Cell_Pos(ind-1);
            else
                left_pos = 0;
            end
                cell_pos = obj.Previous_Cell_Pos(ind);
                right_pos = obj.Previous_Cell_Pos(ind+1);
                cur_angle = obj.dirn_vector(ind);
                feedback_factor = ((cell_pos-left_pos) -(right_pos-cell_pos));
            
                angle = feedback_factor* sin(obj.dirn_vector(ind)) * obj.timesteps;
        end 
    end
end