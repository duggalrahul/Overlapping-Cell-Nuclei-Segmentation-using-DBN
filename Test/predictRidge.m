function [segmentedMask,predictData] = predictRidge(predictImageGrey,boxSide,nn,verbose)

[predictSet predictCompositeImage] = createPredictTest(predictImageGrey,boxSide,0);

predictPositions = predictSet(:,[1 2]); % positions of pixels
predictData = double(predictSet(:,3:end)) / 255; %bounding box data
fprintf('predicting image\n');

clearvars predictSet;

%%%%%%%%%%%%% predict ANN %%%%%%%%%%%%%%
predictedLabels = nnpredict(nn, predictData);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('printing image\n');

predictedImage1 = zeros(size(predictImageGrey));
predictedImage2 = zeros(size(predictImageGrey));
predictedImage3 = zeros(size(predictImageGrey));

for i=1:size(predictedLabels,1)
    if predictedLabels(i) == 1
        predictedImage1(predictPositions(i,1),predictPositions(i,2)) = 1;
    end
    if predictedLabels(i) == 2
        predictedImage2(predictPositions(i,1),predictPositions(i,2)) = 1;
    end
    if predictedLabels(i) == 3
        predictedImage3(predictPositions(i,1),predictPositions(i,2)) = 1;    
    end
    
end

segmentedMask = bitor(predictedImage2,predictedImage3);
segmentedMask = imfill(segmentedMask,'holes');


if verbose 
    figure();
    subplot(2,2,1);
    imshow(predictCompositeImage);
    title('input');
    subplot(2,2,2);
    imshow(predictedImage1);
    title('class 1');
    subplot(2,2,3);
    imshow(predictedImage2);
    title('class 2');
    subplot(2,2,4);
    imshow(predictedImage3);
    title('class 3');
end

end