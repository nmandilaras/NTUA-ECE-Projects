# -*- coding: utf-8 -*-
from data_preprocess import data_preproc
import matplotlib.pyplot as plt
from sklearn.svm import SVR
from sklearn.metrics import mean_squared_error
from sklearn.cross_validation import train_test_split
from sklearn import linear_model

train, target = data_preproc('train.csv')   # call the preprocessing function

x_train, x_test , y_train, y_test = train_test_split(train, target, test_size=.5) # we split our data in two sets for training and testing we keep 50% for testing

svr_rbf= SVR(kernel='rbf',C=1e3, gamma=0.1) # we are going to use and compare different kernel options
svr_lin = SVR(kernel='linear')
#svr_poly = SVR(kernel='poly')

svr_rbf.fit(x_train,y_train)
svr_lin.fit(x_train,y_train)
#svr_poly.fit(x_train,y_train)

predictions_rbf = svr_rbf.predict(x_test)
predictions_lin = svr_lin.predict(x_test)
#predictions_poly = svr_poly.predict(x_test)

reg = linear_model.LinearRegression() # we check also the accuracy of linear regression
reg.fit(x_train,y_train)
predictions_reg = reg.predict(x_test)

lw = 2
plt.scatter(x_test, y_test, color='darkorange', label='data')
plt.hold('on')
plt.plot(x_test, predictions_rbf, color='navy', lw=lw, label='RBF model')
plt.plot(x_test, predictions_lin, color='c', lw=lw, label='SVR Linear model')
#plt.plot(x_test, predictions_poly, color='r', lw=lw, label='Polynomial model')
plt.plot(x_test, predictions_reg, color='cornflowerblue', lw=lw, label='Linear Reg model')
plt.xlabel('data')
plt.ylabel('target')
plt.title('Support Vector Regression')
plt.legend()
plt.show()

#print "squared error... : " + str(mean_squared_error(y_test, predictions_rbf))
results= []
results.append(mean_squared_error(y_test, predictions_rbf))
results.append(mean_squared_error(y_test, predictions_lin))
#results.append(mean_squared_error(y_test, predictions_poly))
results.append(mean_squared_error(y_test, predictions_reg))
#print results[0]

plt.bar(1,results[0],label='svr_rbf', color='navy')
plt.bar(2,results[1],label='svr_lin', color='c')
#plt.bar(3,results[2],label='svr_poly', color='r')
plt.bar(3,results[2],label='lin_reg', color='cornflowerblue')

plt.xlabel('x')
plt.ylabel('MeanSquaredError')
plt.title('Comparing accuracy')
plt.legend()
plt.show()

plt.scatter(train, target)  # visualization code- we observe that the vast majority of samples has x<=50000 and y<=500000 we are going to use only those data for training to see if we can achieve better score
plt.axvline(x=50000)
plt.axhline(y=500000)
plt.xlabel('data')
plt.ylabel('target')
plt.show()

x_new = []
y_new = []
for i in range(len(x_train)):
    if x_train[i][0] < 50000 and y_train[i]<500000:
        x_new.append(x_train[i])
        y_new.append(y_train[i])

# we are going to find now the method with the minimum error and train it with the reduced training set.
reg_two = linear_model.LinearRegression()
reg_two.fit(x_new,y_new)
predictions_reg_two = reg_two.predict(x_test)

plt.bar(1,results[2],label='lin_reg', color='cornflowerblue')
plt.bar(2,mean_squared_error(y_test, predictions_reg_two),label='lin_reg_reduced', color='red')

plt.xlabel('x')
plt.ylabel('MeanSquaredError')
plt.title('Comparing accuracy')
plt.legend()
plt.show()

'''
Παρατηρούμε ότι το αποτέλεσμα επηρεάζεται από το στοιχείο τυχαιότητας που έχει η split function κατά τη διαμόρφωση των train και test set.

Κατά κύριο λόγο υπάρχουν κάποια δεδομένα διάσπαρτα έξω από τα όρια που έχουμε ορίσει για τα χ και y. Σε αυτά τα σημεία οι καμπύλες θα προσαρμοστούν ανάλογα
με το ποια από αυτά τα σημεία θα βρεθούν στο training set. Καθώς δεν υπάρχει κάποια κανονικότητα τα αντίστοιχα σημεία που παρέμειναν στο testing set
παρουσιάζουν μεγάλη απόκλιση από την καμπύλη και καθώς οι τιμές με τις οποίες ασχολούμαστε είναι ήδη μεγάλες και το mean squared error προκύπτει αρκετά μεγάλο επίσης.
Επίσης στην περιοχή όπου συγκεντρώνονται τα περισσότερα δεδομένα και πάλι υπάρχει σαφής απόκλιση των δεδομένων με αποτέλεσμα οι καμπύλες μας να ακολουθούν μια μέση 
περίπτωση. 

Γενικά παρατηρούμε, με πολλές εκτελέσεις αυτού του script, πως η μέθοδος Linear Regression έχει χαμηλότερο error.Οπότε την εκπαιδεύουμε με το redused set για να δούμε
αν υπάρχει βελτίωση του error που όμως κάτι τέτοιο διαφέρει από εκτέλεση σε εκτέλεση.

'''