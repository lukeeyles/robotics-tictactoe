function plytest()

%% Place Objects in Environment
% Testing the look of ply files in Matlab simulation
% at first just with placeobject
hold on
axis equal
% Placing Board
plotply('boardv3.ply',transl(0, 0, 0.5));

% Placing Red tiles example start positions
plotply('Rtile.ply',transl(0.4,0.4,0.5));
% PlaceObject('Rtile.ply',[-1,-1.1,0.5]);
% PlaceObject('Rtile.ply',[2,0,0.5]);
% PlaceObject('Rtile.ply',[2,1.8,0.5]);
% 
% % Placing Blue tiles example start positions
plotply('Btile.ply',transl(-0.4,-0.4,0.5));
% PlaceObject('Btile.ply',[-1,-1.1,0.5]);
% PlaceObject('Btile.ply',[2,2,0.5]);
% PlaceObject('Btile.ply',[2,1.8,0.5]);

% Placing Books
plotply('books.ply',transl(0,0.9,0.5));
% Placing Tables
plotply('Table5.ply',transl(0,0,0));

% Placing hand
plotply('hand.ply',transl(0.9,0,0.5));

%% Place the robot and its model
% looking for waypoints w/ teach

name = ['Dobot-',datestr(now,'yyyymmddTHHMMSSFFF')];

    % define links
    L(1) = Link('d',0.138,'a',0,'alpha',-pi/2,'offset',0,'qlim', [-pi/2,pi/2]);
    L(2) = Link('d',0,'a',0.135,'alpha',0,'offset',-pi/2,'qlim', [0,deg2rad(85)]);
    L(3) = Link('d',0,'a',0.147,'alpha',0,'offset',0,'qlim', deg2rad([-15,170]));
    L(4) = Link('d',0,'a',0.061,'alpha',pi/2,'offset',-pi/2,'qlim', [-pi/2,pi/2]);
    L(5) = Link('d',-0.07,'a',0,'alpha',0,'offset',0,'qlim', deg2rad([-85,85]));
    
    r = SerialLink(L,'name',name);
r.base = transl(0,0,-0.138);
qn = [0 0 0 0 0];
qz = [0 pi/6 pi/3 0 0];
r.plot(qz);

centerpnt = [0.2,0.2,0]; %0.3,0.4,0
side = 0.2;
plotOptions.plotFaces = true;
[vertex,faces,faceNormals] = RectangularPrism(centerpnt-side/2, centerpnt+side/2,plotOptions);

q2 =[0.6709    0.6310    1.1471   -0.6709 0];

qMatrix = jtraj(qz,q2,20);
r.animate(qMatrix);
%r.teach;


%% 
r = DobotMagician;
qn = [0 0 0 0 0];
qz = [0 pi/6 pi/3 0 0]
r.Plot(qz);
% q2 = 

centerpnt = [0.2,0.2,0]; %0.3,0.4,0
side = 0.2;
plotOptions.plotFaces = true;
[vertex,faces,faceNormals] = RectangularPrism(centerpnt-side/2, centerpnt+side/2,plotOptions);


%%
q2 =[0.6709    0.6310    1.1471   -0.6709 0]
deg2rad([0.6709    0.6310    1.1471   -0.6709 0])


