function J = Jacob0(self,q)
% returns seriallink model jacobian for first 3 links of model
qmodel = self.qRealToModel(q);
qmodel = qmodel(1:3);

% take only first 3 links of robot
r = SerialLink(self.model.links(1:3));
J = r.jacob0(qmodel);
J = J(1:3,1:3);