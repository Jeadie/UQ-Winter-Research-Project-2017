classdef One_Dim_Cell_Array_System < handle
    %UNTITLED8 Summary of this class goes here
    % Class is a Complete 1D Cell System
    % Furtherest Right cell has a positive free migrative force
    % Each Cell junction has an elastic potentially between the two 
    % neighbouring Cells. 
    
    % All Data for the Cells are defined as such
    %       -o-o-o-o-o-o
    % Current_Cell_Pos and Previous_Cell_Pos are vectors for each Cell 
    % Previous_Cell_Pos values are for the beginning of the infintesimal
    % time period and Current_Cell_Pos describe the end of this period and
    % the start of the next
    
    % Cell_Tension_Constant, k describes the tensile junction force between
    % cells: F= -k((xi - x(i-1))-L) where: 
    %    xi, xi-1 are position values for neighbouring cells
    %    L is the natural length where junction experience no tensile force,
    %    rest_junction_ext 
    
    
    % Cell_Force is a vector describing the internal cell force from each
    % cell during the active cell migration
    
    % no_of_cells is the number of cells in the simulation (not including
    % the ghost/dummy cell at x=0)
    
    % timesteps, duration described the length of interval and total
    % duration of the simulation
    
    % position_time_data gives a final matrix of Current_Cell_Pos column
    % vectors at each timestep 
    
    properties (GetAccess = 'public', SetAccess = 'public')
        Current_Cell_Pos
        Previous_Cell_Pos
        Cell_Tension_Constant
        Cell_Force
        rest_junction_ext
        no_of_cells
        timesteps
        duration
        position_time_data
    end
    
    
    properties(Constant)
        % default physical values for the simulation
        default_tension_constant =5;
        default_rest_ext = 10; 
        default_free_end_force =8;
    end 
    
    methods
        % constuctor
        function obj = One_Dim_Pos_Force_System(no_of_cells,...
                                                duration,...
                                                time_steps)
            obj.array_set_up();
            if nargin ~= 0                                   
                obj.duration = duration; 
                obj.timesteps = time_steps;                                
                obj.no_of_cells = no_of_cells;
            end 
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
            force_vect = zeros(obj.no_of_cells, 1);
            force_vect(obj.no_of_cells) = obj.default_free_end_force;
        end
        
        % Constructs the initial position vector for the cells
        % positions are equidistance apart at their natural junction
        % length, rest_junction_ext
        function pos_vect = initial_cell_positions(obj, cell_separation)
            separation_vect = cell_separation*ones(obj.no_of_cells,1);
            pos_vect = cumsum(separation_vect);
        end
        
        % Only public Function needed, runs simulation and produces:
        % run-time graph of the Cell System
        % Final position-time graph for each cell
        % position-time data accessible in matrix form, position_time_data
        function run_simulation(obj)
            iterations = obj.duration/obj.timesteps;
            for iter =1:iterations
                obj.run_iteration();
            end
        end
        
        % runs a single timestep iteration, updates the position vectors,
        % changes the run-time graph and adds to the final matrix
        function obj = run_iteration(obj)
            for cell_ind = 1:obj.no_of_cells
                obj.update_cell(cell_ind);
            end 
            obj.plot_run_time_graph();
            obj.finish_iteration();
            obj.position_time_data = horzcat(obj.position_time_data, obj.Current_Cell_Pos);
        end
        
        % After each iteration, update the previous position vector.  
        function finish_iteration (obj)
            obj.Previous_Cell_Pos = obj.Current_Cell_Pos;
        end 
        
        % Update the run time graph after each iteration
        function plot_run_time_graph(obj)
            plot([1:obj.no_of_cells], obj.Current_Cell_Pos, '*');
            pause(.3); 
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
    end
end