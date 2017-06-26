CELL_NUMBER = 5;
CELL_TENSION_CONSTANT = 1 ; %tension constant in N/m^2
INITIAL_CELL_EXTENSION = 10; % extension in m
FRICTION_FORCE_CONSTANT = 20; 
TOTAL_TIME = 5; 
DELTA_TIME = 1; 

% Current and initial Cell Tension extension: Lc, Li
% index 1 is Cell to the furthest left through to CELL_NUMBER
% who is the furtherest right. Each cell has its own extension to its left
% i.e -o-o-o-o where o is a cell and - is a extension has each extension to
% the left of the cell
Current_Cell_Extension = zeros(CELL_NUMBER, 1);
Initial_Cell_Extension = zeros(CELL_NUMBER, 1);

% Use of a current and new cell position so every Euler increment can be
% done from the current positions (i.e. current spring extensions) 
Current_Cell_Position = zeros(CELL_NUMBER,1); 
New_Cell_Position = zeros(CELL_NUMBER,1); 

% Cell Tension, k for F= -k(Lc - Li) for each Cell
Cell_Tension_Constants = zeros(CELL_NUMBER,1); 

% Forces created at each Cell. 
% Current Model only has force from the leading Cell
Cell_Force = zeros(CELL_NUMBER, 1); 
Cell_Force(CELL_NUMBER) = FRICTION_FORCE_CONSTANT; 

% Initialise all Lc, Li as equal and Cell Tension Constants as specified
for i= 1:CELL_NUMBER
    Current_Cell_Extension(i) = INITIAL_CELL_EXTENSION; 
    Initial_Cell_Extension(i) = INITIAL_CELL_EXTENSION;
    Cell_Tension_Constants(i) = CELL_TENSION_CONSTANT; 
    if i== 1
        Current_Cell_Position(i) = INITIAL_CELL_EXTENSION; 
    else
        Current_Cell_Position(i) = Current_Cell_Position(i-1)... 
                                    + INITIAL_CELL_EXTENSION; 
    end 
end


% Euler Method to increment over time to
for time = 1:DELTA_TIME: TOTAL_TIME
    % Change position of furtherest right Cell
    left_junction_extension = Current_Cell_Position(CELL_NUMBER)...
                        - Current_Cell_Position(CELL_NUMBER-1);
    left_spring_force = Cell_Tension_Constants(CELL_NUMBER) * left_junction_extension;
    
    %Force from cell and cell tensions
    Net_force = Cell_Force(CELL_NUMBER) - left_spring_force;
    
    %Displacement from Frictional forces: dx/dt = F
    % dx = F * dt
    dx = Net_force * DELTA_TIME; 
    New_Cell_Position(CELL_NUMBER)=Current_Cell_Position(CELL_NUMBER)+ dx;
    
    % Change position of the furtherest left cell
    left_junction_extension = Current_Cell_Position(1);
    left_spring_force = Cell_Tension_Constants(1) * left_junction_extension;

    right_junction_extension = Current_Cell_Position(2)...
                             - Current_Cell_Position(1);
    right_spring_force = Cell_Tension_Constants(2) * right_junction_extension; 

    %Force from cell and cell tensions
    Net_force = Cell_Force(1) + right_spring_force- left_spring_force; 

    %Displacement from Frictional forces: dx/dt = F
    % dx = F * dt
    dx = Net_force * DELTA_TIME;
    New_Cell_Position(1)=Current_Cell_Position(1)+ dx;
   
    % -o-o-o-o-o
    for i= 2:CELL_NUMBER -1
        left_junction_extension = Current_Cell_Position(i)...
                                 - Current_Cell_Position(i-1);
        left_spring_force = Cell_Tension_Constants(i) * left_junction_extension; 
        
        right_junction_extension = Current_Cell_Position(i+1)...
                                 - Current_Cell_Position(i);
        right_spring_force = Cell_Tension_Constants(i+1) * right_junction_extension; 
        
        %Force from cell and cell tensions
        Net_force = Cell_Force(i) + right_spring_force- left_spring_force; 

        %Displacement from Frictional forces: dx/dt = F
        % dx = F * dt
        dx = Net_force * DELTA_TIME; 
        New_Cell_Position(i)=Current_Cell_Position(i)+ dx;  
    end 
    Current_Cell_Position = New_Cell_Position
end