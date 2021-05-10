classdef DobotMagician < handle
properties
    model;
    workspace = [-1 1 -1 1 -0.1 1];
    qlimReal = deg2rad([-135 135; -5 85; -10 95; -90 90]);
    qn = [0 pi/6 pi/3 0];
    qz = [0 0 0 0];
    
    % Subscribers
    jointStateSub;
    endEffectorStateSub;
    ioStatusSub;
    railPosSub;

    % Publisher
    targetJointTrajPub;
    targetJointTrajMsg;
    targetEndEffectorPub;
    targetEndEffectorMsg;
    toolStatePub;
    toolStateMsg;
    safetyStatePub;
    safetyStateMsg;
    railStatusPub;
    railStatusMsg;
    railPosPub;
    railPosMsg;
    ioDataPub;
    ioDataMsg;
    eMotorPub;
    eMotorMsg;
end

methods
function self = DobotMagician(realrobot)
    if nargin < 1
        realrobot = false;
    end
    % define dh parameters
    self.CreateRobot();
    
    if realrobot
        
    end
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
    self.model.base = transl(0,0,-0.138); % same coordinate system as manual
end

function Plot(self, q)
%     % load ply files
%     for linkIndex = 1:self.model.n
%         [faceData, vertexData, plyData{linkIndex}] = plyread(['Dob',num2str(linkIndex),'.ply'],'tri');
%         self.model.faces{linkIndex} = faceData;
%         self.model.points{linkIndex} = vertexData;
%     end
%     [faceData, vertexData, plyData{self.model.n+1}] = plyread(['Dob5.ply'],'tri');
%     self.model.faces{self.model.n+1} = faceData;
%     self.model.points{self.model.n+1} = vertexData;
    
    % display robot
    q = self.qRealToModel(q);
    self.model.plot(q);
%     self.model.plot3d(q,'workspace',self.workspace);
%     if isempty(findobj(get(gca,'Children'),'Type','Light'))
%         camlight
%     end
%     self.model.delay = 0;
        
%     % try to load colours
%     for linkIndex = 1:self.model.n
%         handles = findobj('Tag', self.model.name);
%         h = get(handles,'UserData');
%         try 
%             h.link(linkIndex).Children.FaceVertexCData = [plyData{linkIndex}.vertex.red ...
%                                                           , plyData{linkIndex}.vertex.green ...
%                                                           , plyData{linkIndex}.vertex.blue]/255;
%             h.link(linkIndex).Children.FaceColor = 'interp';
%         catch ME_1
%             disp(ME_1);
%             continue;
%         end
%     end
end

function Animate(self, q)
    for i = 1:size(q,1)
        qmodel = self.qRealToModel(q(i,:));
        self.model.animate(qmodel);
    end
end

function T = Fkine(self, q)
    q = self.qRealToModel(q);
    T = self.model.fkine(q);
end

function qReal = GetPos(self)
    qModel = self.model.getpos();
    qReal = self.qModelToReal(qModel);
end

function InitialiseROS(self)
    % Initialise subs and pubs as object starts

    self.jointStateSub = rossubscriber('/dobot_magician/joint_states');
    self.endEffectorStateSub = rossubscriber('/dobot_magician/end_effector_poses');

    self.ioStatusSub = rossubscriber('/dobot_magician/io_data');

    % Publisher for joint traj traj control (WIP) For now it can
    % only receive one configuration
    [self.targetJointTrajPub,self.targetJointTrajMsg] = rospublisher('/dobot_magician/target_joint_states');

    % Publisher for end effector control (WIP) For now it can only
    % receive one target pose
    [self.targetEndEffectorPub,self.targetEndEffectorMsg] = rospublisher('/dobot_magician/target_end_effector_pose');

    [self.toolStatePub, self.toolStateMsg] = rospublisher('/dobot_magician/target_tool_state');
    [self.safetyStatePub,self.safetyStateMsg] = rospublisher('/dobot_magician/target_safety_status');

    [self.railStatusPub, self.railStatusMsg] = rospublisher('/dobot_magician/target_rail_status');
    [self.railPosPub,self.railPosMsg] = rospublisher('/dobot_magician/target_rail_position');

    [self.ioDataPub,self.ioDataMsg] = rospublisher('/dobot_magician/target_io_state');

    [self.eMotorPub,self.eMotorMsg] = rospublisher('/dobot_magician/target_e_motor_state');
end

end

methods(Static)
function qModel = qRealToModel(qReal)
    % real robot specifies q3 relative to q2
    % source: notes on dobot real vs model arm
    qModel = [qReal(1:2),0,0,qReal(4)];
    qModel(:,3) = pi/2 - qReal(:,2) + qReal(:,3);
    
    % l4 is always parallel to ground
    qModel(:,4) = pi/2 - qReal(:,3);
end

function qReal = qModelToReal(qModel)
    qReal = qModel([1:3 5]);
    qReal(:,3) = qModel(:,3) - pi/2 + qModel(:,2);
end

end
end