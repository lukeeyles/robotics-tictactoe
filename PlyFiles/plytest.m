function plytest()

%% Place Objects in Environment
% Testing the look of ply files in Matlab simulation
% at first just with placeobject
hold on
% Placing Board
PlaceObject('boardv2.ply', [0, 0, 0]);

% Placing Red tiles example start positions
PlaceObject('Rtile.ply',[1,-1.1,0]);
PlaceObject('Rtile.ply',[-1,-1.1,0]);
PlaceObject('Rtile.ply',[2,0,0]);
PlaceObject('Rtile.ply',[2,1.8,0]);

% Placing Blue tiles example start positions
PlaceObject('Btile.ply',[1,-1.1,1]);
PlaceObject('Btile.ply',[-1,-1.1,1]);
PlaceObject('Btile.ply',[2,2,2]);
PlaceObject('Btile.ply',[2,1.8,2]);

% Placing Books

% Placing Tables

% Placing hand


%% Place the robot and its model
% name = ['Dobot-',datestr(now,'yyyymmddTHHMMSSFFF')];
% 
%     % define links
%     L(1) = Link('d',0.138,'a',0,'alpha',-pi/2,'offset',0,'qlim', [-pi/2,pi/2]);
%     L(2) = Link('d',0,'a',0.135,'alpha',0,'offset',-pi/2,'qlim', [0,deg2rad(85)]);
%     L(3) = Link('d',0,'a',0.147,'alpha',0,'offset',0,'qlim', deg2rad([-15,170]));
%     L(4) = Link('d',0,'a',0.041,'alpha',pi/2,'offset',-pi/2,'qlim', [-pi/2,pi/2]);
%     L(5) = Link('d',-0.05,'a',0,'alpha',0,'offset',0,'qlim', deg2rad([-85,85]));
%     
%     r = SerialLink(L,'name',name);
% 
% qn = [0 0 0 0 0];
% qz = [0 pi/6 pi/3 0 0];
% r.plot(qz);
% r.teach;



