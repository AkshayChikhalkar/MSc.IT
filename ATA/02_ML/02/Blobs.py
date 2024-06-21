
#%%
import matplotlib.pyplot as plt
import numpy as np
import matplotlib

from sklearn.datasets import make_blobs
from sklearn.cluster import KMeans

matplotlib.rcParams.update({'font.size': 22, 'font.family': 'Arial', 'axes.titlesize': '22'})

def plot_clusters(X, clusters=None, centers=None, name="normal"):
    fig, ax = plt.subplots(figsize=(12, 8))
    plt.scatter(X[:, 0], X[:, 1], c=clusters, s=20)
    if np.any(centers):
        plt.scatter(centers[:, 0], centers[:, 1], marker="x", linewidths=1, color="r")
    
    plt.savefig(name + ".svg", bbox_inches='tight')
    plt.show()

X, y = make_blobs(n_samples=1000, centers=3)

kmeans = KMeans(n_clusters=5)
m = kmeans.fit(X)
# Sum of squared distances of samples to their closest cluster center, weighted by the sample weights if provided.
print(m.inertia_)

clusters = kmeans.predict(X)
centers = kmeans.cluster_centers_
plot_clusters(X)
plot_clusters(X, clusters=clusters, centers=centers, name="solution")