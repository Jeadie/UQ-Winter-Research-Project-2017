classdef One_Dim_Velocity_Feedback_System < One_Dim_Position_Feedback_System
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = 'public')
        radian_velocity = 2*pi % radians/ m/s
        
        % Cell position for two previous timesteps.
        % Used in velocity feedback
        Two_Previous_Cell_Pos
    end
    
    methods
        
        function obj = One_Dim_Velocity_Feedback_System(no_of_cells,...
                                                            duration,...
                                                            time_steps)
            obj.duration = duration; 
            obj.timesteps = time_steps;                                
            obj.no_of_cells = no_of_cells;
            obj.array_set_up();
            obj.Two_Previous_Cell_Pos= obj.Current_Cell_Pos;
        end
        
        % After each iteration, update the previous position vector and
        % Two_Previous_Position_Pos which is used to create an
        % instantaneous velocity.
        function finish_iteration (obj)
            obj.Two_Previous_Cell_Pos = obj.Previous_Cell_Pos;
            obj.Previous_Cell_Pos = obj.Current_Cell_Pos;
            obj.alter_dirn_vector();
        end 
        
        
        function angle = get_feedback_angle(obj, ind)
            % Get instantatenous velocities of both left and right cell
            if ind~= 1    
                left_dx = obj.Previous_Cell_Pos(ind-1)-obj.Two_Previous_Cell_Pos(ind-1); 
            else
                left_dx = 0;
            end
            right_dx = obj.Previous_Cell_Pos(ind+1)-obj.Two_Previous_Cell_Pos(ind+1);
            cur_angle = obj.dirn_vector(ind);
        
            % If angle in quadrants 1,2 then feedback should be inversed. 
            feedback_factor = (right_dx - left_dx)
            if cur_angle < pi
                feedback_factor = -1* feedback_factor;
            end
            
            % angle_change = angular_rate * time * adjacent_cell_velocity
            %              = radians/s * s * m/s
            %              = radians/s * m
            angle = obj.radian_velocity * feedback_factor;
        end 
    end
end