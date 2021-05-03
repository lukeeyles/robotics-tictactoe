function manual (self, v)
manual_mode = 1 % turn on manual movement
robot = DobotMagician();



startpos = transl(0.1, 0.1, 0.1);
qstart = robot.Ikine(startpos);
robot.Plot(qstart);


while (manual_mode == 1);
currentpos = robot.GetPos();
oldpos = robot.Fkine(currentpos)


steps = 100;

    newpos = oldpos*transl(v);
    q1= robot.Ikine(oldpos);
    q2 = robot.Ikine(newpos);
    qMatrix = jtraj(q1,q2, steps);
    robot.Plot(qMatrix);





end


end