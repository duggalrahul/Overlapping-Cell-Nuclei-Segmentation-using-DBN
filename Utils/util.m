clear all;
clc;
close all;

full_images = dir(fullfile('Data','Raw_Images','*.*'));
reference = imread(fullfile('Data','Test_Images','ref.bmp'));
verbose = 0;

for i=3:size(full_images,1)
    [~,name,~] = fileparts(full_images(i).name);
    image = imread(fullfile('Data','Raw_Images',full_images(i).name));
    
    fprintf('%d. working on image %s\n',i,full_images(i).name);
    
    [ image_normalized ] = Norm(image, reference, 'Macenko', 255, 0.15, 1, verbose);   
%     imwrite(image_normalized,fullfile('Data','Normalized_Raw_Images',full_images(i).name));
    
    mask = onlykmeans(image_normalized,verbose); 
    mask = bwareaopen(mask,10000); %remove connected components with lesser than 10000 
    [clustersbw,isolatedbw] = isolateClusters(image,mask,verbose);
    
        
    %multiple connected components of mask within each connected component of
    %mask correspond to clusters
    CC = bwconncomp(clustersbw);
    for i = 1:size(CC.PixelIdxList,2)        
        bwCC = zeros(size(clustersbw));
        bwCC(CC.PixelIdxList{i}) = 1;
        [ix,iy] = ind2sub(size(bwCC),  CC.PixelIdxList{i}); 
        clusters = double(image_normalized) .* repmat(bwCC,[1,1,3]);
        padding = [30,30,30,30];
        nucleusCrop = uint8(embedImage(clusters(min(ix):max(ix),min(iy):max(iy),:),padding));
%         imwrite(nucleusCrop,fullfile('Data','Training_Images_Macenko',[name,'_',num2str(i),'.bmp']));
    end      
end
