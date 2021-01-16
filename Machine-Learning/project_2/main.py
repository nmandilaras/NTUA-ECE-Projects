# -*- coding: utf-8 -*-
from data_preprocess import data_preproc
from sklearn.cross_validation import train_test_split
from neural_network2 import NeuralNetwork
from sklearn.metrics import accuracy_score

train, target = data_preproc('Iris.csv')   # call the preprocessing function
x_train, x_test , y_train, y_test = train_test_split(train, target, test_size=.3) # we split our data in two sets for training and testing we keep 30% for testing

### Set the hyperparameters here ###
iterations = 40000
learning_rate = 0.0001
input_nodes = 4
hidden_nodes = 9
output_nodes = 1

network = NeuralNetwork(input_nodes, hidden_nodes, output_nodes, learning_rate, iterations)

network.train(x_train, y_train)

result = network.run(x_test)

predictions=[]
for item in result:
    predictions.append(round(item))

print accuracy_score(y_test, predictions)

'''
Σ' αυτό το project έγινε μελέτη του κλασσικού προβλήματος ταξινόμησης των ειδών του Iris flower. Για την ταξινόμηση των φυτών ανά είδος χρησιμοποιήθηκαν 4 
features. Το σύνολο των δεδομένων ήταν 150, εκ των οποίων το 30% χρησιμοποιήθηκε για testing.
Παρατηρήσαμε διακυμάνσεις του αποτελέσματος ανά τις διαφορετικές εκτελέσεις που πραγματοποιήθηκαν.
'''