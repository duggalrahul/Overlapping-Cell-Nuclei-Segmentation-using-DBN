function [clustersbw, isolatedbw] = isolateClusters(image,bw,verbose)


imgDist=-bwdist(~bw,'cityblock');
mask = imextendedmin(imgDist,5);

% figure,subimage(mat2gray(imgDist));
% figure,imshowpair(bw,mask,'blend');
% figure, imshow(mask);

CC = bwconncomp(bw);

clustersbw = zeros(size(bw));
isolatedbw = zeros(size(bw));

%multiple connected components of mask within each connected component of
%mask correspond to clusters
for i = 1:size(CC.PixelIdxList,2)
    bwCC = zeros(size(bw));
    bwCC(CC.PixelIdxList{i}) = 1;
    maskCC = bwconncomp(bitand(bwCC,mask));
    if(size(maskCC.PixelIdxList,2) > 1)
        clustersbw = bitor(clustersbw,bwCC);
    else
        isolatedbw = bitor(isolatedbw,bwCC);
    end
end


if verbose 
    figure();
    subplot(1,2,1);
    imshow(clustersbw);
    subplot(1,2,2);
    imshow(isolatedbw);
end

end