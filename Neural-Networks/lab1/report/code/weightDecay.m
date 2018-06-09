function [] = weightDecay(myFinalTrainData, myFinalTrainDataTargets, myFinalTestData,...
    myFinalTestDataTargets, trainRatio, valRatio, testRatio, bestTrainFunc,...
    bestActivFunc, bestLearnAlgo, bestL1Neurons)

    net = newff(myFinalTrainData, myFinalTrainDataTargets, [bestL1Neurons], {'tansig' 'tansig' ...
        char(bestActivFunc)}, char(bestTrainFunc), char(bestLearnAlgo));

    net.divideParam.trainRatio = trainRatio;
    net.divideParam.valRatio = valRatio;
    net.divideParam.testRatio = testRatio;
    net.trainParam.epochs = 1;
    net = train(net, myFinalTrainData, myFinalTrainDataTargets);
    for lambda = 0.1:0.05:0.4
        for d = 0.02:0.005:0.050
            for k = 1:20
                t = getwb(net);
                [net, trWD] = train(net, myFinalTrainData, myFinalTrainDataTargets);
                nt = getwb(net);
                nt = nt - lambda*t;
                threshold = nt > d;
                nt = nt.*threshold;
                nonZero = find(nt);
                nonZeroNum(k) = length(nonZero);
                trainError(k) = trWD.perf(1);
                net = setwb(net, nt);
            end
            TestDataOutput = sim(net, myFinalTestData);
            [accuracyWD, precisionWD, recallWD] = eval_Accuracy_Precision_Recall(TestDataOutput, myFinalTestDataTargets);

            iterations = 1:k;
            figure('Name', 'Decay Method');
            str = sprintf('lamda = %.3f , and d = %.3f',lambda,d);
            subplot(2,1,1)
            plot(iterations, nonZeroNum);
            title(str);
            xlabel('Number of iterations', 'interpreter', 'latex');
            ylabel('Number of nonzero weights', 'interpreter', 'latex');
            subplot(2,1,2)
            plot(iterations, trainError);
            xlabel('Number of iterations', 'interpreter', 'latex');
            ylabel('Training Error', 'interpreter', 'latex');
            ylim([0 1]);
        end
    end
end