function [labelImage boundaryPixels insidePixels] = getNonRoiPixels(tImage,lImage,kernelSize,verbose)
% this function returns boundary pixels of a cell.
% boundary pixels are those non zero pixels, for whom atleast one zero
% pixel exists within the bounding box of size kernelSize x kernelSize


% convolving a kernel of ones with the image mask gives a image with 
% values at each pixel specifying number of non-zero pixels in its kernel
% neighbourhood
kernel = ones(kernelSize,kernelSize);
pixelCount = conv2(double(tImage>0),kernel,'same'); 

boundaryPixels = pixelCount;
insidePixels = pixelCount;

% boundary pixels contain less than kernelSize x kernelSize non zero pixels
% in its neighbourhood
boundaryPixels(boundaryPixels >= (kernelSize*kernelSize)) = 0;
boundaryPixels(boundaryPixels>0) = 1;

% Drop boundary pixels to obtain inside + labelled pixels
insidePixels(insidePixels < (kernelSize*kernelSize)) = 0;
insidePixels(insidePixels > 0) = 1;

% Now we need to calculate region of uncertainity around the labelled
% pixels. This is done by convolving labelled image with a ones kernel. All
% non zero pixls in the resulting image are in the neighbourhood of
% labelled pixels
kernel = ones(10,10); % 5 pixels around the labelled pixels lie in the region of uncertainity
removedPixels = conv2(double(lImage),double(kernel),'same');
removedPixels(removedPixels ~= 0) = -1;
removedPixels(removedPixels >= 0) = 1;
removedPixels(removedPixels == -1) = 0;

labelImage = lImage;
boundaryPixels = boundaryPixels .* (tImage>10) .* removedPixels;
insidePixels = insidePixels  .* (tImage>10) .* removedPixels;

if verbose
   figure();
   subplot(1,4,1);
   imshow(tImage);
   title('original Image');
   subplot(1,4,2);
   imshow(labelImage);
   title('labelled');
   subplot(1,4,3);
   imshow(boundaryPixels);
   title('boundary pixels');
   subplot(1,4,4);
   imshow(insidePixels);
   title('inside pixels');
end
end