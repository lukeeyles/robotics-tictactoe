% Testing Movement of Arm
% With ply files

% Need Starting poses
% Are these sensed?
% creating variables, I don't know how to connect to sensing
% Dummy Data
blueTile1 = transl(0.05,0.15,0);

% Need Waypoints 
% these are poses to go to inbetween 
% as a safety thing to avoid books

% Finishing pose
% how do I know where to put?
% is this a sense thing? or a hard code thing?
botTurn1 = transl(-0.05,-0.15,0.03);


% Moving
% for each tile of the robot (not the persons) therefore only 4 tiles

% steps for interpolating
steps = 30;

dobot = DobotMagician;
qz = [0 pi/6 pi/3 0 0];

% % Go to Pickup Tile 1
% blueTile1               %print value of tile
% newQ = r.Ikine(blueTile1)     %ikine(startlocat,startpose,mask);
% %Plot the new robot pose (where brick is)
% r.Animate(newQ)
% newQ                    %print the value to check against fkine
% % checkQ = r.Fkine(newQ)
% % move arm to brick from home
% qMatrix = jtraj(qz,newQ,steps)
% r.Animate(qMatrix)
% 
% % Go to Place Tile 1
% botTurn1
% newQ1 = r.model.Ikine(botTurn1,newQ);
% % plot the new robot pose
% r.model.Animate(newQ1)
% newQ1
% % checkQ = r.model.Fkine(newQ1)
% %move arm from brickstart to wall position
% qMatrix = jtraj(newQ,newQ1,steps)
% r.model.Animate(qMatrix)

% New way
blueTile1
botTurn1
newQ = dobot.Ikine(blueTile1)
% dobot.Animate(newQ)
newQ1 = dobot.Ikine(botTurn1)
% dobot.Animate(newQ1)
qMatrix = jtraj(newQ,newQ1,steps)
% dobot.Animate(qMatrix)

dobot.Plot(newQ);
% for i = 1:steps
dobot.Animate(qMatrix);
% end

%% Add in waypoint
home = [0,0,0,0]
blueTile1
botTurn1
steps1 = 10;

newQ = dobot.Ikine(blueTile1)
%homeQ = dobot.Ikine(
newQ1 = dobot.Ikine(botTurn1)

qMatrix = jtraj(newQ,home,steps1)
dobot.Plot(newQ);
for i = 1:steps1
    dobot.Animate(qMatrix(i,:));
end

qMatrix1 = jtraj(home,newQ1,steps1)
dobot.Plot(home);
for i = 1:steps1
    dobot.Animate(qMatrix1(i,:));
end

%Checking with Fkine
  % compare blueTile1 with dobot.Fkine(newQ) - exact
  % compare botTurn1 with dobot.Fkine(newQ1) - very similar
  
%% 


%update tile position now on board
% will the tiles be robots like bricks or?

%example
%brick1.model.base = brick1Wall;
%brick1.model.plot3d(q,'workspace',brick1.workspaceDimensions);
