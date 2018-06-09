% A(:,:,1) = [1 2 3 ; 3 44 1 ; 11 2 4];
% A(:,:,2) = [1 2 3 ; 4 5 6 ; 7 8 55];
% maxRows = mean(A(:,:,1),2); %Col array
% maxCols = mean(A(:,:,1),1); %Row array

% A=[1 3 ;4 2];
% [m,argm] =max(A)
% Q = [1 22 3;4 5 6]
% [maxrows, maxargRows] = max(Q,[],2); %max of rows
% [totalMax, bestFun]=max(maxrows);
% bestNeurons = maxargRows(bestFun);
% display(bestNeurons);
% display(bestFun);
% display(totalMax);
% Q(1,2)

%Load dataset
data = load('dataSet.mat');

[finalTestData, finalTrainData, finalTrainDataTargets, finalTestDataTargets]...
    = preproc(data.TrainDataTargets, data.TrainData, data.TestData, data.TestDataTargets);

lvl1Neurons = 30;
lvl2Neurons= 0;
trainFunction = 'trainlm';
plotActFunc(lvl1Neurons, lvl2Neurons, trainFunction, finalTrainData,...
    finalTrainDataTargets, finalTestData, finalTestDataTargets);