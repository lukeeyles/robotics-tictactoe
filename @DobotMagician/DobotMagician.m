classdef DobotMagician < handle
properties
    model;
    qn = [0 0 0 0];
end

methods
function self = DobotMagician()
    % define dh parameters
    self.CreateRobot();
end

function CreateRobot(self)
    % create unique name
    name = ['Dobot-',datestr(now,'yyyymmddTHHMMSSFFF')];

    % define links
    L(1) = Link('d',0.1,'a',0,'alpha',pi/2,'offset',0,'qlim', [-pi/2,pi/2]); % estimate
    L(2) = Link('d',0,'a',0.135,'alpha',pi,'offset',pi/2,'qlim', [0,deg2rad(85)]);
    L(3) = Link('d',0,'a',-0.147,'alpha',0,'offset',pi/2,'qlim', deg2rad([-10,95]));
    L(4) = Link('d',0,'a',0.05,'alpha',0,'offset',pi/2,'qlim', [-pi/2,pi/2]); % estimate
    
    self.model = SerialLink(L,'name',name);
end

function Plot(self, q)
    self.model.plot(q);
end
end
end