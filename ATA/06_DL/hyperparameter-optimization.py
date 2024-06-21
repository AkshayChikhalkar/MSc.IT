#%%
import numpy as np
from skopt import gp_minimize
from skopt.space import Real, Integer
from skopt.utils import use_named_args
from skopt.plots import plot_convergence

space  = [Integer(1, 20, name='degree')]

@use_named_args(space)
def objective(**params):
    print(params)
    # Add your code here
    return 1 # calculate MSE

res_gp = gp_minimize(objective, space, n_calls=50, random_state=0)

print("Best score: ", res_gp.fun)
print("best score: ", res_gp.fun)
print("best degree: ", res_gp.x[0])

plot_convergence(res_gp)
# add other plots
