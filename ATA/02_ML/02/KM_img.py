#%%
# Modified version of https://scikit-learn.org/stable/auto_examples/cluster/plot_color_quantization.html#sphx-glr-auto-examples-cluster-plot-color-quantization-py
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.datasets import load_sample_image
from sklearn.utils import shuffle
from time import time

n_colors = 2

def load_img(name="china.jpg"):
    return load_sample_image(name)

def convert_img(image):
    # Convert to floats instead of the default 8 bits integer coding. Dividing by
    # 255 is important so that plt.imshow behaves works well on float data (need to
    # be in the range [0-1])
    image = np.array(image, dtype=np.float64) / 255
    # Load Image and transform to a 2D numpy array.
    w, h, d = original_shape = tuple(image.shape)
    return np.reshape(image, (w * h, d)), w, h

def recreate_image(codebook, labels, w, h):
    # Recreate the (compressed) image
    return codebook[labels].reshape(w, h, -1)

image = load_img(name="flower.jpg")
image_array, w, h = convert_img(image)


print("Fitting model on a small sub-sample of the data")
t0 = time()
image_array_sample = shuffle(image_array, random_state=0, n_samples=1_000)
kmeans = KMeans(n_clusters=n_colors, random_state=0).fit(image_array_sample)
print(f"done in {time() - t0:0.3f}s.")

# Get labels for all points
print("Predicting color indices on the full image (k-means)")
t0 = time()
labels = kmeans.predict(image_array)
print(f"done in {time() - t0:0.3f}s.")


# Display all results, alongside original image
plt.figure(1)
plt.clf()
plt.axis('off')
plt.title('Original image (96,615 colors)')
plt.imshow(image)
plt.savefig("normal_img.svg", bbox_inches='tight')

plt.figure(2)
plt.clf()
plt.axis('off')
plt.title(f'Quantized image ({n_colors} colors, K-Means)')
plt.imshow(recreate_image(kmeans.cluster_centers_, labels, w, h))
plt.savefig("img" + str(n_colors) + ".svg", bbox_inches='tight')
