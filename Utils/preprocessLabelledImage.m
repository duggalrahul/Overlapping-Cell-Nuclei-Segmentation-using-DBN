function processed_labelled_image = preprocessLabelledImage(image, labelled_image, verbose)
%% performs simple preprocessing on the labelled image

    %create mask of non zero pixels from original image
    mask = sum(image,3);
    mask = (mask>=10);
    
    %multiply this with labelled image to remove labelled pixels which are
    %zero in the original image
    labelled_image = double(labelled_image) .* repmat(mask,[1,1,3]);
    
    %create mask of labelled pixels
    mask = sum(labelled_image,3);
    mask(mask < 255*3) = 0;
    
    %fill holes
    mask = (mask>0);
    mask = imfill(mask,'holes');

    processed_labelled_image = uint8(double(labelled_image) .* repmat(mask,[1,1,3]));
    
    if verbose
        figure;
        subplot(1,2,1)
        imshow(uint8(labelled_image));        
        subplot(1,2,2)
        imshow(mask);
        title('Labelled Pixels Mask');
    end
end