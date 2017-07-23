function compare_cosine_direction_data(  test_obj, default_tension_constant_array, iterations)

    objs = create_test_objs(test_obj, default_tension_constant_array);

    plots = numel(default_tension_constant_array);

    for i = 1:plots
        subplot(plots, 1, i)
        batch_cos_plot(objs(i), iterations)
    end 
    
end