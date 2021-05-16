function newq = manual (self, v, oldq, gain)
manual_mode = 1; % turn on manual movement
robot = self.dobot;

% find current position
oldpos = robot.Fkine(oldq);

% translate proportional to velocity given
newpos = transl(gain*v)*oldpos;
newq = robot.Ikine(newpos);
robot.Animate(newq);
end