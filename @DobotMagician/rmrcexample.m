r = DobotMagician();
q = r.qn;
dt = 0.1;
r.Plot(q);
wrench = [0 0 0.01];
while(true)
    q = r.RMRC(wrench,q,dt);
    r.Animate(q);
    f = r.Fkine(q);
    hold on;
    plot3(f(1,4),f(2,4),f(3,4),"r.")
end