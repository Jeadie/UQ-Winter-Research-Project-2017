classdef BasicSpring<handle

    properties
        spring_constant
        rest
        current
    end
    
    methods
        function obj = BasicSpring(spring_constant, rest, current)
            obj.spring_constant = spring_constant;
            obj.rest = rest;
            obj.current = current;
        end
        
        function addcurrent(obj, dx)
            obj.current = obj.current + dx;
        end
        
        function reset(obj, times)
            obj.addcurrent(times);
            obj.rest = 1000 * times; 
            obj.spring_constant = 1
        end
        
    end
    
end
