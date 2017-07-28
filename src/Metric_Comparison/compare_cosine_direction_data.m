function compare_cosine_direction_data(  test_obj, default_tension_constant_array, iterations, no_of_cells)
%{
    Compare the cosine of the direction angles of the fartherest
    no_of_cells cells for test_objs of varying cell junction constants
    over a number of iterations.
 %}
    objs = create_test_objs(test_obj, default_tension_constant_array);

    plots = numel(default_tension_constant_array);

    % Iterate through all test_objs and plot the batch results on separate
    % subplots. 
    for i = 1:plots
        subplot(plots, 1, i)
        batch_cos_plot(objs(i), iterations, no_of_cells)
    end 
    
end