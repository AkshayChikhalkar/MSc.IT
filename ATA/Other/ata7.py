#%%
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


#value
values = [random.randint(1,20) for _ in range(500)]
weights = [random.randint(1,10) for _ in range(500)]

def getRow(lists, row):
    res = []
    for l in lists:
        for i in range(len(l)):
            if i==row:
                res.append(l[i])
    return res

def multipleChoiceKnapsack(W, weights, values):
    n = len(values)
    groups= range(n)
    K = [[0 for x in range(W+1)] for x in range(n+1)] 

    for w in range(W+1):
        for i in range(n+1):
            if i==0 or w==0: 
                K[i][w] = 0
            elif weights[i-1]<=w: 
                sub_max = 0
                prev_group = groups[i-1]-1
                sub_K = getRow(K, w-weights[i-1])
                for j in range(n+1):
                    if groups[j-1]==prev_group and sub_K[j]>sub_max:
                        sub_max = sub_K[j]
                K[i][w] = max(sub_max+values[i-1], K[i-1][w]) 
            else: 
                K[i][w] = K[i-1][w] 

    return K[n][W]


#n = 50 # No. of iterations
#arr_executionTime = [] 
#for i in range(n): #For no of iteration i.e. n
#    dT1 = time.time()
#    result = multipleChoiceKnapsack(W, weights, values)
#    dT2 = time.time()
#    arr_executionTime.append(dT2-dT1) #Recording execution time in array

W = 50
offset =100
n_no_of_iterations = 5 # No. of iterations
arr_Var = [] 
arr_Mean = [] 
arr_No_of_Items = []
arr_Iteration = []
for no_of_items in range(10,60,10):
        values = [random.randint(1,20) for _ in range(no_of_items)]
        weights = [random.randint(1,10) for _ in range(no_of_items)]
        

        print("No of items: " + str(no_of_items))
        for iteration in range(5,15,5):
            arr_executionTime = [] 
            for n in range(iteration):
                dT1 = time.time()
                result = multipleChoiceKnapsack(W, weights, values)
                dT2 = time.time()
                arr_executionTime.append(dT2-dT1)

            arr_Var.append(np.var(arr_executionTime))
            arr_Mean.append(np.mean(arr_executionTime))
            arr_Iteration.append(iteration)
            arr_No_of_Items.append(no_of_items)
            print("Mean Time: " + (str)(np.mean(arr_executionTime)))
            print("Variance Time: " + (str)(np.var(arr_executionTime)))
            #Execution vs iteration plot
            plt.plot(arr_executionTime)
            plt.ylabel('Time')
            plt.xlabel('Iterations (n = ' +str(n_no_of_iterations) + ')' + "Items = " + str(no_of_items))
            plt.show()




#print("Length: "+str(len(arr_executionTime)))
#
#print(arr_executionTime)
#
print("Variance array: " + str(arr_Var))
print("Mean array: " + str(arr_Mean))

#x = np.array([1, 2, 3, 4, 5])
#y = np.power(x, 2) # Effectively y = x**2
#e = np.array([1.5, 2.6, 3.7, 4.6, 5.5])


#plt.show()

x = arr_Var
y = np.power(x, 2) # Effectively y = x**2
e = arr_Mean
plt.errorbar(x, y, e, linestyle='None', marker='.')

plt.show()


import pandas as pd


#Make the dataframe for evaluation on Errorbars
df = pd.DataFrame({
    'Iteration': arr_Iteration,
    'Items': arr_No_of_Items,
    'Mean': arr_Mean,
    'std': arr_Var})
print(df)
fig, ax = plt.subplots()
df.plot()
for key, group in df.groupby('Items'):
    group.plot('Items', 'Mean', yerr='std',
               label=key, ax=ax)
 


data = [-5, 1, 8, 7, 2]

df = pd.DataFrame({
      'mean': arr_Mean,
      'std': arr_Var})
print(df)

df.plot()
plt.show()

print("")

# %%
import numpy as np
import matplotlib.pyplot as plt
data = [[30, 25, 50, 20],
[40, 23, 51, 17],
[35, 22, 45, 19]]
X = np.arange(4)
fig = plt.figure()
ax = fig.add_axes([0,0,1,1])
ax.bar(X + 0.00, data[0], color = 'b', width = 0.25)
ax.bar(X + 0.25, data[1], color = 'g', width = 0.25)
ax.bar(X + 0.50, data[2], color = 'r', width = 0.25)

# %%
import numpy as np
import matplotlib.pyplot as plt
 
# set width of bar
barWidth = 0.25
fig = plt.subplots(figsize =(12, 8))
 
# set height of bar
IT = [12, 30, 1, 8, 22]
ECE = [28, 6, 16, 5, 10]
CSE = [29, 3, 24, 25, 17]
EEIT = [25, 33, 44, 22, 11]
 
# Set position of bar on X axis
br1 = np.arange(len(IT))
br2 = [x + barWidth for x in br1]
br3 = [x + barWidth for x in br2]
br4 = [x + barWidth for x in br3] 
# Make the plot
plt.bar(br1, IT, color ='r', width = barWidth,
        edgecolor ='grey', label ='IT')
