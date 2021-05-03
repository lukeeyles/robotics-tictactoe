function [boardloc,tileloc] = SenseBoardandTiles(self)
    % receive webcam image
    I = TakeImage(self);
    
    % convert image to black and white for preprocessing
    GS = rgb2gray(I);
    BW = imbinarize(GS, graythresh(GS));
    BW = bwareaopen(BW, 100);
    BW = ~bwareaopen(~BW, 100);
    
    % find regions and get region properties
    [B,L] = bwboundaries(~BW,'noholes');
    stats = regionprops(L,'ConvexArea','Centroid','Perimeter','BoundingBox');
    centroid = cat(1,stats.Centroid);
    area = cat(1,stats.ConvexArea);
    perimeter = cat(1,stats.Perimeter);
    squarearea = [2000 7000];
    boardarea = [50000 100000];
    
    % look for board + tiles in image
    for k = 1:length(area)
        if area(k) > squarearea(1) && area(k) < squarearea(2)
            boundary = B{k};
            plot(boundary(:,2),boundary(:,1),'g','LineWidth',2)
            plot(centroid(k,1),centroid(k,2),'g*');
            P = impixel(I,centroid(k,1),centroid(k,2));
            text(centroid(k,1),centroid(k,2),FindColor(P));
        elseif area(k) > boardarea(1) && area(k) < boardarea(2)
            boundary = B{k};
            plot(boundary(:,2),boundary(:,1),'r','LineWidth',2)
        end
    end
    
    % return 3d locations
    
end

