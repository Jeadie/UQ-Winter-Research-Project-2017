function compare_persistence_data(obj, default_tension_constant_array, iterations)
%{
    Persistence Comparison Script

    Plots persistence data for default_tension_constant values for a given 
    system defined by obj. 

    Obj must be of object type One_Dim_Base_System or a subclass
%}

test_obj = create_test_objs(obj, default_tension_constant_array); 
plots = numel(default_tension_constant_array)
for i = 1:plots
    subplot(plots, 1, i)
    batch_persistence_data(test_obj(i), iterations)
end 

