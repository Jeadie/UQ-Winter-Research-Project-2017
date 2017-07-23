function compare_density_data( test_obj, default_tension_constant_array, iterations, no_of_cells )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

objs = create_test_objs(test_obj, default_tension_constant_array);

plots = numel(default_tension_constant_array);
for i = 1:plots
    subplot(plots, 1, i)
    batch_density_data(objs(i), iterations, no_of_cells)
end 
