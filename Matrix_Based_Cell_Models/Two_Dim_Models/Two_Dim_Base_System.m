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
            for cell_ind = 1:obj.no_of_cells
                obj.update_cell(cell_ind);
            end 
            obj.finish_iteration();
            obj.position_time_data = horzcat(obj.position_time_data, obj.Current_Cell_Pos);
        end
        
        % After each iteration, update the previous position vector.  
        function finish_iteration (obj)
            obj.Previous_Cell_Pos = obj.Current_Cell_Pos;
        end 
        
        % Update the run time graph after each iteration
        function plot_run_time_graph(obj)
            if obj.graphs_enabled
                plot([1:obj.no_of_cells], obj.Current_Cell_Pos, '*');
                pause(.05); 
            end
        end
        
        % Updates the position of an individual cell given its internal
        % force and forces it experience due to junction pressure. 
        function obj = update_cell(obj, cell_ind)
            right_junction_force= obj.right_junction_force(cell_ind);
            left_junction_force = obj.left_junction_force(cell_ind);
            
            Net_force = obj.internal_cell_force(cell_ind)+ right_junction_force- left_junction_force;
            dx = obj.timesteps * Net_force;
            obj.Current_Cell_Pos(cell_ind) = obj.Current_Cell_Pos(cell_ind) +dx;
        end

        function force = internal_cell_force(obj, cell_ind)
            force  = obj.Cell_Force(cell_ind);
        end

        % Returns the force experienced by the right junction of a cell at
        % cell_ind in the position vector
        function force = right_junction_force(obj, cell_ind)
            if cell_ind ~= obj.no_of_cells;
                cell_pos = obj.Previous_Cell_Pos(cell_ind);
                other_pos = obj.Previous_Cell_Pos(cell_ind+1);
                extension = (other_pos-cell_pos)-obj.rest_junction_ext;
                force =  obj.Cell_Tension_Constant * extension;
            else
                force = 0;
            end
        end
        
        % Returns the force experienced by the left junction of a cell at
        % cell_ind in the position vector
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
        
        
        %  Change the number of the cells to be run in the simulation.
        %  Requires that obj.run_simulation() has not been run since
        %  instantiating or running obj.reset_system()
        function change_cell_number(obj, cell_number)
            obj.no_of_cells = cell_number;
            obj.reset_system();
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
        function model_data = get_simulation_data(obj, no_of_cells)
            end_ind = obj.no_of_cells ;
            if nargin == 0 
                start_ind = 1;
            else
                % If a cell no is specified, select from right to left
                start_ind = (end_ind +1 )-no_of_cells;
            end 
            % Index all rows from fartherest right cell data to the
            % specifie
            model_data = obj.position_time_data([start_ind:end_ind],:); 
        end 
        
    end   
end