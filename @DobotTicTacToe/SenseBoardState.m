function board = SenseBoardState(self)
I = snapshot(self.cam);

radius = 5;
% for each pixel, check surrounding area, average colour, check colour
% player 1 (human) = blue, player 2 (robot) = red
board = zeros(3);
for row = 1:3
    for col = 1:3
        pixel = self.ProjectCamera(self.boardsquares(:,:,row,col));
        segment = I(pixel(2)-radius:pixel(2)+radius,...
            pixel(1)-radius:pixel(1)+radius,:);
        meancolour = [mean(segment(:,:,1),'all'),...
            mean(segment(:,:,2),'all'),...
            mean(segment(:,:,3),'all')];
        colour = FindColor(meancolour);
        if strcmp(colour,"blue")
            board(row,col) = 1;
        elseif strcmp(colour,"red")
            board(row,col) = 2;
        end
    end
end