function [] = stepLearning(TrainData, TrainDataTargets, ...
TestData, TestDataTargets, trainRatio, valRatio, testRatio, epochs, trainFunc, bestL1Neurons, ...
bestL2Neurons, minLearRate, stepLearRate, maxLearRate)

j = 1;
for i = minLearRate:stepLearRate:maxLearRate
	if bestL2Neurons == 0
		net = newff(TrainData, TrainDataTargets, [bestL1Neurons], {}, char(trainFunc));
	else
		net = newff(TrainData, TrainDataTargets, [bestL1Neurons bestL2Neurons], {}, char(trainFunc));
	end
	net.divideParam.trainRatio = trainRatio;
	net.divideParam.valRatio = valRatio;
	net.divideParam.testRatio = testRatio;
	net.trainParam.epochs = epochs;
	net.trainParam.lr = i;
	net = train(net, TrainData, TrainDataTargets);
	TestDataOutput = sim(net, TestData);
	[accuracy(j), precision(j, :), recall(j, :)] = eval_Accuracy_Precision_Recall(TestDataOutput, TestDataTargets);
	j = j + 1;
end

figure;
plot(minLearRate:stepLearRate:maxLearRate, accuracy)
title([ 'Accuracy for different learning paces']);
ylabel('Accuracy', 'interpreter', 'latex');
xlabel(trainFunc, 'interpreter', 'latex');
% subplot(2,1,2)
% plot(learRate, accuracyLearRate2)
% ylabel('Accuracy', 'interpreter', 'latex');
% xlabel('traingdx', 'interpreter', 'latex');
end