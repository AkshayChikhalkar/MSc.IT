#%%
# Modified version of https://deap.readthedocs.io/en/master/examples/gp_symbreg.html
import operator
import random
import numpy as np
import math

import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error

from deap import algorithms
from deap import base
from deap import creator
from deap import tools
from deap import gp
from deap import benchmarks

def eval_func(sol):
    return benchmarks.griewank(sol)[0]

def plot2d(x,y, fileName=""):
    fig, ax = plt.subplots(figsize=(12, 8))
    ax.plot(x,y, color='red')
    ax.grid()
    ax.set_xbound(lower=-10, upper=10)
    ax.yaxis.grid(color='black', linestyle='dotted')
    ax.xaxis.grid(color='black', linestyle='dotted')
    fig.tight_layout()
    plt.savefig(fileName + ".svg", bbox_inches='tight')
    plt.show()

def evalSymbReg(individual, points):
    func = toolbox.compile(expr=individual)
    y_true = [eval_func(np.array([x_i])) for x_i in points]
    y_pred = [func(x) for x in points]
    mse = mean_squared_error(y_true, y_pred)
    return mse,

# Configuration
pset = gp.PrimitiveSet("MAIN", 1)
pset.addPrimitive(operator.add, 2)
pset.addPrimitive(operator.sub, 2)
pset.addPrimitive(operator.mul, 2)
pset.addPrimitive(operator.neg, 1)
pset.addPrimitive(math.sin, 1)
pset.addPrimitive(math.cos, 1)
pset.renameArguments(ARG0='x')

creator.create("FitnessMin", base.Fitness, weights=(-1.0,))
creator.create("Individual", gp.PrimitiveTree, fitness=creator.FitnessMin)

toolbox = base.Toolbox()
toolbox.register("expr", gp.genHalfAndHalf, pset=pset, min_=1, max_=2)
toolbox.register("individual", tools.initIterate, creator.Individual, toolbox.expr)
toolbox.register("population", tools.initRepeat, list, toolbox.individual)
toolbox.register("compile", gp.compile, pset=pset)


# Custom
x = np.arange(-10, 10, 0.01)
y = [eval_func(np.array([x_i])) for x_i in x]
plot2d(x, y, "griewank")

toolbox.register("evaluate", evalSymbReg, points=x)
toolbox.register("select", tools.selTournament, tournsize=3)
toolbox.register("mate", gp.cxOnePoint)
toolbox.register("expr_mut", gp.genFull, min_=0, max_=2)
toolbox.register("mutate", gp.mutUniform, expr=toolbox.expr_mut, pset=pset)
toolbox.decorate("mate", gp.staticLimit(key=operator.attrgetter("height"), max_value=17))
toolbox.decorate("mutate", gp.staticLimit(key=operator.attrgetter("height"), max_value=17))


random.seed(318)

pop = toolbox.population(n=300)
hof = tools.HallOfFame(1)

stats_fit = tools.Statistics(lambda ind: ind.fitness.values)
stats_size = tools.Statistics(len)
mstats = tools.MultiStatistics(fitness=stats_fit, size=stats_size)
mstats.register("avg", np.mean)
mstats.register("std", np.std)
mstats.register("min", np.min)
mstats.register("max", np.max)

pop, log = algorithms.eaSimple(pop, toolbox, 0.5, 0.1, 40, stats=mstats, halloffame=hof, verbose=True)

bests = tools.selBest(pop, k=1)
print(bests[0])

func = toolbox.compile(expr=bests[0])
y_exp = [func(np.array([x_i])) for x_i in x]
plot2d(x, y_exp, "griewank_exp")