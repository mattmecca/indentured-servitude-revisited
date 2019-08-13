#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May 5 16:38:42 2018

@author: MattMecca
"""

from clust_funcs import *

## Importing the Dataset ##

dataset = pd.read_csv(
    "/Users/MattMecca/Documents/Graduate School/4th Semester Courses/Master's Thesis/Data Folder/SubSLD_data.csv")

# This had to be done piecemeal, could not be put into a loop 

################################# 1994 Simulation #############################

year = 1994
X = data_select(dataset, year)

### K-means Clustering ###
elbow_method(X, year=year)
clust_viz(X, year=year, n_clusters=3, clust_method='kmeans')

### Hierarchical Clustering ###
dendro_graph(X, year)
clust_viz(X, year=year, n_clusters=3, clust_method='hc')


################################# 2001 Simulation #############################

year = 2001
X = data_select(dataset, year)

### K-means Clustering ###
elbow_method(X, year=year)
clust_viz(X, year=year, n_clusters=3, clust_method='kmeans')

### Hierarchical Clustering ###
dendro_graph(X, year)
clust_viz(X, year=year, n_clusters=3, clust_method='hc')


################################# 2009 Simulation #############################

year = 2009
X = data_select(dataset, year)

### K-means Clustering ###
elbow_method(X, year=year)
# Only time we go with 4 clusters
clust_viz(X, year=year, n_clusters=4, clust_method='kmeans')

### Hierarchical Clustering ###
dendro_graph(X, year)
clust_viz(X, year=year, n_clusters=3, clust_method='hc')
