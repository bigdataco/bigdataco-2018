# -*- coding: utf-8 -*-
"""
Created on Tue May 29 18:16:50 2018

@author: juanferna.perez
"""

from pandas import DataFrame
from sklearn.feature_selection import VarianceThreshold
from sklearn import datasets
iris = datasets.load_iris()
X = iris.data
Xdf= DataFrame(X)
print(Xdf.describe())
print(Xdf.var(ddof=0))

selector = VarianceThreshold(threshold=(0.8*0.8 ))
selector.fit(X)
print(selector.get_support())

Xbar = selector.transform(X)
print(Xbar)



