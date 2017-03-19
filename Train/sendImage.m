function [roi,nonRoiBoundary,nonRoiInside] = sendImage(insideImage,boundaryImage,labelImage, trainImage,boxSide)
% this function creates an a*a bounding box outside every pixel of
% insideImage,boundaryImage,labelImage
% roi : a*a*r matrix of bounding boxes of r roi points
% nonRoiBoundary : a*a*n matrix of bounding boxes of n nonroi boundary points
% nonRoiInside : a*a*n matrix of bounding boxes of n nonroi inside points
% 
% 2:1 mixture of border vs non border nonRoi points.


% find positions of non zero pixels
[xb yb] = find(boundaryImage);
[xi yi] = find(insideImage);
[xl yl] = find(labelImage);
[xt yt] = find(trainImage); 

% predefine matrices to avoid memory re-allocation
roi = zeros(size(xl,1),boxSide*boxSide);
nonRoiBoundary = zeros(size(xb,1),boxSide*boxSide);
nonRoiInside = zeros(size(xi,1),boxSide*boxSide);

% intialize counters
countRoi = 1;
countNonRoiBoundary = 1;
countNonRoiInside = 1;

% iterate over all non zero pixels
for i = 1:size(xt,1) 
    if (xt(i)-boxSide>0) && (xt(i)+boxSide<=size(trainImage,1)) && (yt(i)-boxSide>0) && (yt(i)+boxSide<=size(trainImage,2))
        if (labelImage(xt(i),yt(i)) == 1)
            d = dataPoint(xt(i),yt(i),trainImage,boxSide);
            roi(countRoi,:) = d;
            countRoi = countRoi+1;
            
        elseif (boundaryImage(xt(i),yt(i)) == 1)
            d = dataPoint(xt(i),yt(i),trainImage,boxSide);
            nonRoiBoundary(countNonRoiBoundary,:) = d;
            countNonRoiBoundary = countNonRoiBoundary+1;
            
        elseif (insideImage(xt(i),yt(i))==1)
            d = dataPoint(xt(i),yt(i),trainImage,boxSide);
            nonRoiInside(countNonRoiInside,:) = d;
            countNonRoiInside = countNonRoiInside+1;
        end
    end
end

countNonRoi        = 2 * countRoi;
randNonRoiBoundary = ceil(countNonRoi * (1/3));
randNonRoiInside   = ceil(countNonRoi * (2/3));

% if insufficient non-roi-boundary pixels exist, then pick maximum
% available number
if randNonRoiBoundary+1 > countNonRoiBoundary
    randNonRoiBoundary = countNonRoiBoundary-1
end

% shuffle the pixels
p = randperm(countNonRoiBoundary-1,randNonRoiBoundary);
nonRoiBoundary = nonRoiBoundary(p(1:randNonRoiBoundary),:);
p = randperm(countNonRoiInside-1,randNonRoiInside);
nonRoiInside = nonRoiInside(p(1:randNonRoiInside),:);

end