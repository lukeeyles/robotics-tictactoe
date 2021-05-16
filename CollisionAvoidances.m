%Collision Avoidance function

function [qWaypoints] = CollisionAvoidances(q1,q2,dobot,faces,vertex,faceNormals)

q = zeros(1,5);
q2(1,5) = 0;
qWaypoints = [q1;q2];

% Collision Checking
% Get the transform of every joint
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
 
result = true(steps,1);
for i = 1: steps
    result(i) = IsCollision(dobot,qMatrix(i,:),faces,vertex,faceNormals,false);
end


%Avoidance
if IsCollision(dobot,qMatrix,faces,vertex,faceNormals)
    display('Start Avoidance');
%     qWaypoints = [q1; dobot.Ikine(transl(0.03+cx,cy-0.03,0.07+cz)),0 ;...
%                 dobot.Ikine(transl(0.03+cx,cy+0.03,0.07+cz)),0; q2];
    qWaypoints = [q1; dobot.Ikine(transl(0.23, 0.06,0.07)),0 ;...
                dobot.Ikine(transl(0.23,0.12,0.07)),0; q2];
            
    qMatrix = InterpolateWaypointRadians(qWaypoints,deg2rad(5));

    if IsCollision(dobot,qMatrix,faces,vertex,faceNormals)
    error('Collision detected!!');
    else
    display('No collision met');
    qWaypoints;
    return
    end  
    
else
    display('No collision found');
    qWaypoints;
    return
    
end



end