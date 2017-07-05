classdef One_Dim_FeedBack_Cell_Array_System < One_Dim_Vary_Force_Cell_Array_System
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = 'public')
        Feedback_Constant = 0.1
    end
    
    methods
        
        function obj = One_Dim_FeedBack_Cell_Array_System(no_of_cells,...
                                                            duration,...
                                                            time_steps)
            obj.duration = duration; 
            obj.timesteps = time_steps;                                
            obj.no_of_cells = no_of_cells;
            obj.array_set_up();
        end
        
        function alter_dirn_vector(obj)
            delta_dirn = (obj.delta_dir_magnitude/3)*randn(obj.no_of_cells, 1); 
            delta_dirn(obj.no_of_cells) = 0; 
            
            Feedback_delta = zeros(obj.no_of_cells, 1);
            %  Iterate through all Cells and get their feedback directions
            %  from (1,0,-1)
            for ind = 1:obj.no_of_cells-1
                Feedback_delta(ind) = obj.get_feedback_angle(ind); 
            end 
            
            obj.dirn_vector = rem((obj.dirn_vector + delta_dirn + Feedback_delta),(2*pi));
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
                feedback_factor = (((right_pos + left_pos)/2) -cell_pos)...
                                    /(obj.default_rest_ext);
                if cur_angle < pi
                    feedback_factor = -1* feedback_factor;
                end
                angle = obj.Feedback_Constant * feedback_factor
        end 
    end
end