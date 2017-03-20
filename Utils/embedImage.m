function padded_image = embedImage(image,padding)
    %adds padding to the image. size_padding is a 1x4 array of
    %[top,right,bottom,left] padding size
    [h,w,d] = size(image);
    padded_image = zeros([h+padding(1)+padding(3),w+padding(2)+padding(4),d]);
    padded_image(padding(1):h+padding(1)-1,padding(4):w+padding(4)-1,:) = image; 
end