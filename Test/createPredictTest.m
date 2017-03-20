function [predictSet testCompositeImage] = createPredictTest(testImage,boxSide,verbose)
%this function retuns a boxSide x boxSide bounding boxfor each pixel in
%testImage
%predictSet = pixelCount x [(1x2 pixelLocation) (boxSide * boxSide)] matrix

    testCompositeImage = im2bw(testImage,0);

    [m n] = size(testImage);

    [x y] = find(testCompositeImage); % find nonzero elements
    predictSet = zeros(size(x,1),2 + boxSide*boxSide);

    tic
    parfor k=1:size(x,1)
        i = x(k); j = y(k); % position of the pixel
        bs = (boxSide-1)/2;

        if i+bs<=m & i-bs>0 & j+bs<n & j-bs>0      
            boundingBox = dataPoint(i,j,testImage,boxSide); % get the boundigbox (boxSide x boxSide matrix)
            predictSet(k,:) = [i j reshape(boundingBox,1,[])];  %position followed by bounding box  
        end
    end
    poolobj = gcp('nocreate');
    delete(poolobj);

    predictSet = predictSet(~(predictSet(:,1) == 0),:); %remove rows with no bounding boxes

    if verbose
        figure();
        imshow(testCompositeImage);
        title('testCompositeImage');
    end
end