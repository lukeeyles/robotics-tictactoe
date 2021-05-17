function JModel = Jacobn(self,qReal)
% returns seriallink model jacobian for first 3 links of model
qModel = self.qRealToModel(qReal);
qModel = qModel(1:3);

% take only first 3 links of robot
r = SerialLink(self.model.links(1:3));
JModel = r.jacobn(qModel);
JModel = JModel(1:3,1:3);