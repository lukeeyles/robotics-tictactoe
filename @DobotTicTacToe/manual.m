function manual (self, v, gain, steps)
manual_mode = 1; % turn on manual movement
robot = self.dobot;

%startpos = transl(0.1, 0.1, 0.1);
%qstart = robot.Ikine(startpos);
%robot.Plot(qstart);

% find current joint positions
oldq = robot.GetPos();
oldpos = robot.Fkine(oldq);

% translate proportional to velocity given
newpos = oldpos*transl(gain*v);
q2 = robot.Ikine(newpos);
qMatrix = jtraj(oldq,q2, steps);
robot.Animate(qMatrix);
end