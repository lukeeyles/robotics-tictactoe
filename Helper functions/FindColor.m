function color = FindColor(pixel)
name = {'white','grey','black','red','blue'};
value = [255 255 255; 127 127 127; 0 0 0; 100 20 20; 50 60 130];

for i = 1:size(value,1)
    error(i) = sum((value(i,:) - pixel).^2);
end
[~,i] = min(error);
color = name{i};
end