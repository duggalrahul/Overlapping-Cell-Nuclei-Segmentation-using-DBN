% References:
% Duggal, Rahul, et al. "Overlapping cell nuclei segmentation in 
% microscopic images using deep belief networks.", Proceedings of the 
% Tenth Indian Conference on Computer Vision, Graphics and Image Processing. ACM, 2016.
%
% Copyright (c) 2015, Rahul Duggal
% SBILab
% IIIT-Delhi 

clc;
clear all;
close all;

%add all folders and subfolders to search path
addpath(genpath('.'));

%load trained model
load Models\nn_macenko.mat

% set default parameters
verbose = 0;
boxSide = 51;
resize = 1;

%specify images
reference = imread(fullfile('Data','Test_Images','ref.JPG'));
image = double(imresize(imread(fullfile('Data','Test_Images','test.JPG')),resize));

%normalize using macenko's method
[ image_normalized ] = Norm(image, reference, 'Macenko', 255, 0.15, 1, 0);   

%cluster nucleii
totalTime = tic;    
fprintf('started kmeans\n');
tic
mask = onlykmeans(image_normalized, verbose);
mask = bwareaopen(mask,500); %remove connected components with lesser than 500 pixels
fprintf('finished kmeans in %f seconds\n',toc);

%isolate clusters
fprintf('separating clusters\n');
tic;
[clustersbw,isolatedbw] = isolateClusters(image_normalized,mask,verbose);
fprintf('finished separating clusters in %f seconds\n',toc);

%break clusters using deep learning
fprintf('breaking clusters\n');
tic;
clusterImage = rgb2gray(uint8(image .* repmat(clustersbw,[1,1,3])));
[segmentedMask predictData] = predictRidge(clusterImage,boxSide,nn,verbose);

%combine isolated and broken nuclei clusters to obtain segmented image
segmentedMask = bitor(segmentedMask,isolatedbw);
segmentedMask = bwareaopen(segmentedMask,500); %filter cc with less than 500 pixels
segmentedImage = image .* repmat(segmentedMask,[1,1,3]);
fprintf('finished breaking clusters in %f seconds\n',toc);

fprintf('total time %f\n',toc(totalTime)); 

clearvars -except segmentedImage segmentedMask image    

figure();
subplot(1,2,1)
imshow(uint8(image));
subplot(1,2,2);
imshow(uint8(segmentedImage));

