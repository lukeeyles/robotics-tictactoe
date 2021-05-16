function react = obstruction(self, d)
axis on;
hold on;
%% Initilise robot 
robot = DobotMagician();
  qn = [0 pi/6 pi/3 0];
robot.Plot(qn);
d= 0.3
dt = 0.1;
%% 
s = surf([d,d;d,d],[-0.2,0.2;-0.2,0.2],[0.2,0.2;0,0],'CData',imread('Obstruction.jpg'),'FaceColor','texturemap');  

camerapos = robot.Fkine(qn)*transl(0.05, 0, 0.1)*trotx(pi/2)*troty(pi/2)
%wrench = [0 0 0.01];

jsteps = 200;


    
   
    D = distance( camerapos(1,4), d)
    q1= robot.GetPos();
    
    if D < 0.2 % move arm in close to avoid thing
        
       q = robot.Ikine(transl(0.17, 0, -0.1));
       q2 = jtraj(q1, q, jsteps);
       %qm = robot.RMRC(wrench,q2,dt);
       robot.Animate(q2);
    end
    
     
    
    if D >= 0.2 % move arm back to 'normal' spot
        q = robot.Ikine(transl(0.25, 0, 0));
        q2 = jtraj(q1, q, jsteps);
        %qm = robot.RMRC(wrench,q2,dt);
        robot.Animate(q2);
        
    end
    
    

delete (s);

end



