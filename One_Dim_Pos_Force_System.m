classdef One_Dim_Pos_Force_System < handle
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
    default_cell_tension =5;
    default_rest_ext = 10; 
    default_free_end_force =8;
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
            separation_vect = cell_separation*ones(obj.Cell_number,1);
            pos_vect = cumsum(separation_vect);
        end
        
        function run_simulation(obj)
            iterations = obj.duration/obj.timesteps;
            
            for iter =1:iterations
                obj.run_iteration();
            end
        end
          
        function obj = run_iteration(obj)
            for cell_ind = 1:obj.Cell_number
                obj.update_cell(cell_ind);
            end 
            a= obj.Current_Cell_Pos- obj.Previous_Cell_Pos
            plot([1:obj.Cell_number], obj.Current_Cell_Pos, '*');
            pause(.1);  
            obj.Previous_Cell_Pos = obj.Current_Cell_Pos;
            obj.position_time_data = horzcat(obj.position_time_data, obj.Current_Cell_Pos);
        end
        
        function obj = update_cell(obj, cell_ind)
            right_junction_force= obj.right_junction_force(cell_ind);
            left_junction_force = obj.left_junction_force(cell_ind);
            
            Net_force = obj.Cell_Force(cell_ind)+ right_junction_force- left_junction_force;
            dx = obj.timesteps * Net_force;
            obj.Current_Cell_Pos(cell_ind) = obj.Current_Cell_Pos(cell_ind) +dx;
        end
        
        function force = right_junction_force(obj, cell_ind)
            if cell_ind ~= obj.Cell_number;
                cell_pos = obj.Previous_Cell_Pos(cell_ind);
                other_pos = obj.Previous_Cell_Pos(cell_ind+1);
                extension = (other_pos-cell_pos)-obj.rest_junction_ext;
                force =  obj.Cell_Tension_Constant * extension;
            else
                force = 0;
            end
        end 
        
        function force = left_junction_force(obj, cell_ind)
            cell_pos = obj.Previous_Cell_Pos(cell_ind);
            if cell_ind ==1
                other_pos = 0;
            else
                other_pos = obj.Previous_Cell_Pos(cell_ind-1);
            end
            extension = (cell_pos-other_pos)-obj.rest_junction_ext;
            force =  obj.Cell_Tension_Constant * extension;
        end
    end
end