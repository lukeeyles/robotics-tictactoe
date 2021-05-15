classdef DobotTicTacToe < handle
% class to control dobot to play tic tac toe with a human
properties
    game = TicTacToe();
    dobot;
    cam; % webcam
    cammodel;
    realrobot;
    calibrationMatrix = [481.8517 0 315.3629;
        0 484.7421 297.6908;
        0 0 1.0000];
    cameraT;
    tableheight = -0.12; % height of table
    centredistance = 0.155/2; % distance from edge of robot to centre
    boardloc;
    boardsquares; % location of all squares on board relative to centre of robot
    tilesize = 0.045; % size of playing pieces
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
        disp("Camera not found");
    end
    
    self.boardloc = transl([0.12+self.centredistance 0 self.tableheight]);
    % generate locations for all board squares
    self.boardsquares = zeros(4,4,3,3);
    for row = 1:3
        for col = 1:3
            self.boardsquares(:,:,row,col) =...
                self.boardloc*transl([(row-2)*self.tilesize (col-2)*self.tilesize 0]);
        end
    end
    
    self.cameraT = transl(0.12+self.centredistance,0,0.13)*troty(pi)*trotz(-pi/2);
    self.cammodel = CentralCamera('focal', 483, 'pixel', 1, ...
    'resolution', [640 480], 'centre', [315 298], 'name', 'mycamera');
    self.cammodel.T = self.cameraT;
end

function obstruction = SenseObstruction(self,currentimage,referenceimage,error)
    % error = percentage of pixels different
    % compare reference image and current webcam output
    currentimage = self.ProcessImage(currentimage,100);
    currentpercent = sum(currentimage,'all')/numel(currentimage);
    
    referenceimage = self.ProcessImage(referenceimage,100);
    referencepercent = sum(referenceimage,'all')/numel(referenceimage);

    % if percent is significantly different, there is an obstruction
    fprintf("Image %f%% obstructed\n", abs(currentpercent - referencepercent)*100);
    if abs(currentpercent - referencepercent) > error
        obstruction = true;
    else
        obstruction = false;
    end
end

function move = FindPlayerMove(self,newboard)
    %newboard = SenseBoardState(self,tilepixels);
    
    % compare new board and stored board
    changes = (newboard ~= self.game.board);
    [row,col] = find(changes);
    move = [row(1),col(1)];
end

function valid = CheckValidMove(self,newboard,player)
    % compare new board and stored board
    % new board should contain exactly 1 new tile overwriting a 0
    changes = (newboard ~= self.game.board & self.game.board == 0 & newboard == player);
    valid = (sum(changes,'all') == 1);
end

function uv = ProjectCamera(self,transform)
    uv = self.cammodel.project(permute(transform(1:3,4,:),[1,3,2]))';
end

function image = TakeImage(self)
    % take image from webcam
    image = snapshot(self.cam);
end

function TestCamera(self)
    timeout = 10;
    tic;
    while toc < timeout
        I = snapshot(self.cam);
        tilepixels = self.ProjectCamera(self.boardsquares)
        imshow(I)
        hold on;
        for i = 1:size(tilepixels,1)
            plot(tilepixels(i,1),tilepixels(i,2),'r*')
        end
    end
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

