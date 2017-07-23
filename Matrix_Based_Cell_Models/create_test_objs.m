function test_obj = create_test_objs(base_obj, default_tension_constant_array )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    size = numel(default_tension_constant_array);

    output_arr(1,size) = base_obj;

    for i = 1:(size -1)
        output_arr(i) = base_obj;
        output_arr(i).default_tension_constant = default_tension_constant_array(i);
    end
    output_arr(size).default_tension_constant = default_tension_constant_array(size);
    
    test_obj = output_arr;
end

