clear;
clc;
close all;
rosshutdown;
%% Start Dobot Magician Node
rosinit('172.19.137.18',11311,'NodeHost','172.19.114.211');

%% Start Dobot ROS
r = DobotMagician(true);
r.InitaliseRobot();

%%
centredistance = 0.155/2;
tableheight = -0.123;
tileloc = cat(3,transl(0.08+centredistance,-0.08,tableheight),...
    transl(0.12+centredistance,-0.08,tableheight),transl(0.16+centredistance,-0.08,tableheight),...
    transl(0.08+centredistance,0.08,tableheight),transl(0.12+centredistance,0.08,tableheight));
for i = 1:size(tileloc,3)
    q1(i,:) = r.Ikine(tileloc(:,:,i)); 
    q2(i,:) = r.Ikine(transl(0,0,0.01)*tileloc(:,:,i));
end

for i = 1:size(q1,1)
    r.PublishTargetJoint(q2(i,:));
    pause();
    r.PublishTargetJoint(q1(i,:));
    pause(1);
    r.PublishToolState(1);
    r.PublishTargetJoint(q2(i,:));
    pause(1);
    r.PublishToolState(0);
    r.PublishTargetJoint(r.qn);
    pause(1);
end