%%%%%%%% plotValSet %%%%%%%%%%%%%%%%%%
%%% Plots bar diagram for given lvl 1 and 2
%%% parameters with and witout validation set
%%% Arguments: 
%%% lvl1Neurons: number of Level 1 Neurons
%%% lvl2Neurons: number of Level 2 Neurons
%%% finalTestDataTargets: test data and expected output
%%% finalTrainData, finalTrainDataTargets: train data and expected output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function []= plotValSet(lvl1Neurons, lvl2Neurons, trainFunction,...
    finalTrainData, finalTrainDataTargets, finalTestData, finalTestDataTargets)

for i=1:2
    %Create new neural network
    if lvl2Neurons == 0  %No second hidden level of neurons
        net = newff(finalTrainData, finalTrainDataTargets, [ lvl1Neurons ], {},trainFunction); 
    else %create 2nd level with secondLevelNeurons number of neurons
        net = newff(finalTrainData, finalTrainDataTargets,[lvl1Neurons lvl2Neurons],{},trainFunction);        
    end
    if i==1 %With validation set
        net.divideParam.trainRatio=0.8;
        net.divideParam.valRatio=0.2;
    else %No validation set
        net.divideParam.trainRatio=1.0;
        net.divideParam.valRatio=0.0;
    end
    net.divideParam.testRatio=0;
    %Train the NN
    [net, perf(i)] = train(net,finalTrainData,finalTrainDataTargets);
    %Find output of NN using TestData as input
    output = sim(net,finalTestData);  
    %Evaluate the NN using these 3 metrics:
    [accuracy(i) precision recall]= ...
          eval_Accuracy_Precision_Recall(output,finalTestDataTargets);
     y=figure;
     plotperform(perf(i));
     saveas(y,['perf' int2str(i) '.png']);
end
y=figure;
bar(accuracy);
axis([0,3,0,1]); %set upper limits on x,y axis
ylabel('Accuracy');
xlabel('Validation set');
set(gca,'XTickLabel',['Yes';'No ']);
title([ 'Accuracy when using and not using validation set']);
saveas(y,'valSet.png');
end