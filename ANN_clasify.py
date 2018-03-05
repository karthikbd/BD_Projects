# -*- coding: utf-8 -*-
"""
Created on Tue Feb 27 15:36:39 2018

@author: Karthikeyan
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os

os.chdir('E:\\Internship\\Mobile phone classification')
# Importing the dataset
dataset = pd.read_csv('train.csv')
X = dataset.iloc[:,0:20].values
y = dataset.iloc[:, 20].values

## Encoding categorical data
# Encoding the Independent Variable
'''from sklearn.preprocessing import LabelEncoder, OneHotEncoder
labelencoder_X_1= LabelEncoder()
X[:, 1] = labelencoder_X_1.fit_transform(X[:, 1])
labelencoder_X_2= LabelEncoder()
X[:, 2] = labelencoder_X_2.fit_transform(X[:, 2])
onehotencoder = OneHotEncoder(categorical_features = [1])
X = onehotencoder.fit_transform(X).toarray()
X = X[:, 1:] '''
from sklearn.preprocessing import LabelEncoder, OneHotEncoder
encoder = LabelEncoder()
encoder.fit(y)
encoded_Y = encoder.transform(y)
type(encoded_Y)
# convert integers to dummy variables (i.e. one hot encoded)
from keras.utils import np_utils
dummy_y = np_utils.to_categorical(encoded_Y, num_classes = None)

# Splitting the dataset into the Training set and Test set
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, dummy_y, test_size = 0.2, random_state = 1)

# Feature Scaling
from sklearn.preprocessing import MinMaxScaler
sc = MinMaxScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

#import keras library
import keras 
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Dropout

#Initializing Ann
classifier = Sequential()

#Adding input layers and hidden layers
classifier.add(Dense(output_dim = 16, init = 'uniform', activation = 'relu', input_dim = 20 ))
classifier.add(Dropout(p = 0.1))
#Adding second hidden layers
classifier.add(Dense(output_dim = 8, init = 'uniform', activation = 'relu'))
classifier.add(Dropout(p = 0.1))
#Adding the output layer
classifier.add(Dense(output_dim = 4, activation = 'softmax'))

#compiling the ANN
classifier.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics = ['accuracy'] )

#Fit Ann to training set
classifier.fit(X_train, y_train, batch_size = 64, nb_epoch = 100)

# Fitting classifier to the Training set
# Create your classifier here

# Predicting the Test set results
y_pred = classifier.predict_classes(X_test)
classifier.evaluate(X_train, y_train)

y_test = np.argmax(y_test, axis = 1)

# Making the Confusion Matrix
from sklearn.metrics import classification_report,confusion_matrix
classification_report(y_test, y_pred)

