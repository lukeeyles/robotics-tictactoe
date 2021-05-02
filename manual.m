function manual ()
manual_mode = 1
robot = DobotMagician();

eePose = transl(0 , 0, 0.05);
% Input from GUI, 1 = forwards/up -1 = backwards/down
movex = 0;
movey = 0;
movez = 0;
startpos = transl(0.1, 0.1, 0.1);
qstart = robot.Ikine(startpos);
robot.Plot(qstart);


while (manual_mode == 1);
currentpos = robot.GetPos();
oldpos = robot.Fkine(currentpos)


steps = 100;

if movex > 0 % Move forward in x
    newpos = oldpos*transl(0.1, 0, 0);
    q1= robot.Ikine(oldpos);
    q2 = robot.Ikine(newpos);
    qMatrix = jtraj(q1,q2, steps);
    robot.Plot(qMatrix);

end

if movex < 0 % Move Backward in x
    newpos = oldpos*transl(-0.1, 0, 0);
    q1= robot.Ikine(oldpos);
    q2 = robot.Ikine(newpos);
    qMatrix = jtraj(q1,q2, steps);
    robot.Plot(qMatrix);

end


if movey > 0 %move forward in Y
    newpos = oldpos*transl(0, 0.1, 0);
    q1= robot.Ikine(oldpos);
    q2 = robot.Ikine(newpos);
    qMatrix = jtraj(q1,q2, steps);
    robot.Plot(qMatrix);

end

if movey < 0 % Move backward in y
    newpos = oldpos*transl(0, -0.1, 0);
    q1= robot.Ikine(oldpos);
    q2 = robot.Ikine(newpos);
    qMatrix = jtraj(q1,q2, steps);
    robot.Plot(qMatrix);

end
   
if movez > 0 %move up
    newpos = oldpos*transl(0, 0, 0.1);
    q1= robot.Ikine(oldpos);
    q2 = robot.Ikine(newpos);
    qMatrix = jtraj(q1,q2, steps);
    robot.Plot(qMatrix);

end

if movez < 0 %move down
    newpos = oldpos*transl(0, 0, -0.1);
    q1= robot.Ikine(oldpos);
    q2 = robot.Ikine(newpos);
    qMatrix = jtraj(q1,q2, steps);
    robot.Plot(qMatrix);

end

end


end