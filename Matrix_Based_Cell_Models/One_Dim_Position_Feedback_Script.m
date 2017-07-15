%{
    Script to Generate a 1x3 plot of 3 1D position-feedback models of
    different feedback constants and random variance
%}
DEFAULT_DURATION = 100;
DEFAULT_TIMESTEPS = 0.1;
DEFAULT_CELL_NO = 10;
DEFAULT_CELL_DISPLAY_NO = 10;
YMAX = 150;
YMIN = 0;
High_Noise = One_Dim_Position_Feedback_System(DEFAULT_CELL_NO, DEFAULT_DURATION,DEFAULT_TIMESTEPS);
High_Noise.change_graph_mode(0);
High_Noise.Feedback_Constant = 1;
High_Noise.delta_dir_magnitude =5; 
High_Noise.run_simulation();
High_Noise_data = High_Noise.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);


subplot(1,3,1)
plot([High_Noise.timesteps:High_Noise.timesteps:High_Noise.duration],High_Noise_data.')
xlabel('Time')
ylabel('Position')
title('High Noise: b=0.50 , y=0.10')
axis([0, 100,YMIN, YMAX ])


Standard_Model = One_Dim_Position_Feedback_System(DEFAULT_CELL_NO, DEFAULT_DURATION,DEFAULT_TIMESTEPS);
Standard_Model.change_graph_mode(0);
Standard_Model.Feedback_Constant = 3;
Standard_Model.delta_dir_magnitude =3; 
Standard_Model.run_simulation();
Standard_Model_data = Standard_Model.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(1,3,2)
plot([Standard_Model.timesteps:Standard_Model.timesteps:Standard_Model.duration],Standard_Model_data.')
xlabel('Time')
ylabel('Position')
title('Standard Model: b=0.30 , y=0.30')
axis([0, 100,YMIN, YMAX ])



High_Feedback = One_Dim_Position_Feedback_System(DEFAULT_CELL_NO, DEFAULT_DURATION,DEFAULT_TIMESTEPS);
High_Feedback.change_graph_mode(0);
High_Feedback.Feedback_Constant = 5;
High_Feedback.delta_dir_magnitude =1; 
High_Feedback.run_simulation();
High_Feedback_data = High_Feedback.get_simulation_data(DEFAULT_CELL_DISPLAY_NO);

subplot(1,3,3)
plot([High_Feedback.timesteps:High_Feedback.timesteps:High_Feedback.duration],High_Feedback_data.')
xlabel('Time')
ylabel('Position')
title('High Feedback: b=0.10 , y=0.50')
axis([0, 100,YMIN, YMAX ])
