function od = rgb2od(rgb) 
    rgb(rgb==0) = min(rgb(rgb>0));
    od = -log10(rgb);
end