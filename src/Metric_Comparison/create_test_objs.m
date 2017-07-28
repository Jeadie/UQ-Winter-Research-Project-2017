function test_obj = create_test_objs(base_obj, cell_tension_constant_array )
%{
    Private function to create an array of test objs for a comparison
    metric.
%}
    size = numel(cell_tension_constant_array);
    
    % Instantiate array with base_obj. Only final cell will have base_obj
    % attributes. Change Cell tension as specified in the array. 
    output_arr(1,size) = base_obj;
    output_arr(size).Cell_Tension_Constant = cell_tension_constant_array(size);

    %Iterate through all except the last obj and change their attributes to
    %that of the base_obj with a Cell_Tension_Constant from the array. 
    for i = 1:(max(size -1, 1))
        output_arr(i) = base_obj.copy();
        output_arr(i).Cell_Tension_Constant = cell_tension_constant_array(i);
    end    
    test_obj = output_arr;
end

