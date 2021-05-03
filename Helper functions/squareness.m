function error = squareness(area, perimeter)
% area = d^2
% perimeter = d*4
a = (perimeter/4)^2;
sq = a/area;
error = abs(sq-1); % the closer to 0, the more square