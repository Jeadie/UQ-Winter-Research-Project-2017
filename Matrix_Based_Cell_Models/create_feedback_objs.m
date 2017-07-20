function test_obj = create_feedback_objs( obj, default_tension_constant_array )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    size = numel(default_tension_constant_array);

    output_arr(1,size) = obj;

    for i = 1: numel(size -1)
        output_arr(i) = objs
        output_arr(i).default_tension_constant = default_tension_constant_array(i)
    end
    output_arr(size).default_tension_constant = default_tension_constant_array(size)
    
    test_obj = output_arr;
end

