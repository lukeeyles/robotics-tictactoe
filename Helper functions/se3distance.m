function d = se3distance(t1,t2)
dx = t2(1,4) - t1(1,4);
dy = t2(2,4) - t1(2,4);
dz = t2(3,4) - t1(3,4);
d = sqrt(dx^2 + dy^2 + dz^2);