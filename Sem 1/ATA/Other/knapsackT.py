
#%%

import matplotlib.pyplot as plt
from random import sample
import time


# conda install -c conda-forge pyomo
# conda install -c conda-forge ipopt glpk
from pyomo.environ import *
from timeit import timeit


#value
v = {'hammer':8, 'wrench':3, 'screwdriver':6, 'towel':11, 'Scissor':2, 'precision screwdriver':6, ' hand towel':11}
#weight
w = {'hammer':5, 'wrench':7, 'screwdriver':4, 'towel':3, 'Scissor':3, 'precision screwdriver':6, ' hand towel':11}



def generator(size):
    for value in v,w:
        limit = 14
        model = ConcreteModel()
        model.elements = Set(initialize = v.keys())
        model.x = Var(model.elements, within = Binary)
        model.value = Objective(expr=sum(v[i]*model.x[i] for i in model.elements), sense=maximize)
        model.weight = Constraint(expr=sum(w[i]*model.x[i] for i in model.elements) <= limit)
    return model
  



opt = SolverFactory('glpk')

for s in range (50,100):
   model =generator(s)
   for i in range (1,100):
       time1 = time.time()
       results = opt.solve(model, tee=True)
       time2 = time.time()
       t=time2-time1


for i in model.x:
    print(model.x[i], model.x[i].value)

model.display()





# %%
