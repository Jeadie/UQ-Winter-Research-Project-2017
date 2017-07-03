%{
    Script to run a variety of simulations for One_Dim_Vary_Force_Cell_Array_System
%} 
hold on 
%  Create Standard Model for 1D System. For All Graphs: 
%     - 10 Cells, with a focus on the behaviour of the furtherest right
%       five. 
%     - Disable run-time Graphs
%     - Duration enough to create equilibrium solution
DEFAULT_DURATION = 50;
DEFAULT_TIMESTEPS = 0.05;
DEFAULT_CELL_NO = 10;
DEFAULT_CELL_DISPLAY_NO = 4;



%  For this Model: 
%     - Standard parameters for Tension constants, Cell Forces, Junction
%       extensions

Std_Model = One_Dim_Vary_Force_Cell_Array_System(DEFAULT_CELL_NO, DEFAULT_DURATION, DEFAULT_TIMESTEPS);
Std_Model.change_graph_mode(0);
Std_Model.run_simulation(); 
Std_Model_Data = Std_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(2,3,2)
plot([Std_Model.timesteps:Std_Model.timesteps:Std_Model.duration],Std_Model_Data.', 'g')
title('Standard System')


%  For this Model: 
%     - An increase in maximum angle deviation per timestep

High_Force_Model= One_Dim_Vary_Force_Cell_Array_System(DEFAULT_CELL_NO, DEFAULT_DURATION, DEFAULT_TIMESTEPS);
High_Force_Model.change_graph_mode(0);

%  Double the angle change variation
High_Force_Model.delta_dir_magnitude = 0.7;
High_Force_Model.run_simulation()
High_Force_Model_data = High_Force_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(2,3,3)
plot([High_Force_Model.timesteps : High_Force_Model.timesteps : High_Force_Model.duration],...
        High_Force_Model_data.', 'r')
title('Increased Cell Direction Deviation')     



%  For this Model: 
%     - Align the starting Cell Dirn vectors to the right

High_Cell_Junction_Model = One_Dim_Vary_Force_Cell_Array_System(DEFAULT_CELL_NO, DEFAULT_DURATION, DEFAULT_TIMESTEPS);
High_Cell_Junction_Model.change_graph_mode(0);

High_Cell_Junction_Model.dirn_vector = zeros(10,1);
High_Cell_Junction_Model.run_simulation(); 
High_Cell_Junction_Model_data = High_Cell_Junction_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(2,3,5)
plot([High_Cell_Junction_Model.timesteps :High_Cell_Junction_Model.timesteps:High_Cell_Junction_Model.duration],...
                        High_Cell_Junction_Model_data.', 'b')
title('Align Initial Cell Directions')                  
  


%  For this Model: 
%     - Standard parameters for Tension constants, Cell Forces, Junction
%       extensions
%     - Change the begining Cell Positions such to be greater than the rest
%       juncton length
%     - Will show effect of the Cell Array being in a tensile state and
%       compressive forces should be initially present. 

Compressed_Model = One_Dim_Vary_Force_Cell_Array_System(DEFAULT_CELL_NO, DEFAULT_DURATION, DEFAULT_TIMESTEPS);
Compressed_Model.change_graph_mode(0);
Compressed_Model.change_internal_cell_force(16);
Compressed_Model.run_simulation(); 
Compressed_Model_Data = Compressed_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(2,3,6)
plot([Compressed_Model.timesteps:Compressed_Model.timesteps:Compressed_Model.duration],Compressed_Model_Data.', 'k')
title('Increase Cell Force Magnitude')



% Plot all of the subplots on the same graph, with different colours per graph

subplot(2,3,[1 4])
std_x_axis = [Std_Model.timesteps:Std_Model.timesteps:Std_Model.duration]; 

hold on 
p1 = plot(std_x_axis ,Std_Model_Data.','g');
p2 = plot(std_x_axis, High_Force_Model_data.', 'r');
p3 = plot(std_x_axis, High_Cell_Junction_Model_data.', 'b');
p4 = plot(std_x_axis, Compressed_Model_Data.', 'k');
