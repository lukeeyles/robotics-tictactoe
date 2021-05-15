function PlayGame(self,difficulty)
self.game.Reset();
try
    close(1);
end
figure(1);
if self.realrobot
    self.dobot.InitaliseRobot();
    pause();
end
self.cammodel.plot_camera();
hold on;

qDefault = [0 0.4363 1.2770 0];
self.dobot.Plot(qDefault);

if self.realrobot
    self.dobot.PublishTargetJoint(qDefault)
end

% % use webcam to sense board + tile positions
% [boardloc,tileloc] = SenseBoardandTiles();

% hardcode start locations of board and tiles
tileloc = cat(3,transl(0.08+self.centredistance,-0.08,self.tableheight),...
    transl(0.12+self.centredistance,-0.08,self.tableheight),transl(0.16+self.centredistance,-0.08,self.tableheight),...
    transl(0.08+self.centredistance,0.08,self.tableheight),transl(0.12+self.centredistance,0.08,self.tableheight));

% define pickup transform to pick up tiles
pickupT = transl(0,0,0);

% robot is player 2, human is player 1
tilei = 1;
h = PlotTiles(tileloc);
player = randi(2);
%player = 2;
while self.game.CheckWin < 0
    player = TicTacToe.InvertPlayer(player);
    fprintf("Player %d turn\n", player);
    
    if player == 1 % human
        if self.realcamera
            reference = snapshot(self.cam);
            disp("Waiting for player to move");
            current = snapshot(self.cam);
            newboard = self.SenseBoardState();
            while ~self.CheckValidMove(newboard,player)...
                    || self.SenseObstruction(current, reference, 0.05)
                % wait for a valid move to be made
                % wait for any obstructions to clear
                pause(1);
                newboard = self.SenseBoardState();
                current = snapshot(self.cam);
            end
            disp("Player has moved");

            % get player move
            move = self.FindPlayerMove(newboard);
        else
            % get move through keyboard input
            move = self.game.GetPlayerMove();
        end
        
        % find physical location of move to plot
        moveloc = self.boardsquares(:,:,move(1),move(2));
        plotply('Btile.ply',moveloc);
        
    else % robot
        % calculate robot move
        move = self.game.CalculateMove(2,difficulty);
 
        % find location of move
        moveloc = self.boardsquares(:,:,move(1),move(2));
        
        % find poses to pick up and place down tile
        steps = 20;
        Q(1,:) = qDefault; % start at qn
        qabovepickup = self.dobot.Ikine(transl(0,0,0.015)*tileloc(:,:,tilei)*pickupT); % above tile
        [Q(2,:),error1] = self.dobot.Ikine(tileloc(:,:,tilei)*pickupT); % go to tile
        % above again
        Q(3,:) = self.dobot.qn; % move back to qn
        qabovedropoff = self.dobot.Ikine(transl(0,0,0.01)*moveloc*pickupT); % above dropoff
        [Q(4,:),error2] = self.dobot.Ikine(moveloc*pickupT); % place down tile
         % above dropoff
        error2
        Q(5,:) = qDefault; % back to qn
        qtotile = jtraj(Q(1,:),Q(2,:),steps);
        qpickedup = [jtraj(Q(2,:),Q(3,:),steps);jtraj(Q(3,:),Q(4,:),steps)];
        qfromtile = jtraj(Q(4,:),Q(5,:),steps);
        
        % move real robot
        if self.realrobot
            t = 1;
            self.dobot.PublishTargetJoint(Q(1,:)); % qn
            pause(t);
            self.dobot.PublishTargetJoint(qabovepickup);
            pause(t);
            self.dobot.PublishTargetJoint(Q(2,:)); % at tile
            pause(t);
            self.dobot.PublishToolState(1); % suction on
            pause(0.5);
            self.dobot.PublishTargetJoint(qabovepickup); % lift up
            pause(t);
            self.dobot.PublishTargetJoint(Q(3,:)); % qn
            pause(t+0.5);
            self.dobot.PublishTargetJoint(qabovedropoff); % above place
            pause(t);
            self.dobot.PublishTargetJoint(Q(4,:)); % place down
            pause(t);
            self.dobot.PublishToolState(0);
            pause(0.5);
            self.dobot.PublishTargetJoint(qabovedropoff); % above place
            pause(t);
            self.dobot.PublishTargetJoint(Q(3,:));
            pause(t);
        end

        % animate robot
        self.dobot.Animate(qtotile);
        for i = 1:size(qpickedup,1)
            self.dobot.Animate(qpickedup(i,:));
            endeffector = self.dobot.Fkine(qpickedup(i,:));
            delete(h{tilei});
            h{tilei} = plotply('Rtile.ply',endeffector);
        end
        self.dobot.Animate(qfromtile);

        tilei = tilei + 1;
    end
    
    self.game.PlayMove(move(1),move(2),player); % set new board
    self.game.PrintBoard();
    
    if player == 2 && self.realrobot == false && self.realcamera == true
        disp("Waiting for human to place tile for robot");
        pause(); % wait for human to place tile in right postion...
    end
end

% game end
winner = self.game.CheckWin();
if winner == 1
    disp("You won!");
elseif winner == 2
    disp("Robot won!");
else
    disp("Draw!");
end

end

function h = PlotTiles(tilelocs)
    for i = 1:size(tilelocs,3)
        h{i} = plotply('Rtile.ply',tilelocs(:,:,i));
    end
end