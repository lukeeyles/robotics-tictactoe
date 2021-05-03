classdef DobotTicTacToe < handle
% class to control dobot to play tic tac toe with a human
properties
    game = TicTacToe();
    dobot = DobotMagician();
    cam; % webcam
end

methods
function self = DobotTicTacToe()
    try
    self.cam = webcam(2);
    catch e
    end
end

function board = SenseBoardState(self)
    % look at which colour occupies which board tile
    
    % return board state
end

function obstruction = SenseObstruction(self,referenceimage)
    % compare reference image and current webcam output
    
    % if sum is significantly different, there is an obstruction
end

function move = FindPlayerMove(self)
    newboard = SenseBoardState(self);
    
    % compare new board and stored board
    
end

function image = TakeImage(self)
    % take image from webcam
    image = snapshot(self.cam);
end

end
end

