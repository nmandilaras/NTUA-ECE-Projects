function [] = epochRange(finalTrainData, finalTrainDataTargets, ...
    finalTestData, finalTestDataTargets, trainRatio, valRatio, testRatio, numEpochs, bestTrainFunc, bestL1Neurons, ...
bestL2Neurons)


for i = numEpochs    
	if bestL2Neurons == 0
		net = newff(finalTrainData, finalTrainDataTargets, [bestL1Neurons], {}, char(bestTrainFunc));
	else
		net = newff(fianlTrainData, finalTrainDataTargets, [bestL1Neurons bestL2Neurons], {}, ...
			char(bestTrainFunc));
	end
	net.divideParam.trainRatio = trainRatio;
	net.divideParam.valRatio = valRatio;
	net.divideParam.testRatio = testRatio;
	net.trainParam.epochs = i;
	net = train(net, finalTrainData, finalTrainDataTargets);
	TestDataOutput = sim(net, finalTestData);
	[accuracy(i), precision(i, :), recall(i, :)] = eval_Accuracy_Precision_Recall(TestDataOutput, finalTestDataTargets);
end

y=figure;
plot(accuracy);
title([ 'Accuracy for different training epoches']);
xlabel('Number of Epochs', 'interpreter', 'latex');
ylabel('Accuracy', 'interpreter', 'latex');
xlim([numEpochs(1),numEpochs(length(numEpochs))])
%saveas(y,'epochRange.png');
[bestAccNumEpochs, indexNumEpochs] = max(accuracy);
bestNumEpochs = indexNumEpochs;
end