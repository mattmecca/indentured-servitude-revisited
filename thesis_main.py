#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May 5 16:38:42 2018

@author: MattMecca
"""

##### Modules used #####

import pandas as pd

from miscellaneous import *
from ts_prepping import *
from clust_funcs import *

data = pd.read_csv("~/Documents/Graduate School/4th Semester Courses/Master's Thesis/Data Folder/Panel Data, R Format.csv")
data.columns = [col.lower() for col in data.columns]
data = data.dropna().reset_index(drop=True)

unitroot_test_df = unitroot_df_gen(data)
#### There's no panel unit root tests in Python, and so we're going to need to use R

first_char_id, comp_type, script_dir = comp_identifier()
unitroot_test_df.to_csv(script_dir + '/unitroot_test_df.csv', index=False)

#################################################################################################
################################### Preliminary TS Tests ########################################
#################################################################################################

subprocess_call(script='unit_root_test.R',
                script_dir=script_dir)

# High school graduation rate, as we might expect, is the only stationary time series. Meaning
# we need to difference what remains.

unitroot_test_df = col_diffing(unitroot_test_df)


#################################################################################################
######################################### Modeling ##############################################
#################################################################################################

# R has good panel model libraries. It also has libraries that are good for
# splines.

panel_data = panel_df_gen(unitroot_test_df)

panel_data.to_csv((script_dir + '/panel_data.csv'), index=False)

subprocess_call(script='modeling.R',
                script_dir=script_dir)


#################################################################################################
################################### Clustering Analysis #########################################
#################################################################################################


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
