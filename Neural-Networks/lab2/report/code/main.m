%Load dataset
data = load('dataSet.mat');

%% STEPS 1,2 %%
%Preprocess data
[finalTestData, finalTrainData, finalTrainDataTargets, finalTestDataTargets]...
    = preproc(data.TrainDataTargets, data.TrainData, data.TestData, data.TestDataTargets);


%% STEPS 3,4 %%
% i=1;            %Number of different 2nd hidden level configurations
% accResults = [];
% for secNeurons=0:5:30 %iterate for 2nd level number of neurons
%    accResults(:,:,i) = myTrain(finalTestData, finalTrainData, finalTrainDataTargets, finalTestDataTargets, secNeurons);
%    i = i+1;
% end
% display(accResults);
% % accResults(:,:,i) has the 2D redults table returned from
% % myTrain for #i neurons in 2nd hidden level


%% Step 6
% % Find Best config. of all
% % Find max accuracy for every training function
% % meamRow(training function, j'th 2nd level configuration)
% % the meanRow(i,j) has the mean value for the i'th training function
% % of the j'th 2nd level config.
% for j=1:(i-1)
%     meanRow(:,j) = mean(accResults(:,:,j),2);
% end
% %display(meanRow);
% 
% %Find max of mean value to determine best training function
% trainFunctions = ['traingdx'; 'trainlm '; 'traingd ' ;'traingda'];
% for j=1:(i-1)
%     [bestTrainFuncVal(j), bestMeanTrainFuncIndex(j)]= max(meanRow(:,j)); 
%     display(['2nd level:' int2str(j) ' winner:' trainFunctions(bestMeanTrainFuncIndex(j),:)]);
% end
% 
% %Find max for each 2nd level neuron configuration
% for j=1:(i-1)
%     [bestAccuracy(j), bestNeuron(j), maxTrainFuncIndex(j)] = myMax(accResults(:,:,j));
% end
% %Find total max
% [~, totalMaxInd] = max(bestAccuracy);
% totalBestNeuron = bestNeuron(totalMaxInd).*5;%Indices are in [1,6] we want them in [5:5:30]
% totalBestTrainFunction = maxTrainFuncIndex(totalMaxInd);
% display(['Best config of all: '  trainFunctions(totalBestTrainFunction,:) ' 1stLevel: ' ...
%     int2str(totalBestNeuron) ' 2nd level: ' int2str(totalMaxInd)]);

%% STEP 6a
%Find best activation function for NN with parameters:
lvl1Neurons = 30;
lvl2Neurons= 0;
trainFunction = 'trainlm';
% plotActFunc(lvl1Neurons, lvl2Neurons, trainFunction, finalTrainData,...
%     finalTrainDataTargets, finalTestData, finalTestDataTargets);

%% STEP 6b
%Find best learning function
% plotLearnFunc(lvl1Neurons, lvl2Neurons, trainFunction, finalTrainData,...
%     finalTrainDataTargets, finalTestData, finalTestDataTargets);

%% STEP 6c
%Better with or without validation set?
%  plotValSet(lvl1Neurons, lvl2Neurons, trainFunction, finalTrainData,...
%     finalTrainDataTargets, finalTestData, finalTestDataTargets);

%% STEP 6d
%Measure accuracy
trainRatio = 1.0;
valRatio = 0;
testRatio = 0;
ValSetBestEpoch = 7;
width = 5;
numEpochs = (ValSetBestEpoch - width):(ValSetBestEpoch + width);

% epochRange(finalTrainData, finalTrainDataTargets, ...
% finalTestData, finalTestDataTargets, trainRatio, valRatio, testRatio,numEpochs, trainFunction, lvl1Neurons, ...
% lvl2Neurons);

%% STEP 6e
%Determine the best learning rate for training functions traingd, traingdx
minLearRate = 0.05;
stepLearRate = 0.05;
maxLearRate = 0.4;
trainRatio = 1.0; % should this be changed ?
valRatio = 0;
epochs = 30000;
trainFunction0 = 'traingd';
trainFunction1 = 'traingdx';
%trainFunction2 = 'trainlm'; % our best training function
learRate = minLearRate:stepLearRate:maxLearRate;

% stepLearning(finalTrainData, finalTrainDataTargets, ...
% finalTestData, finalTestDataTargets, trainRatio, valRatio, testRatio, epochs, trainFunction0, lvl1Neurons, ...
% lvl2Neurons, minLearRate, stepLearRate, maxLearRate);
% 
% stepLearning(finalTrainData, finalTrainDataTargets, ...
% finalTestData, finalTestDataTargets, trainRatio, valRatio, testRatio, epochs, trainFunction1, lvl1Neurons, ...
% lvl2Neurons, minLearRate, stepLearRate, maxLearRate);
% 
% stepLearning(finalTrainData, finalTrainDataTargets, ...
% finalTestData, finalTestDataTargets, trainRatio, valRatio, testRatio, epochs, trainFunction2, lvl1Neurons, ...
% lvl2Neurons, minLearRate, stepLearRate, maxLearRate);

%% STEP 7
%Designing of a NN which combines the best parameters 

lvl1Neurons = 30;
lvl2Neurons= 0;
bestTrainFunc = 'trainlm';
trainRatio = 0.8;
valRatio = 0.2;  % we use a validation set
testRatio = 0;
epochs=1000;
bestActivFunc = 'tansig';
bestLearnAlg = 'learngdm';

% bob(finalTrainData, finalTrainDataTargets, ...
%     finalTestData, finalTestDataTargets, trainRatio, valRatio, testRatio, epochs, bestTrainFunc, bestActivFunc, bestLearnAlg, lvl1Neurons, ...
%     lvl2Neurons);


%% Weight decay method
%Designing of a NN which combines the best parameters 

% We use as training function: traingdx, as activation function for output layer: purelin, 
% as learning algorith: learngd, 1 level with 30 neurons
lvl1Neurons = 30;
lvl2Neurons= 0;
trainFunction = 'trainlm';
trainRatio = 0.8;
valRatio = 0.2;  % we use a validation set
testRatio = 0;
epochs=1000;
%bestLearnRate =0.1;    % best learning rate for our best train function
bestActivFunc = 'tansig';
bestLearnAlg = 'learngdm';


% weightDecay (finalTrainData, finalTrainDataTargets, finalTestData, finalTestDataTargets,...
%     trainRatio, valRatio, testRatio, bestTrainFunc, bestActivFunc,bestLearnAlg,...
%     lvl1Neurons);

% values of parameters that we chose 
%lambda = 0.15;
%d = 0.02;