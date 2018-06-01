# -*- coding: utf-8 -*-
"""
Created on Tue May 29 19:16:40 2018

@author: juanferna.perez
"""

from sklearn.datasets import load_iris
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import chi2
iris = load_iris()
X, y = iris.data, iris.target
print(X.shape)

selector = SelectKBest(chi2, k=2)
X_new = selector.fit_transform(X, y)
print(X_new.shape)
print(selector.get_support())

scores = chi2(X,y)
print(scores)



from sklearn.feature_selection import SelectPercentile
iris = load_iris()
X, y = iris.data, iris.target
X.shape

selector = SelectPercentile(chi2, percentile = 50)
X_new = selector.fit_transform(X, y)
X_new.shape
print(selector.get_support())

scores = chi2(X,y)
print(scores)
