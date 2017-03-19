
X = double(X) / 255;

% shuffle the rows of the training set
randomShuffle = randperm(size(X,1));
X = X(randomShuffle,:);
Y = Y(randomShuffle,:);

% training set into training and validation set
[trainInd,valInd,~] = dividerand(size(X,1),0.8,0.2,0);
val_X = X(valInd,:);
val_Y = Y(valInd,:);
train_X = X(trainInd,:);
train_Y = Y(trainInd,:);

% ensure batch size 256 is possible
sz = size(train_X,1);
train_X = train_X(1:floor(sz/256)*256,:);
train_Y = train_Y(1:floor(sz/256)*256,:);

clearvars -except train_X train_Y val_X val_Y
% 
% %%%%%%%%% DBN CODE %%%%%%%%%%%
rand('state',0)

dbn.sizes = [289 121];
opts.numepochs =   50;
opts.batchsize = 256;
opts.momentum  =   0;
opts.alpha     =   0.1;
dbn = dbnsetup(dbn, train_X, opts);
dbn = dbntrain(dbn, train_X, opts);

% figure; visualize(dbn.rbm{1}.W');   %  Visualize the RBM weights

save('dbn.mat','dbn','opts');

nn = dbnunfoldtonn(dbn, 3);

% %%%%%%%%% NN CODE %%%%%%%%%%%
clearvars opts

nn.learningRate                     = 0.1;            %  learning rate Note: typically needs to be lower when using 'sigm' activation function and non-normalized inputs.
nn.weightPenaltyL2                  = 1e-4;            %  L2 regularization

opts.numepochs =  150;   %  Number of full sweeps through data.
opts.batchsize = 256;  
opts.plot = 1; %plot the training error

[nn, L] = nntrain(nn, train_X, train_Y, opts, val_X, val_Y);

clearvars -except nn dbn opts