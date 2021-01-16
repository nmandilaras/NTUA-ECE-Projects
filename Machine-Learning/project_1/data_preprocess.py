import pandas as pd


def data_preproc(csv_file):
    df = pd.read_csv(csv_file)

    feature = df['LotArea'].fillna(0.0).values.tolist()
    target = df['SalePrice'].fillna(0.0).values.tolist()
    # get the values and transform them to lists for further pre process

    feature = map(float, feature)
    target = map(float, target)

    train = []
    for item in feature:
        train.append([item])  # make a 2 dimensional array with each array of arrays representing the features

    return train, target  # return the train and the target....
