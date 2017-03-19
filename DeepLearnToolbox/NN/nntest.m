function [predictedLabels, er, bad] = nntest(nn, x, y)
    predictedLabels = nnpredict(nn, x);
    [dummy, expected] = max(y,[],2);
    bad = find(predictedLabels ~= expected);    
    er = numel(bad) / size(x, 1);
end
