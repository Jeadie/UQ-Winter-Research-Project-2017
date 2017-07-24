# UQ-Winter-Research-Project-2017
Mathematical modelling of rho signalling at cell-cell junctions during collective cell  migration

This repository includes all files and scripts created during my research period with the School and Mathematics and Physics during the winter break. 

The src directory has the following subdirectories: Batch_Metrics, Metric_Comparison, Models, Unused_Scripts. 

**Models**: contains all the classes in the hierachy to develop the final model: One_Dim_Position_Feedback_System. Class interface contains the relevant application logic to run simulations, gather and plot relevant simulation metrics and results. 

**Batch_Metrics**: contains methods to batch simulation a specific class object (generally One_Dim_Position_Feedback_System) through a number of iterations and return a plot for the specified metric. 

**Metric_Comparison**: contains methods to compare identical class objects with different cell junction constants batched with Batch_Metrics functions. 

**Unused_Scripts**: A variety of scripts used in the development of the final model and metrics. 

## Tutorial


```matlab
  % Create a Feedback Model with 10 cells, with a time of 15 and 0.1 increments
  model = One_Dim_Position_Feedback_System(10, 15, 0.1)
  
  % Run simulation without runtime display
  model.change_graph_mode(0) % 0/1 to disable/enable runtime display
  model.run_simulation()
  
  % Reset the simulation and run simulation with different cell junction constant without noise.
  model.reset_system()
  model.change_tension_constant(0.2)
  model.change_direction_noise(0)
  model.run_simulation() 
```

## API Documentation

### One_Dim_Position_Feedback_System

### Batch Metrics

### Metric Comparison