plt.bar(br2, ECE, color ='g', width = barWidth,
        edgecolor ='grey', label ='ECE')
plt.bar(br3, CSE, color ='b', width = barWidth,
        edgecolor ='grey', label ='CSE')
plt.bar(br4, CSE, color ='y', width = barWidth,
        edgecolor ='grey', label ='EEIT')
# Adding Xticks
plt.xlabel('Branch', fontweight ='bold', fontsize = 15)
plt.ylabel('Students passed', fontweight ='bold', fontsize = 15)
plt.xticks([r + barWidth for r in range(len(IT))],
        ['2015', '2016', '2017', '2018', '2019'])
 
plt.legend()
plt.show()

# %%
from matplotlib import pyplot as plt
def bar_plot(ax, data, colors=None, total_width=0.8, single_width=1, legend=True):
    # Check if colors where provided, otherwhise use the default color cycle
    if colors is None:
        colors = plt.rcParams['axes.prop_cycle'].by_key()['color']
    # Number of bars per group
    n_bars = len(data)

    # The width of a single bar
    bar_width = total_width / n_bars

    # List containing handles for the drawn bars, used for the legend
    bars = []
    # Iterate over all data
    for i, (name, values) in enumerate(data.items()):
        # The offset in x direction of that bar
        x_offset = (i - n_bars / 2) * bar_width + bar_width / 2

        # Draw a bar for every value of that type
        for x, y in enumerate(values):
            bar = ax.bar(x + x_offset, y, width=bar_width * single_width, color=colors[i % len(colors)])

        # Add a handle to the last drawn bar, which we'll need for the legend
        bars.append(bar[0])
    # Draw legend if we need
    if legend:
        ax.legend(bars, data.keys())

        
if __name__ == "__main__":
    # Usage example:


    data = {
        "Algorithm": [10, 2, 3, 2, 1],
        "Iterations": [2, 3, 29, 3, 1],
        "Score": [.03, 2, 1, 444, 2],
        "Execution Time": [5, 9, 2, 1, 8],
    }

    fig, ax = plt.subplots()
    bar_plot(ax, data, total_width=.8, single_width=1)
    plt.show()
# %%
# import libraries
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# load dataset
data =np.array([["Algorithm", "Score", "Execution"],
        [10, 2, 3, 2, 1],
        [.03, 2, 1, 444, 2],
        [5, 9, 2, 1, 8],
])
df = pd.DataFrame(i for i in data).transpose()
df.drop(0, axis=1, inplace=True)
df.columns = data[0]
print(df)
print(sns.load_dataset("tips"))
tips=df
# set plot style: grey grid in the background:
sns.set(style="darkgrid")

# set the figure size
plt.figure(figsize=(14, 14))

# top bar -> sum all values(smoker=No and smoker=Yes) to find y position of the bars
total = tips.groupby('Algorithm')['Score'].sum().reset_index()

# bar chart 1 -> top bars (group of 'smoker=No')
bar1 = sns.barplot(x="Score",  y="Execution", data=total, color='darkblue')

# bottom bar ->  take only smoker=Yes values from the data
smoker = tips[tips.smoker=='Yes']

# bar chart 2 -> bottom bars (group of 'smoker=Yes')
bar2 = sns.barplot(x="Score", y="Execution", data=smoker, estimator=sum, ci=None,  color='lightblue')

# add legend
top_bar = mpatches.Patch(color='darkblue', label='smoker = No')
bottom_bar = mpatches.Patch(color='lightblue', label='smoker = Yes')
plt.legend(handles=[top_bar, bottom_bar])

# show the graph
plt.show()

# %%
import numpy as np
import matplotlib.pyplot as plt

def plot_stacked_bar(data, series_labels, category_labels=None, 
                     show_values=False, value_format="{}", y_label=None, 
                     colors=None, grid=True, reverse=False):

    ny = len(data[0])
    ind = list(range(ny))

    axes = []
    cum_size = np.zeros(ny)

    data = np.array(data)

    if reverse:
        data = np.flip(data, axis=1)
        category_labels = reversed(category_labels)

    for i, row_data in enumerate(data):
        color = colors[i] if colors is not None else None
        axes.append(plt.bar(ind, row_data, bottom=cum_size, 
                            label=series_labels[i], color=color))
        cum_size += row_data

    if category_labels:
        plt.xticks(ind, category_labels)

    if y_label:
        plt.ylabel(y_label)

    plt.legend()

    if grid:
        plt.grid()

    if show_values:
        for axis in axes:
            for bar in axis:
                w, h = bar.get_width(), bar.get_height()
                plt.text(bar.get_x() + w/2, bar.get_y() + h/2, 
                         value_format.format(h), ha="center", 
                         va="center")

plt.figure(figsize=(4, 5))

series_labels = ['Accuracy', 'Execution Time']

data = [
    [0.67, 0.83, 0.78],
    [0.68, 0.83, 0.78]
]

category_labels = ['SVM', 'RFC', 'DTC']

plot_stacked_bar(
    data, 
    series_labels, 
    category_labels=category_labels, 
    show_values=True, 
    value_format="{:.2f}",
    colors=['tab:grey', 'tab:cyan'],
    y_label="Performance"
)

plt.savefig('bar.png')
plt.show()
# %%

# %%
