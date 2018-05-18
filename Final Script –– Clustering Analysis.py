#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May 5 16:38:42 2018

@author: MattMecca
"""


#### K-Means Clustering ####


## Importing the Libraries ##

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


## Importing the Null Dataset with Pandas ##

dataset = pd.read_csv("/Users/MattMecca/Documents/Graduate School/4th Semester Courses/Master's Thesis/Data Folder/SubSLD_data.csv")
X = dataset.iloc[:, [2, 3]].values 

############################### 1994 Simulation ###############################

## Using the Elbow Method to find the Optimal Number of Clusters ##

from sklearn.cluster import KMeans 
wcss = []
for i in range(1, 11):
    kmeans = KMeans(n_clusters = i, init = 'k-means++', max_iter = 300, n_init = 10, random_state = 0) 
    
    kmeans.fit(X_1) 
    wcss.append(kmeans.inertia_) 
    

## Plotting the Elbow Method Graph ##

plt.plot(range(1, 11), wcss)
plt.title('The Elbow Method (1994)')
plt.xlabel('Number of Clusters')
plt.ylabel('WCSS')
plt.show


## Applying K-Means to the 1994 Dataset ##

kmeans = KMeans(n_clusters = 2, init = 'k-means++', max_iter = 300, n_init = 10, random_state = 0)
y_kmeans = kmeans.fit_predict(X) 


## Viscualizing the Clusters ##

plt.scatter(X[y_kmeans == 0, 0], X[y_kmeans == 0, 1], s = 100, c = 'red', label = 'Cluster 1') 
plt.scatter(X[y_kmeans == 1, 0], X[y_kmeans == 1, 1], s = 100, c = 'blue', label = 'Cluster 2') 
plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], s = 300, c = 'yellow', label = 'Centroids')

plt.title('Clusters of Borrowers')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend()
plt.show()


## Labeling the Clusters by 1994 Borrower's Perceived Types ##

plt.scatter(X[y_kmeans == 0, 0], X[y_kmeans == 0, 1], s = 100, c = 'red', label = 'Reasonable') 
plt.scatter(X[y_kmeans == 1, 0], X[y_kmeans == 1, 1], s = 100, c = 'blue', label = 'Overly Optimistic') 
plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], s = 300, c = 'yellow', label = 'Centroids')

plt.title('Clusters of Borrowers (1994)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend()
plt.show()


############################### 2001 Simulation ###############################

X = dataset.iloc[:, [5, 6]].values 

from sklearn.cluster import KMeans 
wcss = []
for i in range(1, 11):
    kmeans = KMeans(n_clusters = i, init = 'k-means++', max_iter = 300, n_init = 10, random_state = 0) 
    
    kmeans.fit(X_1) 
    wcss.append(kmeans.inertia_) 
    
## Plotting the Elbow Method Graph ##

plt.plot(range(1, 11), wcss)
plt.title('The Elbow Method (2001)')
plt.xlabel('Number of Clusters')
plt.ylabel('WCSS')
plt.show

## Applying K-Means to the 2001 Dataset ##

kmeans = KMeans(n_clusters = 2, init = 'k-means++', max_iter = 300, n_init = 10, random_state = 0)
y_kmeans = kmeans.fit_predict(X) 


## Visualizing the 2001 Clusters ##

plt.scatter(X[y_kmeans == 0, 0], X[y_kmeans == 0, 1], s = 100, c = 'red', label = 'Cluster 1') 
plt.scatter(X[y_kmeans == 1, 0], X[y_kmeans == 1, 1], s = 100, c = 'blue', label = 'Cluster 2') 
plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], s = 300, c = 'yellow', label = 'Centroids')

plt.title('Clusters of Borrowers (2001)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend() 
plt.show()


## Labeling the Clusters by 2001 Borrower's Perceived Types ##

plt.scatter(X[y_kmeans == 0, 0], X[y_kmeans == 0, 1], s = 100, c = 'red', label = 'Reasonable') 
plt.scatter(X[y_kmeans == 1, 0], X[y_kmeans == 1, 1], s = 100, c = 'blue', label = 'Overly Optimistic') 

plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], s = 300, c = 'yellow', label = 'Centroids')

plt.title('Clusters of Borrowers (2001)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend()
plt.show()



############################## 2009 Simulation ################################

X = dataset.iloc[:, [8, 9]].values 

## Visualizing the 2009 Clusters ##

from sklearn.cluster import KMeans 
wcss = []
for i in range(1, 11): 
    kmeans = KMeans(n_clusters = i, init = 'k-means++', max_iter = 300, n_init = 10, random_state = 0) 
    
    kmeans.fit(X_1) 
    wcss.append(kmeans.inertia_)
    
## Plotting the Elbow Method Graph ##

plt.plot(range(1, 11), wcss)
plt.title('The Elbow Method (2009)')
plt.xlabel('Number of Clusters')
plt.ylabel('WCSS')
plt.show

## Applying K-Means to the 2009 Dataset ##

kmeans = KMeans(n_clusters = 2, init = 'k-means++', max_iter = 300, n_init = 10, random_state = 0)
y_kmeans = kmeans.fit_predict(X) 

## Visualizing the 2009 Clusters ##

plt.scatter(X[y_kmeans == 0, 0], X[y_kmeans == 0, 1], s = 100, c = 'blue', label = 'Cluster 1') 
plt.scatter(X[y_kmeans == 1, 0], X[y_kmeans == 1, 1], s = 100, c = 'red', label = 'Cluster 2') 

plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], s = 300, c = 'yellow', label = 'Centroids')


plt.title('Clusters of Borrowers (2009)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend() 
plt.show()


## Labeling the Clusters by 2009 Borrower's Perceived Types ##

plt.scatter(X[y_kmeans == 0, 0], X[y_kmeans == 0, 1], s = 100, c = 'blue', label = 'Overly Optimistic') 
plt.scatter(X[y_kmeans == 1, 0], X[y_kmeans == 1, 1], s = 100, c = 'red', label = 'Reasonable') 

plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], s = 300, c = 'yellow', label = 'Centroids')

plt.title('Clusters of Borrowers (2009)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend()
plt.show()



###############################################################################
############################# Hierarchical Clustering #########################
###############################################################################

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat May 5 16:38:42 2018

@author: MattMecca
"""

