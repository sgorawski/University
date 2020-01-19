import numpy as np
from scipy.spatial import distance_matrix
from sklearn.metrics import silhouette_score


def dunn_index(X, labels):
    targets = np.unique(labels)
    
    def min_intercluster_dist(centroids):
        dists = distance_matrix(centroids, centroids)
        masked = np.ma.masked_equal(dists, 0, False)
        return np.min(masked)
    
    def max_dist_in_cluster(cluster):
        dists = distance_matrix(cluster, cluster)
        return np.max(dists)
    
    clusters = [X[labels == k] for k in targets]
    centroids = np.vstack(np.mean(c, axis=0) for c in clusters)
    return (
        min_intercluster_dist(centroids)
        / max(max_dist_in_cluster(c) for c in clusters)
    )


def davies_bouldin_index(X, labels):
    targets = np.unique(labels)
    clusters = [X[labels == k] for k in targets]
    centroids = np.vstack(np.mean(c, axis=0) for c in clusters)

    def in_cluster_scattering(cluster, centroid):
        radius_sq = np.sum((cluster - centroid) ** 2)
        return np.sqrt(radius_sq / len(cluster))
    
    def intercluster_distance(centroid1, centroid2):
        return np.linalg.norm(centroid1 - centroid2)
    
    def R(i, j):
        return ((
                in_cluster_scattering(clusters[i], centroids[i])
                + in_cluster_scattering(clusters[j], centroids[j])
            ) / intercluster_distance(centroids[i], centroids[j])
        )
    
    def D(i):
        return max(R(i, j) for j in targets if j != i)

    return sum(D(i) for i in targets) / len(targets)


def get_all(X, labels):
    methods = {
        'Silhouette Coefficient': silhouette_score,
        'Dunn Index': dunn_index,
        'Davies-Bouldin Index': davies_bouldin_index,
    }
    return {name: method(X, labels) for name, method in methods.items()}
