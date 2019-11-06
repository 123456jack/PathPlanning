% Main entry:

ObstList = [-25:25;15*ones(1,51)]';            % Obstacle point list
ObstList = [ObstList; [-10: 10; 0*ones(1,21)]'];
ObstList = [ObstList; [-25:-10; 5*ones(1,16)]'];
ObstList = [ObstList; [ 10: 25; 5*ones(1,16)]'];
ObstList = [ObstList; [ 10*ones(1,6);0:  5;]'];
ObstList = [ObstList; [-10*ones(1,6);0:  5;]'];
% Park lot line for collision check
ObstLine = [-25, 15 , 25, 15;
            -25,  5, -10,  5;
            -10,  5, -10,  0;
            -10,  0,  10,  0;
             10,  0,  10,  5;
             10,  5,  25,  5;
            -25,  5, -25, 15;
             25,  5,  25, 15];
% ObstList and ObstLine
ObstInfo.ObstList = ObstList;
ObstInfo.ObstLine = ObstLine;
% ObstInfo.ObstMap = GridAStar(ObstList,End,XY_GRID_RESOLUTION);

Vehicle.WB = 3.7;         % [m] wheel base: rear to front steer
Vehicle.W  = 2.6;         % [m] width of vehicle
Vehicle.LF = 4.5;         % [m] distance from rear to vehicle front end of vehicle
Vehicle.LB = 1.0;         % [m] distance from rear to vehicle back end of vehicle
Vehicle.MAX_STEER = 0.6;  % [rad] maximum steering angle 
Vehicle.MIN_CIRCLE = Vehicle.WB/tan(Vehicle.MAX_STEER); % [m] mininum steering circle radius

% Motion resolution define
Configure.MOTION_RESOLUTION = 0.1;             % [m] path interporate resolution
Configure.N_STEER = 20.0;                      % number of steer command
Configure.EXTEND_AREA = 0;                     % [m] map extend length
Configure.XY_GRID_RESOLUTION = 2.0;            % [m]
Configure.YAW_GRID_RESOLUTION = deg2rad(15.0); % [rad]
% Grid bound
Configure.MINX = min(ObstList(:,1))-Configure.EXTEND_AREA;
Configure.MAXX = max(ObstList(:,1))+Configure.EXTEND_AREA;
Configure.MINY = min(ObstList(:,2))-Configure.EXTEND_AREA;
Configure.MAXY = max(ObstList(:,2))+Configure.EXTEND_AREA;
Configure.MINYAW = -pi-0.01;
Configure.MAXYAW = pi;
% Cost related define
Configure.SB_COST = 0;             % switch back penalty cost
Configure.BACK_COST = 1.5;         % backward penalty cost
Configure.STEER_CHANGE_COST = 1.5; % steer angle change penalty cost
Configure.STEER_COST = 1.5;        % steer angle change penalty cost
Configure.H_COST = 10;             % Heuristic cost

StartState = [22, 13, pi  ];
EndState =   [7,   2, pi/2];
[x,y,th,~,~] = HybridAStar(StartState,EndState,Vehicle,Configure,ObstInfo);
if isempty(x)
    disp("Failed to find path!")
else
    hold on;
    VehicleAnimation(x,y,th,Configure,Vehicle,ObstInfo)
end