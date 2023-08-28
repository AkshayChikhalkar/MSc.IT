#%%
import numpy as np 
      
def a(x):
    return 1 / (1 + np.exp(-x))

def ad(x):
    return x * (1 - x)

def feedforward(x, w1, w2):
    l1 = a(np.dot(x, w1))
    l2 = a(np.dot(l1, w2))
    return l1, l2
        
def backpropagation(w1, w2, l1, l2, y):
    d2 = np.dot(l1.T, 2*(y - l2) * ad(l2))
    d1 = np.dot(x.T, np.dot( 2 * (y - l2) * ad(l2), w2.T) * ad(l1))
    return w1 + d1, w2 + d2

x = np.array(([0, 0, 1], [0, 1, 1], [1, 0, 1], [1, 1, 1]), dtype=float)
y = np.array(([0], [1], [1], [0]), dtype=float)

w1 = np.random.rand(3, 4)
w2 = np.random.rand(4, 1)

for i in range(1500):
    l1, l2 = feedforward(x, w1, w2)
    if i % 100 == 0: 
        print(i, "MSE: ", np.mean(np.square(y - l2)))
    w1, w2 = backpropagation(w1, w2, l1, l2, y)
# %%
