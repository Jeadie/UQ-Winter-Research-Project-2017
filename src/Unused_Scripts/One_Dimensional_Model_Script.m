%{
    Script to run a variety of simulations for One_Dim_Cell_Array_System
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

Std_Model = One_Dim_Cell_Array_System(DEFAULT_CELL_NO,...
                                          DEFAULT_DURATION,...
                                          DEFAULT_TIMESTEPS);
%  For this Model: 
%     - Standard parameters for Tension constants, Cell Forces, Junction
%       extensions

Std_Model = One_Dim_Cell_Array_System(DEFAULT_CELL_NO, DEFAULT_DURATION, DEFAULT_TIMESTEPS);
Std_Model.change_graph_mode(0);
Std_Model.run_simulation(); 
Std_Model_Data = Std_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(2,3,2)
plot([Std_Model.timesteps:Std_Model.timesteps:Std_Model.duration],Std_Model_Data.', 'g')
title('Standard System')


%  For this Model: 
%     - Standard parameters for Tension constants and Junction extensions
%     - A Higher Cell Force for the Furtherest Right Cell

High_Force_Model= One_Dim_Cell_Array_System(DEFAULT_CELL_NO, DEFAULT_DURATION, DEFAULT_TIMESTEPS);
High_Force_Model.change_graph_mode(0);
%  Double the free end force
High_Force_Model.change_internal_cell_force(16);
High_Force_Model.run_simulation()
High_Force_Model_data = High_Force_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(2,3,3)
plot([High_Force_Model.timesteps : High_Force_Model.timesteps : High_Force_Model.duration],...
        High_Force_Model_data.', 'r')
title('Increased Internal Cell Force of Leading Cell')                  
%  For this Model: 
%     - Standard parameters for Cell Forces and Junction extensions 
%     - A Higher Cell Junction Tension Constant

High_Cell_Junction_Model = One_Dim_Cell_Array_System(DEFAULT_CELL_NO, DEFAULT_DURATION, DEFAULT_TIMESTEPS);
High_Cell_Junction_Model.change_graph_mode(0);
%  Double the Junction Force constants; should make forward motion weaker
High_Cell_Junction_Model.Cell_Tension_Constant = 10;
High_Cell_Junction_Model.run_simulation(); 
High_Cell_Junction_Model_data = High_Cell_Junction_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(2,3,5)
plot([High_Cell_Junction_Model.timesteps :High_Cell_Junction_Model.timesteps:High_Cell_Junction_Model.duration],...
                        High_Cell_Junction_Model_data.', 'b')
title('Increased Inter Cell Junction Strength')                  
                    
%  For this Model: 
%     - Standard parameters for Tension constants, Cell Forces, Junction
%       extensions
%     - Change the begining Cell Positions such to be greater than the rest
%       juncton length
%     - Will show effect of the Cell Array being in a tensile state and
%       compressive forces should be initially present. 

Compressed_Model = One_Dim_Cell_Array_System(DEFAULT_CELL_NO, DEFAULT_DURATION, DEFAULT_TIMESTEPS);
Compressed_Model.change_graph_mode(0);
Compressed_Model.Current_Cell_Pos = Compressed_Model.initial_cell_positions(12.5);
Compressed_Model.run_simulation(); 
Compressed_Model_Data = Compressed_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(2,3,6)
plot([Compressed_Model.timesteps:Compressed_Model.timesteps:Compressed_Model.duration],Compressed_Model_Data.', 'k')
title('Initially Extended Cell Junctions System')

% Plot all of the subplots on the same graph, with different colours per graph

subplot(2,3,[1 4])
std_x_axis = [Std_Model.timesteps:Std_Model.timesteps:Std_Model.duration]; 
%{ 
plot([Std_Model.timesteps:Std_Model.timesteps:Std_Model.duration],Std_Model_Data.',...
    'g',...
     [High_Force_Model.timesteps : High_Force_Model.timesteps : High_Force_Model.duration],...
         High_Force_Model_data.', 'r',...
     [High_Cell_Junction_Model.timesteps :High_Cell_Junction_Model.timesteps:High_Cell_Junction_Model.duration],...
         High_Cell_Junction_Model_data.', 'b',...
     [Compressed_Model.timesteps:Compressed_Model.timesteps:Compressed_Model.duration],...
     Compressed_Model_Data.', 'y')
 %}
hold on 
p1 = plot(std_x_axis ,Std_Model_Data.','g');
p2 = plot(std_x_axis, High_Force_Model_data.', 'r');
p3 = plot(std_x_axis, High_Cell_Junction_Model_data.', 'b');
p4 = plot(std_x_axis, Compressed_Model_Data.', 'k');
