cx = 0.2;
cy = -0.09;
cz = -0.09;
centerpnt = [cx,cy,cz];
side = 0.1;
plotOptions.plotFaces = true;
[vertex,faces,faceNormals] = RectangularPrism(centerpnt-side/2, centerpnt+side/2,plotOptions);
r = DobotMagician;
hold on;
r.Plot(r.qn);

%% avoid collision
goal = transl(0,-0.2,0);
q1 = r.qn;
q2 = r.Ikine(goal);
[qWaypoints] = CollisionAvoidances(q1,q2,r,faces,vertex,faceNormals);
for i = 2:size(qWaypoints,1)
    path = jtraj(qWaypoints(i-1,:),qWaypoints(i,:),30);
    r.Animate(path);
end

%% can't avoid collision
goal = transl(0.2,-0.1,-0.1);
q1 = r.qn;
q2 = r.Ikine(goal)
[qWaypoints] = CollisionAvoidances(q1,q2,r,faces,vertex,faceNormals);
for i = 2:size(qWaypoints,1)
    path = jtraj(qWaypoints(i-1,:),qWaypoints(i,:),30);
    r.Animate(path);
end

%% no collision
goal = transl(0.2,0,-0.1);
q1 = r.qn;
q2 = r.Ikine(goal)
[qWaypoints] = CollisionAvoidances(q1,q2,r,faces,vertex,faceNormals);
for i = 2:size(qWaypoints,1)
    path = jtraj(qWaypoints(i-1,:),qWaypoints(i,:),30);
    r.Animate(path);
end