################################# 1994 Simulation #############################


X = dataset.iloc[:, [2, 3]].values 


## Using the Dendrogram to find the Optimal # of Clusters ##

import scipy.cluster.hierarchy as sch 
dendrogram = sch.dendrogram(sch.linkage(X, method = 'ward')) 
plt.title('Dendrogram (1994)')
plt.xlabel('Borrowers')
plt.ylabel('Euclidean distances')
plt.show() 


## Fitting Hierarchical Clustering to the Mall Dataset ## 

from sklearn.cluster import AgglomerativeClustering 
hc = AgglomerativeClustering(n_clusters = 5, affinity = 'euclidean', linkage = 'ward')
y_hc = hc.fit_predict(X) 


## Visualizing the Clusters - Step 4 ##


plt.scatter(X[y_hc == 0, 0], X[y_hc == 0, 1], s = 100, c = 'red', label = 'Cluster 2') 
plt.scatter(X[y_hc == 1, 0], X[y_hc == 1, 1], s = 100, c = 'blue', label = 'Cluster 1') 

plt.title('Clusters of Clients (1994)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend() # Gives us a legend of the diff. LABELS
plt.show()


## Analyzing and Renaming the Clusters ##

plt.scatter(X[y_hc == 0, 0], X[y_hc == 0, 1], s = 100, c = 'red', label = 'Overly Optimistic') 
plt.scatter(X[y_hc == 1, 0], X[y_hc == 1, 1], s = 100, c = 'blue', label = 'Reasonable') 

plt.title('Clusters of Clients (1994)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend() 
plt.show()



################################# 2001 Simulation #############################


X = dataset.iloc[:, [5, 6]].values 


## Using the Dendrogram to find the Optimal # of Clusters ##

import scipy.cluster.hierarchy as sch 
dendrogram = sch.dendrogram(sch.linkage(X, method = 'ward')) 
plt.title('Dendrogram (2001)')
plt.xlabel('Borrowers')
plt.ylabel('Euclidean distances')
plt.show() 


## Fitting Hierarchical Clustering to the Mall Dataset ## 

from sklearn.cluster import AgglomerativeClustering 
hc = AgglomerativeClustering(n_clusters = 5, affinity = 'euclidean', linkage = 'ward')
y_hc = hc.fit_predict(X) 



## Visualizing the Clusters  ##


plt.scatter(X[y_hc == 0, 0], X[y_hc == 0, 1], s = 100, c = 'blue', label = 'Cluster 2') 
plt.scatter(X[y_hc == 1, 0], X[y_hc == 1, 1], s = 100, c = 'red', label = 'Cluster 1') 

plt.title('Clusters of Clients (2001)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend() 
plt.show()


## Analyzing and Renaming the Clusters ##

plt.scatter(X[y_hc == 0, 0], X[y_hc == 0, 1], s = 100, c = 'blue', label = 'Overly Optimistic') 
plt.scatter(X[y_hc == 1, 0], X[y_hc == 1, 1], s = 100, c = 'red', label = 'Reasonable') 

plt.title('Clusters of Clients (2001)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend() 
plt.show()



################################# 2009 Simulation #############################


X = dataset.iloc[:, [8, 9]].values 


## Using the Dendrogram to find the Optimal # of Clusters ##

import scipy.cluster.hierarchy as sch 
dendrogram = sch.dendrogram(sch.linkage(X, method = 'ward')) 
plt.title('Dendrogram (2009)')
plt.xlabel('Borrowers')
plt.ylabel('Euclidean distances')
plt.show() 


## Fitting Hierarchical Clustering to the Mall Dataset ## 

from sklearn.cluster import AgglomerativeClustering 
hc = AgglomerativeClustering(n_clusters = 5, affinity = 'euclidean', linkage = 'ward')
y_hc = hc.fit_predict(X) 


## Visualizing the Clusters ##


plt.scatter(X[y_hc == 0, 0], X[y_hc == 0, 1], s = 100, c = 'blue', label = 'Cluster 2') 
plt.scatter(X[y_hc == 1, 0], X[y_hc == 1, 1], s = 100, c = 'red', label = 'Cluster 1') 

plt.title('Clusters of Clients (2009)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend()
plt.show()


## Analyzing and Renaming the Clusters ##

plt.scatter(X[y_hc == 0, 0], X[y_hc == 0, 1], s = 100, c = 'blue', label = 'Overly Optimistic') 
plt.scatter(X[y_hc == 1, 0], X[y_hc == 1, 1], s = 100, c = 'red', label = 'Reasonable') 

plt.title('Clusters of Clients (2009)')
plt.xlabel('Loans Borrowed')
plt.ylabel('Annual Income ($)')
plt.legend() 
plt.show()

