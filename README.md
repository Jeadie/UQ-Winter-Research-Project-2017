# UQ-Winter-Research-Project-2017
Mathematical modelling of rho signalling at cell-cell junctions during collective cell  migration

This repository includes all files and scripts created during my research period with the School and Mathematics and Physics during the winter break. 

The src directory has the following subdirectories: Batch_Metrics, Metric_Comparison, Models, Unused_Scripts. 

**Models**: contains all the classes in the hierachy to develop the final model: One_Dim_Position_Feedback_System. Class interface contains the relevant application logic to run simulations, gather and plot relevant simulation metrics and results. 

**Batch_Metrics**: contains methods to batch simulation a specific class object (generally One_Dim_Position_Feedback_System) through a number of iterations and return a plot for the specified metric. 

**Metric_Comparison**: contains methods to compare identical class objects with different cell junction constants batched with Batch_Metrics functions. 

**Unused_Scripts**: A variety of scripts used in the development of the final model and metrics. 

## Tutorial
After Downloading, run `setup.m` script in the outermost directory.  

Some Basic simulation usages: 
```matlab
  % Create a Feedback Model with 10 cells, with a time of 15 and 0.1 increments
  model = One_Dim_Position_Feedback_System(10, 15, 0.1)
  
  % Run simulation without runtime display
  model.change_graph_mode(0) % 0/1 to disable/enable runtime display
  model.run_simulation()
  
  % Reset the simulation and run simulation with different cell junction constant without noise.
  model.reset_system()
  model.change_tension_constant(0.2)
  model.change_noise(0)
  model.run_simulation() 
```

The runtime display: 
![alt text](https://github.com/Jeadie/UQ-Winter-Research-Project-2017/blob/master/Readme_Photos/runtime_example.jpg "Runtime Display")

Running Metrics: 
```matlab
  % Get Persistence data for simulation 
  model = One_Dim_Position_Feedback_System(10, 15, 0.1)
  batch_persistence_data(model, 40 )
```
![alt text](https://github.com/Jeadie/UQ-Winter-Research-Project-2017/master/Readme_Photos/persistence_batch.jpg "Batch Result")

```matlab
  % Compare cosine direction Data for tensions constants 1,2,3 run over 40 iterations. 
  model.reset_system()
  compare_cosine_direction_data(model, [1,2,3], 40, 10)  
```
![alt text](https://github.com/Jeadie/UQ-Winter-Research-Project-2017/master/Readme_Photos/batch_example.jpg "Comparison Result")



## API Documentation
Documentation for relevant models and metrics. Parameters will be by object type than name. i.e. test_obj is of type One_Dim_Base_System or its subclasses. 

```
  function compare_persistence_data(One_Dim_Base_System test_obj, Array default_tension_constant_array, Int iterations)
```

### One_Dim_Position_Feedback_System

Constructor
` function obj = One_Dim_Position_Feedback_System(Int no_of_cells, Int duration, Double time_steps)`

Run model simulation
`function run_simulation(One_Dim_Base_System obj)`

Reset the simulation and its data
`function reset_system(One_Dim_Base_System obj)`

Change the Cell Junction constant for the system. Default is 2.
`function change_tension_constant(One_Dim_Base_System obj, Double constant)`

Change whether the runtime graphics will display during simulation
`function change_graph_mode(One_Dim_Base_System obj, Int mode)`

Changes the amount of noise in the angular/directional data. Default is 10. 
`function change_noise(One_Dim_Vary_Force_System obj, Double noise)`

Returns the simulation position time data. In the form of a matrix of size [cell_number , duration/timesteps] 
`function model_data = get_simulation_data(One_Dim_Base_System obj, Int no_of_cells)`

Return the persistence data from the simulation. In the form of [1, duration/timesteps] size matrix
`function persistence = get_persistence_data(One_Dim_Base_System obj)`

Return the density of the cells against time. In the form of a matrix of size [cell_number-1 , duration/timesteps] 
`function density_data = get_density_data(One_Dim_Base_System obj, Int no_of_cells)`

Returns the direction/angle data for the fartherest right number of cells. In the form of a matrix of size [no_of_cells-1 , duration/timesteps]
`function dirn_data = get_dirn_data(One_Dim_Vary_Force_System obj, Int no_of_cells)`

Plots the persistence data of the obj
`function plot_persistence_data(One_Dim_Base_System obj)`

Plots the density data for the fartherest no_of_cells cells
`function plot_density_data(One_Dim_Base_System obj, Int no_of_cells)`

Plots an angular histogram of the directional/angular data of the fartherest number of cells. Angle data subdivided into bins number of subgroups.  
`function plot_dirn_histogram(One_Dim_Vary_Force_System obj, Int no_of_cells, Int bins)`

Plots the directional/angular data of the fartherest number of cells.
`function plot_dirn_plot(One_Dim_Vary_Force_System obj, Int no_of_cells)`

### Batch Metrics

### Metric Comparison
