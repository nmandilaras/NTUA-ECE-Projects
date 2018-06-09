%%%%%%%%%%%%%% myMax %%%%%%%%%%%%%%
%%% Finds the value of global max in a 2D array
%%% and its indices
%%%Arguments: a 2D array
%%%Returns: max, argmax_x, argmax_y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [totalMax, bestNeuron, bestTrainFunction] = myMax(myMatrix)

%Max of each row, keep indices (=bestNeuron for Max)
[tempMaxRows, maxArgRows] = max(myMatrix,[],2); 
%Max of the max of rows (=total max), keep the index (=bestTrainFunction)
[totalMax, bestTrainFunction]=max(tempMaxRows);
%Find bestNeuron from previous indices array
bestNeuron = maxArgRows(bestTrainFunction);
end