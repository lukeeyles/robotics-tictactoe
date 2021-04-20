function [qReal, success] = Ikine(self, T)
    % must define this function as robot does not move joints independently
    % source: James Poon notes on dobot real vs model arm
    success = false;
    qReal = zeros(1,5);
    qReal(1) = atan2(T(2,4),T(1,4));
    
    % account for offset of end effector from 4th joint
    endOffset = trotz(qReal(1))*transl(self.model.a(4), 0, self.model.d(5))/trotz(qReal(1));
    T = T/endOffset;
    
    x = T(1,4); 
    y = T(2,4); 
    z = T(3,4) - self.model.d(1);
    l = sqrt(x^2 + y^2);
    D = sqrt(l^2 + z^2);
    t1 = atan(z/l);
    t2 = acos((self.model.a(2)^2 + D^2 - self.model.a(3)^2)/...
        (2*self.model.a(2)*D));
    alpha = t1 + t2;
    beta = acos((self.model.a(2)^2 + self.model.a(3)^2 - D^2)/...
        (2*self.model.a(2)*self.model.a(3)));
    qReal(2) = pi/2 - alpha;
    qReal(3) = pi - beta - alpha;
    
    % rotate q5 to match the specified z direction
    rpy = tr2rpy(T);
    qReal(5) = rpy(3)-qReal(1);
    
    % clamp values to qlim
    qClamped = clamp(qReal, self.qlimReal(:,1)', self.qlimReal(:,2)');
    
    if qClamped == qReal
        success = true;
    end
    
    qReal = qClamped;
end