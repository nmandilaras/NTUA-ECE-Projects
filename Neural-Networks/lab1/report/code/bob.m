function [] = bob(myFinalTrainData, myFinalTrainDataTargets, myFinalTestData,...
    myFinalTestDataTargets, trainRatio, valRatio, testRatio, epochs,  bestTrainFunc,...
    bestActivFunc, bestLearnAlgo, bestL1Neurons, bestL2Neurons)

if bestL2Neurons == 0
	bestNet = newff(myFinalTrainData, myFinalTrainDataTargets, [bestL1Neurons], {'tansig' 'tansig' ...
		char(bestActivFunc)}, char(bestTrainFunc), char(bestLearnAlgo));
else
	bestNet = newff(myFinalTrainData, myFinalTrainDataTargets, [bestL1Neurons bestL2Neurons], {'tansig' ...
		'tansig' char(bestActivFunc)}, char(bestTrainFunc), char(bestLearnAlgo));
end
bestNet.divideParam.trainRatio = trainRatio;
bestNet.divideParam.valRatio = valRatio;
bestNet.divideParam.testRatio = testRatio;
bestNet.trainParam.epochs = epochs;
%bestNet.trainParam.lr = bestLearnRate;
bestNet = train(bestNet, myFinalTrainData, myFinalTrainDataTargets);
bestTestDataOutput = sim(bestNet, myFinalTestData);
[accuracy, precision, recall] = eval_Accuracy_Precision_Recall(bestTestDataOutput, myFinalTestDataTargets);


y=figure;
bar(accuracy);
axis([0,3,0,1.1]); %set upper limits on x,y axis
title([ 'Accuracy for best parameters']);
xlabel('Number of Epochs', 'interpreter', 'latex');
ylabel('Accuracy', 'interpreter', 'latex');
%xlim([numEpochs(1),numEpochs(length(numEpochs))])
end