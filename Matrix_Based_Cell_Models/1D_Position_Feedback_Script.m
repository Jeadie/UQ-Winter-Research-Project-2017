%{
    Script to Generate a 1x3 plot of 3 1D position-feedback models of
    different feedback constants and random variance
%}
DEFAULT_DURATION = 100;
DEFAULT_TIMESTEPS = 0.1;
DEFAULT_CELL_NO = 10;
DEFAULT_CELL_DISPLAY_NO = 5;

hold on
Standard_Model = One_Dim_Position_Feedback_System(DEFAULT_CELL_NO, DEFAULT_DURATION,DEFAULT_TIMESTEPS);
Standard_Model.change_graph_mode(0);
Standard_Model.run_simulation();
Standard_Model.Feedback_Constant = 0.35;
Standard_Model.delta_dir_magnitude =0.35; 
Standard_Model_data = Standard_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO)

subplot(1,3,2)
plot([Standard_Model.timesteps:Standard_Model.timesteps:Standard_Model.duration],Standard_Model_Data.', 'g'
xlabel('Time')
ylabel('Position')
Title('?=0.35 , ?=0.35')


High_Feedback = One_Dim_Position_Feedback_System(DEFAULT_CELL_NO, DEFAULT_DURATION,DEFAULT_TIMESTEPS);
High_Feedback.change_graph_mode(0);
High_Feedback.run_simulation();
High_Feedback.Feedback_Constant = 0.6;
High_Feedback.delta_dir_magnitude =0.10; 
High_Feedback_data = High_Feedback.get_simulation_data(DEFAULT_CELL_DISPLAY_NO)

subplot(1,3,3)
plot([High_Feedback.timesteps:High_Feedback.timesteps:High_Feedback.duration],High_Feedback_data.', 'g'
xlabel('Time')
ylabel('Position')
Title('?=0.10 , ?=0.60')


High_Noise = One_Dim_Position_Feedback_System(DEFAULT_CELL_NO, DEFAULT_DURATION,DEFAULT_TIMESTEPS);
High_Noise.change_graph_mode(0);
High_Noise.run_simulation();
High_Noise.Feedback_Constant = 0.10;
High_Noise.delta_dir_magnitude =0.60; 
High_Noise_data = High_Noise.get_simulation_data(DEFAULT_CELL_DISPLAY_NO)

subplot(1,3,1)
plot([High_Noise.timesteps:High_Noise.timesteps:High_Noise.duration],High_Noise_data.', 'g'
xlabel('Time')
ylabel('Position')
Title('?=0.60 , ?=0.10')
hold off
