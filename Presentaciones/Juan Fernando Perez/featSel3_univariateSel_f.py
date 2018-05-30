# -*- coding: utf-8 -*-
"""
Created on Tue May 29 19:16:40 2018

@author: juanferna.perez
"""

from sklearn.datasets import load_iris
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_classif
iris = load_iris()
X, y = iris.data, iris.target
print(X.shape)

scores = f_classif(X,y)
print(scores)

selector = SelectKBest(f_classif, k=2)
X_new = selector.fit_transform(X, y)
print(X_new.shape)
print(selector.get_support())




