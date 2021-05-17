function qReal = RMRC(self,v,qReal,dt)
% v is vx, vy, vz
J = self.Jacob0(qReal);
manipulability = sqrt(abs(det(J*J')));
threshold = 0.002;
lambdamax = 0.1;
lambda = 0;
if manipulability < threshold
    disp("applying singularity avoidance");
    lambda = (1 - (manipulability/threshold)^2)*lambdamax;
end
JDLSinv = inv(J'*J + lambda*eye(3))*J';
qdot = JDLSinv*v';

% qdot = inv(J)*v';
qModel = self.qRealToModel(qReal) + (dt*[qdot;0;0])';
qReal = self.qModelToReal(qModel);

% clamp values to qlim
qReal = clamp(qReal, self.qlimReal(:,1)', self.qlimReal(:,2)');