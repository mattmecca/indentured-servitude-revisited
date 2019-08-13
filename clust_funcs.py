#### Modules Used ####

import os, inspect

from sklearn.cluster import AgglomerativeClustering
import scipy.cluster.hierarchy as sch
from sklearn.cluster import KMeans

import random
import numpy as np

import matplotlib.pyplot as plt
from matplotlib.pyplot import cm

import pandas as pd
plt.style.use("ggplot")


################################# K-means Clustering #############################

def data_select(dataset, year):
    X = dataset[['Loan_' + str(year), 'Income_' + str(year)]]  # .values
    return X


def elbow_method(X, year, x_lab='Number of Clusters', poss_clusts=11):
    wcss = []
    for i in range(1, poss_clusts):
        kmeans = KMeans(n_clusters=i, init='k-means++',
                        max_iter=300, n_init=10, random_state=0)
        kmeans.fit(X)
        wcss.append(kmeans.inertia_)

    ## Plotting the Elbow Method Graph ##

    plt.plot(range(1, poss_clusts), wcss)
    plt.title('The Elbow Method ({})'.format(str(year)))
    plt.xlabel(x_lab + ' –– ' + str(year))
    plt.ylabel('WCSS')
    plt.show()


def clust_viz(X, year, n_clusters, clust_method='kmeans', x_lab='Loans Borrowed', y_lab='Income'):

    if clust_method == 'kmeans':
        kmeans = KMeans(n_clusters=n_clusters, init='k-means++',
                        max_iter=300, n_init=10, random_state=0)
        clust_df = kmeans.fit_predict(X)

    else:
        hc = AgglomerativeClustering(
            n_clusters=n_clusters, affinity='euclidean', linkage='ward')
        clust_df = hc.fit_predict(X)

    names = ['Optimal', 'Reasonable', 'Risky', 'Unreasonable']
    # Needed to get the clusters in appropriate order for labeling
    order = [x[1] for x in sorted([(np.mean(X.iloc[clust_df == clust_num, 1]), clust_num)
            for clust_num in range(n_clusters)], reverse = True)]

    for clust_num, name, col in zip(order, names[:n_clusters], cm.rainbow(np.linspace(0, 1, n_clusters))):
        plt.scatter(X.iloc[clust_df == clust_num, 0], X.iloc[clust_df == clust_num, 1],
            s=100, c=col, label=name)
        if (clust_num == order[-1]) & (clust_method == 'kmeans'):
            plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[
                :, 1], s=300, c='yellow', label='Centroids')
        legend = plt.legend()
        plt.setp(legend.get_texts(), color='black')
        plt.title('Clusters of Borrowers –– {}'.format(year))
        plt.xlabel(x_lab)
        plt.ylabel(y_lab)


################################# Hierarchical Clustering #############################

def dendro_graph(X, year):

    sch.dendrogram(sch.linkage(X, method='ward'))
    plt.title('Dendrogram ({})'.format(year))
    plt.xlabel('Borrowers')
    plt.xticks([])
    plt.ylabel('Euclidean distance')
    plt.show()
