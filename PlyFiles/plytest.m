function Environment()

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
