function transforms = jointtransforms(robot,q)
transforms = zeros(4,4,robot.n+1);
transforms(:,:,1) = robot.base;

% for each joint, if type is revolute, sub q for theta
% if type is prismatic, sub q for d
for j = 1:robot.n
    % find transform
    if robot.links(j).sigma == 0 % revolute
        T = trotz(q(j)+robot.links(j).offset)...
            *transl([0,0,robot.links(j).d])...
            *transl([robot.links(j).a,0,0])...
            *trotx(robot.links(j).alpha);
    else % prismatic
        T = trotz(robot.links(j).theta)...
            *transl([0,0,q(j)+robot.links(j).offset])...
            *transl([robot.links(j).a,0,0])...
            *trotx(robot.links(j).alpha);
    end
    
    % multiply by previous position
    transforms(:,:,j+1) = transforms(:,:,j)*T;
end

for i = 1:size(transforms,3)
    hold on
    plot3(transforms(1,4,i),transforms(2,4,i),transforms(3,4,i),'r.');
    endP = (transforms(1:3,4,i) + 0.01 * transforms(1:3,3,i))';
    plot3(endP(:,1),endP(:,2),endP(:,3),'g.');
end