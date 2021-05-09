function handle = plotply(filename,transform)
if nargin == 1
    transform = transl(0,0,0);
end

[f,v,data] = plyread(filename,'tri');

points = transl(v);
for point = 1:size(points,3)
    points(:,:,point) = transform*points(:,:,point);
end

if isfield(data.vertex,'red')
    cdata = [data.vertex.red,data.vertex.green,data.vertex.blue]/255;
    handle = trisurf(f,points(1,4,:),points(2,4,:),points(3,4,:),'FaceVertexCData',cdata,'EdgeColor','interp');
else
    handle = trisurf(f,points(1,4,:),points(2,4,:),points(3,4,:));
end

