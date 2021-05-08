function PlayGame(self,difficulty,tilesize)
self.game.Reset();

qDefault = [0 pi/6 pi/4 0 0];
self.dobot.Plot(qDefault);
hold on;
pause();

% % use webcam to sense board + tile positions
% [boardloc,tileloc] = SenseBoardandTiles();

% hardcode locations of board and tiles
boardloc = transl([0.2 0 0.05]);
tileloc = cat(3,transl(0.15,-0.1,0.05),transl(0.2,0.1,0.05),transl(0.25,0.1,0.05)...
        ,transl(0.2,-0.1,0.05),transl(0.25,-0.1,0.05));

% generate locations for all board squares
boardsquares = zeros(4,4,3,3);
for row = 1:3
    for col = 1:3
        boardsquares(:,:,row,col) = boardloc*transl([(row-2)*tilesize (col-2)*tilesize 0]);
    end
end

% define pickup transform to pick up tiles
%pickupT = trotz(pi/2);
pickupT = transl(0,0,0);

% robot is player 2, human is player 1
player2tilei = 1;
h = PlotTiles(tileloc);
player = randi(2);

while self.game.CheckWin < 0
    player = TicTacToe.InvertPlayer(player);
    fprintf("Player %d turn\n", player);
    
    if player == 1 % human
%         while (self.SenseBoardState() == self.game.board)
%             % wait for board state to change
%         end
%         
%         while self.SenseObstruction()
%             % wait for any obstructions to clear
%         end
%         
%         % get player move
%         move = self.FindPlayerMove();

        % get move through keyboard input
        move = self.game.GetPlayerMove();
        
        % find physical location of move to plot
        moveloc = boardsquares(:,:,move(1),move(2));
        plotply('Btile.ply',moveloc);
    else % robot
        % calculate robot move
        move = self.game.CalculateMove(2,difficulty);
 
        % find location of move
        moveloc = boardsquares(:,:,move(1),move(2));
        
        % find poses to pick up and place down tile
        Q(1,:) = qDefault; % start at qn
        [Q(2,:),error1] = self.dobot.Ikine(tileloc(:,:,player2tilei)*pickupT); % go to tile
        Q(3,:) = qDefault; % move back to qn
        [Q(4,:),error2] = self.dobot.Ikine(moveloc*pickupT); % place down tile
        Q(5,:) = qDefault; % back to qn
        qtotile = jtraj(Q(1,:),Q(2,:),20);
        qpickedup = [jtraj(Q(2,:),Q(3,:),20);jtraj(Q(3,:),Q(4,:),20)];
        qfromtile = jtraj(Q(4,:),Q(5,:),20);
        error1
        error2
        
        % move real robot...

        % animate robot
        self.dobot.Animate(qtotile);
        for i = 1:size(qpickedup,1)
            self.dobot.Animate(qpickedup(i,:));
            endeffector = self.dobot.Fkine(qpickedup(i,:));
            delete(h{player2tilei});
            h{player2tilei} = plotply('Rtile.ply',endeffector);
        end
        self.dobot.Animate(qfromtile);
%         delete(h{player2tilei});
%         h{player2tilei} = plotply('Rtile.ply',moveloc); % plot move
        player2tilei = player2tilei + 1;
    end
    
    self.game.PlayMove(move(1),move(2),player); % set new board
    self.game.PrintBoard();
end
end

function tilelocs = SenseTiles()
    tilelocs = cat(3,transl(0.2,-0.1,0),transl(0.2,0.1,0)...
        ,transl(0.1,-0.1,0),transl(0.1,0,0),transl(0.1,0.1,0));
end

function h = PlotTiles(tilelocs)
    for i = 1:size(tilelocs,3)
        h{i} = plotply('Rtile.ply',tilelocs(:,:,i));
    end
end