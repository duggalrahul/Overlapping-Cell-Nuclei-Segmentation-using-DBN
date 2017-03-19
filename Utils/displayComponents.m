function displayComponents(phiQuery,aQuery,phiReference,aReference,querySize,referenceSize)
    [xq,yq] = size(phiQuery);
    [xr,yr] = size(phiReference);

    queryComponents = zeros(querySize(1),querySize(2)*(yq+1),querySize(3));
    referenceComponents = zeros(referenceSize(1),referenceSize(2)*(yr+1),referenceSize(3));

    queryComponents(:,1:querySize(2),:) = od2rgb(reshape((phiQuery * aQuery)', querySize));
    referenceComponents(:,1:referenceSize(2),:) = od2rgb(reshape((phiReference * aReference)', referenceSize));

    for i=1:yq
        phiQuerySingleStain = zeros(size(phiQuery));
        phiQuerySingleStain(:,i) = phiQuery(:,i);
        phiReferenceSingleStain = zeros(size(phiReference));
        phiReferenceSingleStain(:,i) = phiReference(:,i);

        querySingleStainImage = od2rgb(reshape((phiQuerySingleStain * aQuery)', querySize));
        referenceSingleStainImage = od2rgb(reshape((phiReferenceSingleStain * aReference)', referenceSize));

        queryComponents(:,i*querySize(2)+1:(i+1)*querySize(2),:) = querySingleStainImage;
        referenceComponents(:,i*referenceSize(2)+1:(i+1)*referenceSize(2),:) = referenceSingleStainImage;            

    end
    
    figure;
    subplot(2,1,1);
    imshow(referenceComponents);
    title('reference components');
    subplot(2,1,2);
    imshow(queryComponents);
    title('query components');
end