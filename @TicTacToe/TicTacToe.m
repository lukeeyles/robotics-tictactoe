classdef TicTacToe < handle
properties
    board = zeros(3);
end

methods
function Game(self, difficulty)
    Reset(self);

    player = randi(2);
    while CheckWin(self) < 0
        player = TicTacToe.InvertPlayer(player);
        fprintf("Player %d turn\n", player);
        if player == 1
            move = GetPlayerMove(self);
        elseif player == 2
            move = CalculateMove(self,player,difficulty);
        end
        PlayMove(self,move(1),move(2),player);
        PrintBoard();
    end
    
    if CheckWin(self) > 0
        fprintf("Player %d won!\n",player);
    else
        disp("Draw!");
    end
end

function win = CheckWin(self)
    win = -1;
    lines = GetLines(self);
    % check if any line is a win
    for i=1:size(lines,1)
        for player = 1:2
            if all(lines(i,:) == player)
                win = player;
            end
        end
    end
    
    % check for draw
    if ~any(self.board == 0)
        win = 0;
    end
end

function move = CalculateMove(self,player,difficulty)
    move = [0 0];
    otherplayer = TicTacToe.InvertPlayer(player);

    % difficulty = chance that robot will play strategically
    if (rand(1) < difficulty)
        % check if we can win in 1 move
        [lines,indices] = GetLines(self);
        for row = 1:size(lines,1)
            if sum(lines(row,:)==player) == 2 
                i = find(lines(row,:) == 0); % find an empty spot
                if ~isempty(i)
                    move = squeeze(indices(row,i,:));
                    return;
                end
            end
        end

        % else check if the other player will win, block
        for row = 1:size(lines,1)
            if sum(lines(row,:)==otherplayer) == 2 
                i = find(lines(row,:) == 0); % empty spot
                if ~isempty(i)
                    move = squeeze(indices(row,i,:));
                    return;
                end
            end
        end

        % else find line with our player
        for row = 1:size(lines,1)
            if any(lines(row,:)==player) && sum(lines(row,:)==0) == 2
                i = find(lines(row,:) == 0); % find an empty spot
                i = i(randi(numel(i))); % choose randomly
                if ~isempty(i)
                    move = squeeze(indices(row,i,:));
                    return;
                end
            end
        end

        % else find line with no others
        for row = 1:size(lines,1)
            if sum(lines(row,:)==0) == 3
                i = randi(3);
                move = squeeze(indices(row,i,:));
                return;
            end
        end
        
        % else find any empty space
        [row,col] = find(self.board == 0); % index of empty tile
        i = randi(size(row,1));
        move = [row(i),col(i)];
    else
        % play randomly
        [row,col] = find(self.board == 0); % index of empty tile
        i = randi(size(row,1));
        move = [row(i),col(i)];
    end
end

function PlayMove(self,row,col,player)
    self.board(row,col) = player;
end

function [lines,indices] = GetLines(self)
    diag1 = diag(self.board)';
    diag2 = diag(self.board(:,end:-1:1))';
    lines = [self.board; self.board'; diag1; diag2];
    indices = cat(3,[1 1 1; 2 2 2; 3 3 3; 1 2 3; 1 2 3; 1 2 3; 1 2 3; 1 2 3]...
        ,[1 2 3; 1 2 3; 1 2 3; 1 1 1; 2 2 2; 3 3 3; 1 2 3; 3 2 1]);
end

function move = GetPlayerMove(self)
    valid = false;
    while ~valid
        move(1) = input("Row? ");
        move(2) = input("Col? ");
        
        % check if move is valid
        if any(move > 3) || any(move < 1)
            disp("Out of range");
        elseif self.board(move(1),move(2)) ~= 0
            disp("Already occupied");
        else
            valid = true;
        end
    end
end

function Reset(self)
    self.board = zeros(3);
end

function PrintBoard(self)
    for row = 1:size(self.board,1)
        for col = 1:size(self.board,2)
            if self.board(row,col) == 1
                fprintf(" X ");
            elseif self.board(row,col) == 2
                fprintf(" O ");
            else
                fprintf("   ");
            end
            if col < size(self.board,2)
                fprintf("|");
            end
        end
        if row < size(self.board,1)
            fprintf("\n-----------\n");
        end
    end
end

end

methods(Static)
function player = InvertPlayer(player)
    if player == 1
        player = 2;
    else
        player = 1;
    end
end
end
end