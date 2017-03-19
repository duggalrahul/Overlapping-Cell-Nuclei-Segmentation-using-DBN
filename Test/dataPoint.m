function d = dataPoint(i,j,image,boxSide)
boxSide = (boxSide-1)/2;
d = [];
for r = -boxSide:boxSide
    for c = -boxSide:boxSide
         %fprintf('%d %d\n',r+boxSide,c+boxSide);
        d(r+boxSide+1,c+boxSide+1) = image(i+r,j+c);
    end
end

end