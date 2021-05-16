%% GetLinkPoses
% borrowed from Lab 5 
% q - dobot joint angles
% dobot -  DobotMagician
% transforms - list of transforms
function [ transforms ] = GetLinkPoses( q, dobot)

links = dobot.model.links;
transforms = zeros(4, 4, length(links) + 1);
transforms(:,:,1) = dobot.model.base;

for i = 1:length(links)
    L = links(1,i);
    
    current_transform = transforms(:,:, i);
    
    current_transform = current_transform * trotz(q(1,i) + L.offset) * ...
    transl(0,0, L.d) * transl(L.a,0,0) * trotx(L.alpha);
    transforms(:,:,i + 1) = current_transform;
end
end