function nucleus_mask = onlykmeans(img_rgb, verbose)

[h,w,c] = size(img_rgb);
img_lab = rgb2lab(img_rgb);
img_ab = img_lab(:,:,2:3);

n_clusters = 3;
[idx,c] = kmeans(reshape(img_ab,[h*w,2]),n_clusters,'distance','cityblock', 'Replicates',4);

idx = reshape(idx,[h,w]);

max_average_a_minus_b = -10000;

for i=1:n_clusters    
    mask = (idx==i);
    class = img_ab .* repmat(mask,[1,1,2]);
    
    average_a_minus_b = sum(sum(class(:,:,1) - class(:,:,2))) / nnz(class(:,:,1) - class(:,:,2));
    
    if max_average_a_minus_b < average_a_minus_b  %% for pixels belonging to nucleus class, a-b is maximum
        max_average_a_minus_b = average_a_minus_b;
        nucleus_mask = mask;
    end        
end

nucleus_mask = imfill(nucleus_mask,'holes');

if verbose
    figure;
    subplot(1,3,1);
    imshow(idx==1);    
    subplot(1,3,2);
    imshow(idx==2);
    subplot(1,3,3);
    imshow(idx==3);    
end

end 