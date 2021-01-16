import pandas as pd
import numpy as np

def data_preproc(csv_file):
    df = pd.read_csv(csv_file)

    sLength = df['SepalLengthCm'].fillna(0.0).values.tolist()
    sWidth = df['SepalWidthCm'].fillna(0.0).values.tolist()
    pLength = df['PetalLengthCm'].fillna(0.0).values.tolist()
    pWidth = df['PetalWidthCm'].fillna(0.0).values.tolist()

    target = df['Species'].fillna(0.0).values.tolist()
    # get the values and transform them to lists for further pre process

    train = []
    for i in range(0,150):
        train.append([sLength[i],sWidth[i],pLength[i],pWidth[i]])  # make a 2 dimensional array with each array of arrays representing the features
    train = np.array(train)

    result=[]
    for item in target:
        if (item == 'Iris-setosa' ):
            result.append(1)
        elif (item == 'Iris-versicolor' ):
            result.append(2)
        else:
            result.append(3)
    return train, result  # return the train and the target....