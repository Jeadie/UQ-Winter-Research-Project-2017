function compare_density_data( test_obj, default_tension_constant_array, iterations, no_of_cells )
%{ 
    Compares the density of the fartherest no_of_cells cells,
    over a number of iterations and cell junction constants. 
    Plots on separate subplots.
%}
objs = create_test_objs(test_obj, default_tension_constant_array);

plots = numel(default_tension_constant_array);

%Iterate through test_objs and plot the batch tested results on individual
%subplots. 
for i = 1:plots
    subplot(plots, 1, i)
    batch_density_data(objs(i), iterations, no_of_cells)
end 
