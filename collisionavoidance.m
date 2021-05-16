%% collision avoidance
        
%Loading the dobot
dobot = DobotMagician;
q = zeros(1,5);

hold on

%Load tiles and board
tilesize = 0.045;
tableheight = -0.095; %was -0.12 but can't see cos of check mat
centredistance = 0.155/2;
plotply('boardv4.ply',transl([0.12+centredistance 0 tableheight]));
plotply('Rtile.ply',transl(0.08+centredistance,-0.08-tilesize,tableheight));
tile1 = transl(0.08+centredistance,-0.08-tilesize,tableheight);
plotply('Rtile.ply',transl(0.12+centredistance,-0.08-tilesize,tableheight));
tile2 = transl(0.12+centredistance,-0.08-tilesize,tableheight);
plotply('Rtile.ply',transl(0.16+centredistance,-0.08-tilesize,tableheight));
tile3 = transl(0.16+centredistance,-0.08-tilesize,tableheight);
plotply('Rtile.ply',transl(0.08+centredistance,0.08+tilesize,tableheight));
tile4 = transl(0.08+centredistance,0.08+tilesize,tableheight);
plotply('Rtile.ply',transl(0.12+centredistance,0.08+tilesize,tableheight));
tile5 = transl(0.12+centredistance,0.08+tilesize,tableheight);

% Give Path ie home position to a tile
q1 = [0 pi/6 pi/3 0 0];
dobot.Plot(q1);
% q2 = [ 0 0 0 0 ];
q2 = dobot.Ikine(tile5);
q2(1,5) = 0; %adding a zero so Indexing works

% q2 =[0.6709    0.6310    1.1471   -0.6709 0];
% r.Fkine(q2)
% qMatrix = jtraj(q1,q2,20);
% r.Animate(qMatrix);

%Load obstacle
%Cube
cx = 0.2;
cy = 0.09;
cz = -0.09;
centerpnt = [cx,cy,cz];
side = 0.02;
plotOptions.plotFaces = true;
[vertex,faces,faceNormals] = RectangularPrism(centerpnt-side/2, centerpnt+side/2,plotOptions);

%% Collision Checking
% Get the transform of every joint (i.e. start and end of every link)
tr = zeros(4,4,dobot.model.n+1);
tr(:,:,1) = dobot.model.base;
L = dobot.model.links;
for i = 1 : dobot.model.n
    tr(:,:,i+1) = tr(:,:,i) * trotz(q(i)+L(i).offset) * transl(0,0,L(i).d) * transl(L(i).a,0,0) * trotx(L(i).alpha);
end


%  Go through until there are no step sizes larger than 1 degree
steps = 2;
while ~isempty(find(1 < abs(diff(rad2deg(jtraj(q1,q2,steps)))),1))
    steps = steps + 1;
end
qMatrix = jtraj(q1,q2,steps);

% 
result = true(steps,1);
for i = 1: steps
    result(i) = IsCollision(dobot,qMatrix(i,:),faces,vertex,faceNormals,false);
%      dobot.Animate(qMatrix(i,:));
end
% if IsCollision(dobot,qMatrix,faces,vertex,faceNormals)
%     error('Collision detected!!');
% else
%     display('No collision found');
% end
% 

%% Collision Avoidance
% Manual Method
%Found waypoints not in collision along the path to 5th tile

qWaypoints = [q1; dobot.Ikine(transl(0.03+cx,cy-0.03,0.07+cz)),0 ;...
                dobot.Ikine(transl(0.03+cx,cy+0.03,0.07+cz)),0; q2];
            
qMatrix = InterpolateWaypointRadians(qWaypoints,deg2rad(5));

if IsCollision(dobot,qMatrix,faces,vertex,faceNormals)
    error('Collision detected!!');
else
    display('No collision met');
end
dobot.Animate(qMatrix);
