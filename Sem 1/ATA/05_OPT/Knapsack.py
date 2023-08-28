# conda install -c conda-forge pyomo
# conda install -c conda-forge ipopt glpk
#%%
from pyomo.environ import *

v = {'hammer':8, 'wrench':3, 'screwdriver':6, 'towel':11}
w = {'hammer':5, 'wrench':7, 'screwdriver':4, 'towel':3}

limit = 14

model = ConcreteModel()
model.elements = Set(initialize = v.keys())
model.x = Var(model.elements, within = Binary)
model.value = Objective(expr=sum(v[i]*model.x[i] for i in model.elements), sense=maximize)
model.weight = Constraint(expr=sum(w[i]*model.x[i] for i in model.elements) <= limit)

opt = SolverFactory('glpk')
results = opt.solve(model, tee=True)

for i in model.x:
  print(model.x[i], model.x[i].value)

model.display()