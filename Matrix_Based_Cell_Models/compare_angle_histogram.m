function compare_angle_histogram(test_obj, default_tension_constant_array, iterations, bins, histograms)

    objs = create_test_objs(test_obj, default_tension_constant_array);

    plots = numel(default_tension_constant_array);
    for i = 1:plots
        batch_angle_histogram( objs(i), iterations, [1,histograms], bins, i-1)
    end 

end

