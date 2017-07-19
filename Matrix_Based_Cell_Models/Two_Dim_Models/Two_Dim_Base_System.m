classdef Two_Dim_Base_System< handle

    properties (GetAccess = 'public', SetAccess = 'public')
        Current_Cell_Pos
        Previous_Cell_Pos
        Cell_Tension_Constant
        Cell_Force
        rest_junction_ext
        width
        height
        timesteps
        duration
        position_time_data
        graphs_enabled = 1
        
        default_tension_constant =5;
        default_rest_ext = 10; 
        default_free_end_force =8;
    end
    
    methods
        
        function obj = Two_Dim_Base_System(cell_dim,...
                                           duration,...
                                           time_steps)
        if nargin ~= 0
                obj.duration = duration; 
                obj.timesteps = time_steps;   
                obj.width = cell_dim(2);
                obj.height = cell_dim(1);
        end
        obj.array_set_up()
        end
        
        function array_set_up(obj)
            obj.rest_junction_ext = obj.default_rest_ext;                            
            obj.Current_Cell_Pos = obj.initial_cell_positions(obj.rest_junction_ext);
            obj.Previous_Cell_Pos = obj.Current_Cell_Pos;
            obj.Cell_Tension_Constant = obj.default_tension_constant;
            obj.Cell_Force = obj.set_internal_cell_force();   
        end
        
        % Sets the cell force vector for the simulation
        % In this model on the last cell has a force, default_free_end_force
        function force_vect = set_internal_cell_force(obj)
            force_vect = zeros(obj.height, obj.width);
            force_vect(:, obj.height) = obj.default_free_end_force;
        end
        
        % Constructs the initial position vector for the cells
        % positions are equidistance apart at their natural junction
        % length, rest_junction_ext
        function pos_matrix = initial_cell_positions(obj, cell_separation)
            y_pos = cell_separation*(obj.height+1) -...
                    cumsum(cell_separation*ones(obj.height, obj.width));
            x_pos = cumsum(cell_separation*ones(obj.height, obj.width), 2);
            
            pos_matrix = struct('x', x_pos, 'y', y_pos); 
        end
        
        % Only public Function needed, runs simulation and produces:
        % run-time graph of the Cell System
        % Final position-time graph for each cell
        % position-time data accessible in matrix form, position_time_data
        function run_simulation(obj)
            iterations = obj.duration/obj.timesteps;
            for iter =1:iterations
                obj.run_iteration();
                obj.plot_run_time_graph();
            end
        end
        
        % runs a single timestep iteration, updates the position vectors,
        % changes the run-time graph and adds to the final matrix
        function obj = run_iteration(obj)
            for x = 1:obj.width
                for y = 1:obj.height
                    obj.update_cell(x,y);
                end 
            end 
            obj.finish_iteration();
            obj.position_time_data = cat(3, obj.position_time_data, obj.Current_Cell_Pos);
        end
        
        % After each iteration, update the previous position vector.  
        function finish_iteration (obj)
            obj.Previous_Cell_Pos = obj.Current_Cell_Pos;
        end 
        
        % Update the run time graph after each iteration
        function plot_run_time_graph(obj)
            if obj.graphs_enabled
                quiver(obj.Current_Cell_Pos.x, obj.Current_Cell_Pos.y, obj.Cell_Force, 0*obj.Cell_Force) 
                pause(0.1);
            end
        end
        
        % Updates the position of an individual cell given its internal
        % force and forces it experience due to junction pressure. 
        function obj = update_cell(obj, x,y)
            obj.update_cell_x(x, y);
            obj.update_cell_y(x,y);
        end 
        
        function obj = update_cell_x(obj,x,y)
            right_junction_force= obj.east_junction_force(x,y);
            left_junction_force = obj.west_junction_force(x,y);
            
            Net_force = obj.internal_x_cell_force(x,y)+ right_junction_force- left_junction_force;
            dx = obj.timesteps * Net_force;
            obj.Current_Cell_Pos.x(y,x) =obj.Current_Cell_Pos.x(y,x) + dx;
        end

        function force = internal_x_cell_force(obj, x,y)
            force  = obj.Cell_Force(y,x);
        end

        % Returns the force experienced by the right junction of a cell at
        % cell_ind in the position vector
        function force = east_junction_force(obj, x,y)
            if x ~= obj.width;
                cell_pos = obj.Previous_Cell_Pos.x(y,x);
                other_pos = obj.Previous_Cell_Pos.x(y,x+1);
                extension = (other_pos-cell_pos)-obj.rest_junction_ext;
                force =  obj.Cell_Tension_Constant * extension;
            else
                force = 0;
            end
        end
        
        % Returns the force experienced by the left junction of a cell at
        % cell_ind in the position vector
        function force = west_junction_force(obj, x,y)
            cell_pos = obj.Previous_Cell_Pos.x(y,x);
            if x ==1
                other_pos = 0;
            else
                other_pos = obj.Previous_Cell_Pos.x(y,x-1);
            end
            extension = (cell_pos-other_pos)-obj.rest_junction_ext;
            force =  obj.Cell_Tension_Constant * extension;
        end
        
        function obj = update_cell_y(obj,x,y)
            north_junction_force= obj.north_junction_force(x,y);
            south_junction_force = obj.south_junction_force(x,y);

            Net_force = obj.internal_y_cell_force(x,y)+ north_junction_force- south_junction_force;
            dy = obj.timesteps * Net_force;
            obj.Current_Cell_Pos.y(y,x) =obj.Current_Cell_Pos.y(y,x) + dy;
        end
        
        function force = internal_y_cell_force(obj, x,y)
            force = 0; 
        end
        
         % Returns the force experienced by the right junction of a cell at
        % cell_ind in the position vector
        function force = north_junction_force(obj, x,y)
            if y ~= 1;
                cell_pos = obj.Previous_Cell_Pos.y(y,x);
                other_pos = obj.Previous_Cell_Pos.y(y-1,x);
                extension = (other_pos-cell_pos)-obj.rest_junction_ext;
                force =  obj.Cell_Tension_Constant * extension;
            else
                force = 0;
            end
        end
        
        % Returns the force experienced by the left junction of a cell at
        % cell_ind in the position vector
        function force = south_junction_force(obj, x,y)
            if y~= obj.height
                cell_pos = obj.Previous_Cell_Pos.y(y,x);
                other_pos = obj.Previous_Cell_Pos.y(y+1,x);
                extension = (cell_pos-other_pos)-obj.rest_junction_ext;
                force =  obj.Cell_Tension_Constant * extension;
            else
                force = 0; 
            end
        end
        
        %  Resets all the position data to initial
        function reset_system(obj)
            obj.array_set_up();
            obj.position_time_data = [];
        end
        
        %  Change the default tension constants
        function change_tension_constant(obj, constant)
            obj.default_tension_constant = constant; 
        end 
        
        %  Change the default junction extension between cells such that
        %  there is no compressive/repulsive forces present. 
        function change_junction_extension(obj, extension)
            obj.default_rest_ext = extension;
        end
        
        %  Change the magnitude of the free end force parallel to the 1
        %  Dimension
        function change_internal_cell_force(obj, force)
            obj.default_free_end_force =force;
            obj.Cell_Force  = obj.set_internal_cell_force();
        end
        
        %  Alter the Timesteps of the system. Requires that 
        %  obj.run_simulation() has not been run since instantiating or 
        %  running obj.reset_system()
        function change_timesteps(obj, timesteps)
            obj.timesteps = timesteps;
        end
        
        %  Change the duration of the simulation. Requires that 
        %  obj.run_simulation() has not been run since instantiating or 
        %  running obj.reset_system()
        function change_duration(obj, duration)
            obj.duration = duration;
        end 
        
        %  Change whether system will display run-time graphs. A logical
        %  one will enable the graphs, and a 0 will disable them. 
        function change_graph_mode(obj, mode)
            obj.graphs_enabled = mode; 
        end
        
        
        %  Returns a matrix of simulation data for the number of cells
        %  specified. These cells are counted from right to left. i.e. the
        %  closest no_of_cells cells to and including the fartherest right
        %  cell
        function model_data = get_simulation_data(obj)
            model_data= obj.height;
        end
        
    end   
end