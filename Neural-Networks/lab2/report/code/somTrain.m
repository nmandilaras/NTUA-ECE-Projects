function somTrain(patterns)
% SOM training
% patterns πίνακας DxP που περιέχει το σύνολο των προτύπων εκπαίδευσης για το SOM.
% maxNeighborDist μέγιστη απόσταση που εμφανίζεται μεταξύ δύο οποιωνδήποτε νευρώνων.
% orderLR ο αρχικός ρυθμός μάθησης κατά το ordering στάδιο της εκπαίδευσης, ενδεικτική τιμή είναι το 0.9.
% tuneND η απόσταση νευρώνων που χρησιμοποιείται κατά το tuning στάδιο της εκπαίδευσης, 
% συνήθης τιμή είναι το 1
% orderSteps το πλήθος των εποχών κατά το ordering στάδιο της διαδικασίας μη επιβλεπόμενης εκπαίδευσης, ενδεικτική τιμή είναι το 1000.
% tuneLR ο ρυθμός μάθησης κατά το tuning στάδιο της εκπαίδευσης, ενδεικτική τιμή είναι το 0.01.

global maxNeighborDist orderSteps tuneND orderLR tuneLR dY %IW distances
% QuestionData;
% data = QuestionPatterns;
%ordering phase
neighborDist = exp(linspace(log(maxNeighborDist), log(tuneND), orderSteps)); % εκθετική μείωση απόστασης
learningRate = exp(linspace(log(orderLR), log(tuneLR), orderSteps)); % εκθετική μείωση ρυθμού μάθησης

for i = 1:orderSteps
    for j = 1:dY
        somUpdate(patterns(:,j), learningRate(i), neighborDist(i)); % ανανέωση
    end
    %i
%     figure(1);
%     plot2DSomData(IW, distances, data);
end

%tuning phase
for l=(orderSteps + 1):(4 * orderSteps) % μεγαλύτερη διάρκεια αυτού του σταδίου
    for j = 1:dY
        somUpdate(patterns(:,j), tuneLR, tuneND); % απόσταση και ρυθμός μάθησης σταθεροί
    end
    %l %in order to keep track of the current iteration
end