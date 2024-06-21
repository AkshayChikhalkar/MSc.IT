# conda install -c conda-forge pyomo
# conda install -c conda-forge ipopt glpk
#%%
from pyomo.environ import *
item=10
v = {'hammer':8, 'wrench':3, 'screwdriver':6, 'towel':11}
w = {'hammer':5, 'wrench':7, 'screwdriver':4, 'towel':3}


limit = 14

model = ConcreteModel()
model.name= "Akshay"
model.elements = Set(initialize = v.keys())
model.x = Var(model.elements, within = Binary)
model.value = Objective(expr=sum(v[i]*model.x[i] for i in model.elements), sense=maximize)
model.weight = Constraint(expr=sum(w[i]*model.x[i] for i in model.elements) <= limit)

opt = SolverFactory('glpk')
results = opt.solve(model, tee=True)

for i in model.x:
  print(model.x[i], model.x[i].value)

model.display()
# %%
import matplotlib.pyplot as plt
from random import sample
import random
import time
import string  
import secrets
import matplotlib.pyplot as plt
import pyomo
from pyomo.environ import *
from timeit import timeit
import numpy as np
x = np.array([0, 2, 3, 4, 5])
y = np.power(x, 2) # Effectively y = x**2
e = np.array([1.5, 2.6, 3.7, 4.6, 5.5])

plt.errorbar(x, y, e, linestyle='None', marker='.')

plt.show()
# %%
