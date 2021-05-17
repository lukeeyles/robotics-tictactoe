function qInterpolated = InterpolateQMatrix(qMatrix,steps)
qInterpolated = [];
for i = 1:size(qMatrix,1)-1
    jtraj(qMatrix(i,:),qMatrix(i+1,:),steps)
    qInterpolated = [qInterpolated;jtraj(qMatrix(i,:),qMatrix(i+1,:),steps)];
end
end