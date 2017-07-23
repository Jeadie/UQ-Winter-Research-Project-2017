function test_obj = create_test_objs(base_obj, cell_tension_constant_array )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    size = numel(cell_tension_constant_array);

    output_arr(1,size) = base_obj;

    for i = 1:(max(size -1, 1))
        output_arr(i) = base_obj.copy();
        output_arr(i).Cell_Tension_Constant = cell_tension_constant_array(i);
    end
    output_arr(size).Cell_Tension_Constant = cell_tension_constant_array(size);
    
    test_obj = output_arr;
end

