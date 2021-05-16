function winner = PlayGame(self,difficulty,resume)
winner = -1;
if ~exist('difficulty','var')
    difficulty = 1;
end
if ~exist('resume','var')
    resume = false; % assume we want to reset instead of resuming
end

qDefault = [0 0.4363 1.2770 0];
if ~resume
    self.Reset();
    %self.dobot.Animate(qDefault);
else
    %self.dobot.Animate(self.dobot.GetPos());
    self.player = TicTacToe.InvertPlayer(self.player); % double invert to resume with the same player
end

if self.realrobot
    self.dobot.InitaliseRobot();
    pause();
end

hold on;

if self.realrobot
    self.dobot.PublishTargetJoint(qDefault)
end

% define pickup transform to pick up tiles
pickupT = transl(0,0,0);

% robot is player 2, human is player 1
%h = PlotTiles(self.tileloc);
for i = 1:numel(self.rtiles)
    self.rtiles(i).Plot();
end

while self.game.CheckWin < 0
    self.player = TicTacToe.InvertPlayer(self.player);
    fprintf("Player %d turn\n", self.player);
    
    if self.player == 1 % human
        if self.realcamera
            reference = snapshot(self.cam);
            disp("Waiting for player to move");
            current = snapshot(self.cam);
            newboard = self.SenseBoardState();
            while ~self.CheckValidMove(newboard,self.player)...
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
            while isempty(self.move) || ~self.game.CheckValidMove(self.move)
                % wait for gui to send valid move
                pause(0.1);
            end
            move = self.move;
        end
        
        % find physical location of move to plot
        moveloc = self.boardsquares(:,:,move(1),move(2));
        self.btiles = [self.btiles,GameTile('Btile.ply',moveloc)];
        self.btiles(end).Plot();
        %plotply('Btile.ply',moveloc);
        self.move = [];
        
    else % robot
        % calculate robot move
        move = self.game.CalculateMove(2,difficulty);
 
        % find location of move
        moveloc = self.boardsquares(:,:,move(1),move(2));
        
        % find poses to pick up and place down tile
        steps = 20;
        Q(1,:) = self.dobot.GetPos();
        qabovepickup = self.dobot.Ikine(transl(0,0,0.015)*self.rtiles(self.tilei).T*pickupT); % above tile
        [Q(2,:),error1] = self.dobot.Ikine(self.rtiles(self.tilei).T*pickupT); % go to tile
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
        self.AnimateWithTile(qpickedup,self.tilei);
        self.dobot.Animate(qfromtile);
        if ~self.dobot.estop
            self.tilei = self.tilei + 1;
        end
    end
    
    if self.dobot.estop
        return;
    end
    
    self.game.PlayMove(move(1),move(2),self.player); % set new board
    self.game.PrintBoard();
    
    if self.player == 2 && self.realrobot == false && self.realcamera == true
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