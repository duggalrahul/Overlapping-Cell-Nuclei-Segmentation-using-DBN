function d = dataPoint(i,j,image,boxSide)
    boxSideHalf = (boxSide-1)/2;
    d = image(i-boxSideHalf:i+boxSideHalf,j-boxSideHalf:j+boxSideHalf);
    d = reshape(d,[1,boxSide*boxSide]);
end