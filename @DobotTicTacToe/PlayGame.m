function PlayGame(self,difficulty,tilesize)
self.dobot.Plot(dobot.qn);

% use webcam to sense board + tile positions
[boardloc,tileloc] = SenseBoardandTiles();

% generate locations for all board squares
boardsquares = zeros(4,4,3,3);
for row = 1:3
    for col = 1:3
        boardsquares(:,:,row,col) = boardloc*transl([(col-2)*tilesize (row-2)*tilesize 0]);
    end
end

% define pickup transform to pick up tiles
pickupT = trotz(pi/2);

% robot is player 2, human is player 1
player2tilei = 1;
player2tilelocs = SenseTiles();
h = PlotTiles(player2tilelocs);
player = randi(2);

while self.game.CheckWin < 0
    player = TicTacToe.InvertPlayer(player);
    fprintf("Player %d turn\n", player);
    
    if player == 1 % human
        while (self.SenseBoardState() == self.game.board)
            % wait for board state to change
        end
        
        while self.SenseObstruction()
            % wait for any obstructions to clear
        end
        
        % get player move
        move = self.FindPlayerMove();
        
        % find physical location of move to plot
        moveloc = boardsquares(:,:,move(1),move(2));
        plot3(moveloc(1,4),moveloc(2,4),moveloc(3,4),'g*'); % plot move
    else % robot
        % calculate robot move
        move = self.game.CalculateMove(2,difficulty);
 
        % find location of move
        moveloc = boardsquares(:,:,move(1),move(2));
        
        % find poses to pick up and place down tile
        Q(1,:) = self.dobot.qn; % start at qn
        Q(2,:) = self.dobot.Ikine(player2tilelocs(:,:,player2tilei)*pickupT); % go to tile
        Q(3,:) = self.dobot.qn; % move back to qn
        Q(4,:) = self.dobot.Ikine(moveloc*pickupT); % place down tile
        Q(5,:) = self.dobot.qn; % back to qn
        
        % move real robot...

        % animate robot
        q = [];
        for i = 1:size(Q,1) - 1
            q = cat(1,q,jtraj(Q(i,:),Q(i+1,:),20));
        end
        for i = 1:size(q,1)
            dobot.Animate(q(i,:));
            endeffector = dobot.Fkine(q(i,:));
            h(player2tilei) = plot3(endeffector(1,4),endeffector(2,4),endeffector(3,4),'b*');
        end
        
        h(player2tilei) = plot3(moveloc(1,4),moveloc(2,4),moveloc(3,4),'b*'); % plot move
        player2tilei = player2tilei + 1;
    end
    
    game.PlayMove(move(1),move(2),player); % set new board
    game.PrintBoard();
end
end

function tilelocs = SenseTiles()
    tilelocs = cat(3,transl(0.2,-0.1,0),transl(0.2,0.1,0)...
        ,transl(0.1,-0.1,0),transl(0.1,0,0),transl(0.1,0.1,0));
end

function h = PlotTiles(tilelocs)
    for i = 1:size(tilelocs,3)
        h(i) = plot3(tilelocs(1,4,i),tilelocs(2,4,i),tilelocs(3,4,i),'r*');
    end
end