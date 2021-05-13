classdef DobotTicTacToe < handle
% class to control dobot to play tic tac toe with a human
properties
    game = TicTacToe();
    dobot;
    cam; % webcam
    realrobot;
end

methods
function self = DobotTicTacToe(realrobot)
    if nargin < 1
        self.realrobot = false;
    else
        self.realrobot = realrobot;
    end
    self.dobot = DobotMagician(self.realrobot);
    
    try
    self.cam = webcam(2);
    catch e
    end
end

function board = SenseBoardState(self,boardpixels)
    % boardpixels are indices of pixels in centre of each square
    
    image = TakeImage(self);
    board = zeros(3);
    
    % look at which colour occupies which board tile
    for i = 1:size(boardpixels,1)
        section = image(boardpixels(i,1)-5:boardpixels(i,1)+5,...
            boardpixels(i,2)-5:boardpixels(i,2)+5,:); % get tile range
        % TODO get mean colour
        
        color = self.FindColor(impixel(image,boardpixels(i,1),boardpixels(i,2)));
        if strcmp(color,"blue")
            board(i) = 1;
        elseif strcmp(color,"red")
            board(i) = 2;
        end
    end
end

function obstruction = SenseObstruction(self,currentimage,referenceimage,error)
    % error = percentage of pixels different
    % compare reference image and current webcam output
    currentimage = self.ProcessImage(currentimage,100);
    currentpercent = sum(currentimage,'all')/numel(currentimage);
    
    referenceimage = self.ProcessImage(referenceimage,100);
    referencepercent = sum(referenceimage,'all')/numel(referenceimage);

    % if percent is significantly different, there is an obstruction
    if abs(currentpercent - referencepercent) > error
        obstruction = true;
    else
        obstruction = false;
    end
end

function move = FindPlayerMove(self)
    newboard = SenseBoardState(self);
    
    % compare new board and stored board
    changes = (newboard ~= self.game.board);
    [row,col] = find(changes);
    move = [row(1),col(1)];
end

function image = TakeImage(self)
    % take image from webcam
    image = snapshot(self.cam);
end
end

methods(Static)
function processed = ProcessImage(image,areaopen)
    if size(image,3) > 1
        image = rgb2gray(image);
    end
    processed = imbinarize(image, graythresh(image));
    processed = bwareaopen(processed, areaopen);
    processed = ~bwareaopen(~processed, areaopen);
end

function color = FindColor(pixel)
    name = {'white','red','blue'};
    value = [255 255 255; 255 0 0; 0 0 255];

    for i = 1:size(value,1)
        error(i) = sum((value(i,:) - pixel).^2);
    end
    [~,i] = min(error);
    color = name{i};
end

end
end

