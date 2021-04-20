classdef DobotMagician < handle
properties
    model;
    qlimReal = deg2rad([-135 135; -5 85; -10 95; -90 90; -90 90]);
    qn = [0 pi/6 pi/3 0 0];
    qz = [0 0 0 0 0];
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
    L(1) = Link('d',0.138,'a',0,'alpha',-pi/2,'offset',0,'qlim', [-pi/2,pi/2]);
    L(2) = Link('d',0,'a',0.135,'alpha',0,'offset',-pi/2,'qlim', [0,deg2rad(85)]);
    L(3) = Link('d',0,'a',0.147,'alpha',0,'offset',0,'qlim', deg2rad([-15,170]));
    L(4) = Link('d',0,'a',0.041,'alpha',pi/2,'offset',-pi/2,'qlim', [-pi/2,pi/2]);
    L(5) = Link('d',-0.05,'a',0,'alpha',0,'offset',0,'qlim', deg2rad([-85,85]));
    
    self.model = SerialLink(L,'name',name);
end

function Plot(self, q)
    % create the model
    q = self.qRealToModel(q);
    self.model.plot(q,'scale',0.7); 
end

function Animate(self, q)
    q = self.qRealToModel(q);
    self.model.animate(q);
end

function T = Fkine(self, q)
    q = self.qRealToModel(q);
    T = self.model.fkine(q);
end

end

methods(Static)
function qModel = qRealToModel(qReal)
    % real robot specifies q3 relative to q2
    % source: notes on dobot real vs model arm
    qModel = qReal;
    qModel(:,3) = pi/2 - qReal(:,2) + qReal(:,3);
    
    % l4 is always parallel to ground
    qModel(:,4) = pi/2 - qReal(:,3);
end

function qReal = qModelToReal(qModel)
    qReal = qModel;
    qReal(:,3) = qModel(:,3) - pi/2 + qModel(:,2);
end

end
end