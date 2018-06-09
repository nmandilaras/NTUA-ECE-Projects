function [finalTestData, finalTrainData, finalTrainDataTargets, finalTestDataTargets]...
    =preproc(TrainDataTargets, TrainData, TestData, TestDataTargets)

% Find image parts per category and plot bar graph
categories = sum(TrainDataTargets, 2);
% bar(categories);
% xlabel('Categories');
% ylabel('Number of image parts');
% title('Initial Image parts per category');

% Process data to keep the same number of parts per category
k = min(categories);    %We'll keep only k parts for each category
for i = 1:5
	index(i,:) = find(TrainDataTargets(i,:), k);
end

% Store all indices in 1 array
ind2keep = [index(1,:) index(2,:) index(3,:) index(4, :) index(5,:) ];
permutation=randperm(size(ind2keep,2));
ind2keep=ind2keep (permutation);

% Keep only indices from ind2keep in data matrices
TrainData=TrainData(:,ind2keep);
TrainDataTargets=TrainDataTargets(:,ind2keep);
% Find new number of image parts per category
newCat = sum(TrainDataTargets,2);
% figure;
% bar(newCat);
% xlabel('Categories');
% ylabel('Number of image parts');
% title('New Image parts per category');

% Delete rows with constant values from TrainData
[finalTrainData, PS]= removeconstantrows(TrainData);
% Keep settings and do the same for TestData
finalTestData = removeconstantrows('apply', TestData,PS);

% Normalize: make each row's means 0 and deviations 1
[finalTrainData,PS] = mapstd(finalTrainData);
finalTestData = mapstd('apply', finalTestData,PS);

% Keep only 20 rows
% maxfrac is 0.01 to keep only ~20 rows (19)
[finalTrainData,PS] = processpca(finalTrainData,0.01);
finalTestData = processpca('apply', finalTestData,PS);

finalTrainDataTargets = TrainDataTargets;
finalTestDataTargets = TestDataTargets;
size(finalTestData);
end