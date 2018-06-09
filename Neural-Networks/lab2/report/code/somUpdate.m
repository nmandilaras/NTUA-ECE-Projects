function somUpdate(pattern, learningRate, neighborDist)
% ενημέρωση/ανανέωση του συνόλου των παραμέτρων ενός SOM
% Αυτή η συνάρτηση τροποποιεί/ενημερώνει τα βάρη/παραμέτρους ενός SOM βάσει του αλγορίθμου
% μάθησης του Kohonen, ο τύπος είναι Δwi = ηai(x-wi) 
% learningRate: ο ρυθμός μάθησης κατά το παρόν βήμα της τροποποίησης των βαρών του SOM.
global IW N;

activations = somActivation(pattern, neighborDist); % returns which nodes 

for i=1:N
    IW(i,:) = IW(i,:) + learningRate * activations(i) * (pattern' - IW(i,:));
end