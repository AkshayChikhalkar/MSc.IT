#%%
import numpy as np
from deap import benchmarks
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from smt.sampling_methods import LHS
from sklearn.metrics import mean_squared_error
from sklearn.gaussian_process import GaussianProcessRegressor
from skopt.acquisition import gaussian_ei
from matplotlib import pyplot as plt
from skopt import gp_minimize
import matplotlib.ticker as ticker
import matplotlib
from skopt.plots import plot_convergence
from skopt.plots import plot_gaussian_process
matplotlib.rcParams.update({'font.size': 16})

def sampleX(dim, samples, min, max):
    ranges = []
    for i in range(0, dim):
        ranges.append([min, max])

    xlimits = np.array(ranges)
    sampling = LHS(xlimits=xlimits)
    ret = sampling(samples)
    return ret

def eval_func(sol):
    return benchmarks.griewank(sol)[0]

def plot(x_pred, y_pred, x_obs, y_obs, new, sigma):
    plt.figure(figsize=(10, 5))
    plt.plot(x_obs, y_obs, "r.", markersize=10, label="Observations")
    plt.plot(x_pred, y_pred, "b-", label="Prediction (mean)")
    plt.fill(
        np.concatenate([x_pred, x_pred[::-1]]),
        np.concatenate([y_pred - 1.9600 * sigma, (y_pred + 1.9600 * sigma)[::-1]]),
        alpha=0.5,
        fc="yellow",
        ec="None",
        label="95% confidence interval",
    )

    plt.axvline(x=new, ymin=0, linewidth=2)
    plt.axhline(y=0.0, color="red")
    plt.legend(loc="upper right")
    ax = plt.gca()
    ax.xaxis.set_major_locator(ticker.MultipleLocator(1))
    ax.set_ylim([-0.1, 0.5])
    plt.xlabel("Degree")
    plt.ylabel("MSE")
    plt.show()

#term_crit = 0.01
x_min = 1
x_max = 20

x_train = sampleX(1, 10000, x_min, x_max)
y_train = [eval_func(x_i) for x_i in x_train]

def polynomial(degree, x_train=x_train, y_train=y_train):
    int_degree = int(degree[0])
    polyFeatures = PolynomialFeatures(int_degree, interaction_only=False)
    x_poly = polyFeatures.fit_transform(x_train)
    regressor = LinearRegression(n_jobs=-1)
    regressor.fit(x_poly, y_train)
    y_pred = regressor.predict(x_poly)
    mse = mean_squared_error(y_train, y_pred)
    return mse

# not optimized
x = []
y = []
for i in range(x_min, x_max + 1):
    x.append(i)
    y.append(polynomial([i]))

fig = plt.figure(figsize = (10, 5))
plt.bar(x, y, width = 0.4)
ax = plt.gca()
ax.xaxis.set_major_locator(ticker.MultipleLocator(1))
ax.set_ylim([0.0, 0.5])
plt.xlabel("Degree")
plt.ylabel("MSE")
plt.show()

# Optimization: use fewer steps than not optimized :)
x_obs = []
y_obs = []

# 1. evaluate
x_obs.append([x_min])
y_obs.append(polynomial([x_min]))

# 2. evaluate
x_obs.append([x_max])
y_obs.append(polynomial([x_max]))

n_calls = 4

res = gp_minimize(polynomial, [(x_min,x_max)], acq_func = "EI",  n_calls = n_calls, random_state = 123, noise = 1e-10, x0 = x_obs, y0 = y_obs, n_initial_points=0, acq_optimizer="sampling")
#plot_convergence(res);
print("List of X values tried : {}".format(res.x_iters))
print("List of Y values : {}".format(res.func_vals))
print("Minimum x : ", res.x)
print("Minimum f(x) : ", res.fun)
#print(res)

for n_iter in range(1, n_calls + 1):
    # Plot true function.
    #plt.subplot(5, 2, 2*n_iter+1)

    if n_iter == 1:
        show_legend = True
    else:
        show_legend = False
    plt.figure(figsize = (10, 5))
    ax = plot_gaussian_process(res, n_calls=n_iter,
                               objective=polynomial,
                               show_legend=True, show_title=False,
                               show_next_point=True, show_acq_func=False)
    ax.set_ylim([-0.1, 0.5])
    ax.xaxis.set_major_locator(ticker.MultipleLocator(1))
    plt.axhline(y=0.0, color="red")
    plt.legend(loc="upper right")
    ax.grid()
    ax.set_ylabel("MSE")
    ax.set_xlabel("Degree")
    plt.show()











#for i in range(x_min, x_max):
#    gp = GaussianProcessRegressor()
#    gp.fit(np.array(x_obs, dtype=object), np.array(y_obs, dtype=object))

#    x_pred = np.atleast_2d(np.linspace(x_min, x_max, 1000)).T
#    y_pred, sigma = gp.predict(x_pred, return_std=True)

#    x_acq = np.expand_dims(np.linspace(x_min, x_max, 100), 1)
#    y_opt = np.min(y_pred)

 #   acq = gaussian_ei(x_acq, gp, y_opt = np.min(y_pred))
 #   max = np.argmax(acq)
 #   new_degree = int(np.round(x_acq[max]))

        
 #   plot(x_pred, y_pred, x_obs, y_obs, new_degree,sigma)

 #   x_obs.append([new_degree])
 #   y_obs.append(polynomial(new_degree, x_train, y_train))
#
#    if polynomial(new_degree, x_train, y_train) < term_crit: 
#        print("Stopped after ", i, " steps with termination criterion MSE < ", term_crit)
#        break;  

# %%
