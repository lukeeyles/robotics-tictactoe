cx = 0.2;
cy = 0.09;
cz = -0.09;
centerpnt = [cx,cy,cz];
side = 0.1;
plotOptions.plotFaces = true;
[vertex,faces,faceNormals] = RectangularPrism(centerpnt-side/2, centerpnt+side/2,plotOptions);
r = DobotMagician;
hold on;
r.Plot(r.qn);

%% avoid collision
goal = transl(0,0.2,0);
q1 = r.qn;
q2 = r.Ikine(goal);
r.Animate(q1);
[qWaypoints] = CollisionAvoidances(q1,q2,r,faces,vertex,faceNormals);
path = [q1;qWaypoints];
for i = 2:size(path,1)
    qMatrix = jtraj(path(i-1,:),path(i,:),30);
    r.Animate(qMatrix);
end

%% can't avoid collision
goal = transl(0.2,0.1,-0.1);
q1 = r.qn;
q2 = r.Ikine(goal);
r.Animate(q1);
[qWaypoints] = CollisionAvoidances(q1,q2,r,faces,vertex,faceNormals);
path = [q1;qWaypoints];
for i = 2:size(path,1)
    qMatrix = jtraj(path(i-1,:),path(i,:),30);
    r.Animate(qMatrix);
end

%% no collision
goal = transl(0.2,-0.1,0);
q1 = r.qn;
q2 = r.Ikine(goal);
r.Animate(q1);
[qWaypoints] = CollisionAvoidances(q1,q2,r,faces,vertex,faceNormals);
path = [q1;qWaypoints];
for i = 2:size(path,1)
    qMatrix = jtraj(path(i-1,:),path(i,:),30);
    r.Animate(qMatrix);
end