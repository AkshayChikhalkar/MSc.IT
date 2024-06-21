#%%

#Import library
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import time
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn import model_selection
from sklearn.svm import SVC
from sklearn.metrics import confusion_matrix, accuracy_score, classification_report, ConfusionMatrixDisplay


#Import  Dataset 
df = pd.read_csv('gpu_specs_v6.csv', header= 0,encoding= 'utf-8')

df.dropna(how='all')
df=df.interpolate()
df.isnull().sum()


features = df.loc[:,['memType','memSize','gpuClock','memClock','memBusWidth']]
features.head()

features = features.dropna()

y =  features.pop('memType')

X_train, X_test, Y_train, Y_test = train_test_split(features.values, y, test_size=0.2, random_state=42)


model0 = SVC()
model0.fit(X_train, Y_train)
pred0=model0.predict(X_test)

model1 = RandomForestClassifier()
model1.fit(X_train, Y_train)
pred1=model1.predict(X_test)

model2 = DecisionTreeClassifier()
model2.fit(X_train, Y_train)
pred2=model2.predict(X_test)

models = []
models.append(('SVM', SVC(), Y_test, pred0, classification_report(Y_test, pred0,output_dict=True)))
models.append(('RFC', RandomForestClassifier(), Y_test, pred1, classification_report(Y_test, pred1,output_dict=True)))
models.append(('DTC', DecisionTreeClassifier(), Y_test, pred2, classification_report(Y_test, pred2,output_dict=True)))

names = []        
arr_Var = [] 
arr_Mean = [] 
arr_Iteration = []
arr_results=[]
j = 1
for n in range(0,200,42):
    for i in range(0, n):
        arr_executionTime = [] 
        for name, model, a, b, c in models:
            kfold = model_selection.StratifiedKFold(n_splits=10)
            cv_results = model_selection.cross_val_score(model, X_train, Y_train,cv=kfold, scoring='accuracy')
            dT1 = time.time()
            model.fit(X_train, Y_train)
            model.predict(X_test)
            dT2 = time.time()
            arr_executionTime.append(dT2-dT1)
            names.append(name)
            #results.append(cv_results)
            arr_results.append(cv_results.mean())
            #arr_Var.append(np.var(arr_executionTime))
            arr_Mean.append(np.mean(arr_executionTime))
            arr_Iteration.append(n)
            j=j+1
        print(j)



#%%
def plot_stacked_bar(data, series_labels, category_labels=None, 
                     show_values=False, value_format="{}", y_label=None, 
                     colors=None, grid=False, reverse=False):

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

df_plt = pd.DataFrame({
    "Algorithm": names, 
    "Iterations": arr_Iteration,   
    "Score": arr_results,
    "Execution Time": arr_Mean
 })
fig, ax = plt.subplots()
ax.set(ylabel='Accuracy')
ax.set(title='Accuracy plot  for SVM, RFC, DTC')
clr = ['#E1003B', '#bbbbbb','#cccccc']
for label, group in df_plt.groupby('Algorithm'):
    group.plot('Algorithm','Score',label=label, ax=ax)
ax.tick_params(bottom=False)
ax.get_lines()[0].set_color('#f399b0')
ax.get_lines()[1].set_color('#E1003B')
ax.get_lines()[2].set_color('#b4002f')
ax.grid()
ax.set(xticklabels=[])
ax.set(xlabel=None)
plt.legend(loc='upper right')
plt.savefig('../PPT/Accuracy Plot.png')


fig, ax = plt.subplots()
ax.set(ylabel='Execution Time (Sec)')
ax.set(title='Execution Time plot for SVM, RFC, DTC')
print(df_plt)
for label, group in df_plt.groupby('Algorithm'):
    group.plot('Algorithm','Execution Time',label=label, ax=ax)
ax.tick_params(bottom=False)
ax.grid()
ax.set(xticklabels=[])
ax.get_lines()[0].set_color('#f399b0')
ax.get_lines()[1].set_color('#E1003B')
ax.get_lines()[2].set_color('#b4002f')
ax.set(xlabel='Total Iterations = ' + str(j))
plt.legend(loc='upper right')

plt.savefig('../PPT/Execution Time Plot.png')

#%%
arr_algo = ['SVM', 'RFC', 'DTC']
arr_accuracy=[]
arr_precision =[]
arr_recall=[]
arr_f1=[]
for name, model, a, b, c in models:
    arr_accuracy.append(c['accuracy'])
    arr_precision.append(c['weighted avg']['precision'])
    arr_recall.append(c['weighted avg']['recall'])
    arr_f1.append(c['weighted avg']['f1-score'])

dataset = pd.DataFrame({'Algo': arr_algo,'accuracy': arr_accuracy, 'precision': arr_precision,
 'recall': arr_recall, 'f1-score': arr_f1})


plt.figure(figsize=(5, 7))

series_labels = ['Accuracy', 'Execution Time (Sec)']
data = df_plt.groupby("Algorithm").mean()[['Score', 'Execution Time']]
print("************* Cross validation Results **************")
print(df_plt.groupby("Algorithm").mean())
data = [
    data['Score'],
    data['Execution Time']
]
category_labels = ['DTC', 'RFC', 'SVM']
plot_stacked_bar(
    data, 
    series_labels, 
    category_labels=category_labels, 
    show_values=True, 
    value_format="{:.2f}",
    colors=['#E1003B','#bbbbbb'],
    y_label="Performance Cross-validation (Total iterations = " + str(j) + ")"
)

plt.savefig('bar.png')
plt.legend(loc='upper right')
plt.savefig('../PPT/Performance_CV.png')
plt.show()


plt.figure(figsize=(5, 7))

series_labels = ['Accuracy', 'Precision', 'Recall', 'F1']
print("************* Confusion Matrix Results **************")
data = dataset.groupby("Algo").mean()
print(data)
data = [ data['accuracy'], data['precision'], data['recall'],data['f1-score']]
category_labels = ['DTC', 'RFC', 'SVM']

plot_stacked_bar(
    data, 
    series_labels, 
    category_labels=category_labels, 
    show_values=True, 
    value_format="{:.2f}",
    colors=['#E1003B','#bbbbbb','#cccccc', '#dddddd'],
    y_label="Performance Confusion Matrix"
)

plt.savefig('bar.png')
plt.legend(loc='upper right')
plt.savefig('../PPT/Performance_CM.png')
plt.show()


# %%

for name, model, y_test, y_pred, c in models:
    fig, ax = plt.subplots(figsize=(10,10))
    ax.set_title('Confussion Matrix Heatmap - ' + name)
    ConfusionMatrixDisplay.from_predictions(y_test, y_pred, labels=model.classes_,xticks_rotation="vertical",cmap="RdPu",
                                display_labels=model.classes_, ax=ax, colorbar=False)
    plt.savefig('../PPT/CM_Heatmap_' + name +'.png')




# %%
corr = features.corr(method='pearson')
sns.heatmap(corr, cmap="Pastel1", annot=True)
plt.savefig('../PPT/DataCorelation.png')




# %%
plt.title('GPU Memory Type')
df['memType'].value_counts().plot.bar(color=['#E1003B','grey','#bbbbbb'])
plt.rcParams["figure.figsize"] = (8,8)
plt.savefig('../PPT/DataBarplot.png')
plt.show()

# %%
from matplotlib.lines import Line2D

custom = [Line2D([], [], marker='.', color='#bbbbbb', linestyle='None'),
          Line2D([], [], marker='.', color='#E1003B', linestyle='None')]
gCmC = sns.scatterplot(x="memSize", y="gpuClock", ci=None, data=features,color = '#bbbbbb')
gCmC = sns.scatterplot(x="memSize", y="memClock", ci=None, data=features, color = '#E1003B')
gCmC.figure.autofmt_xdate()
plt.xlabel('memSize')
# Set y-axis label
plt.ylabel('Clock speed (MHz)')
plt.legend(custom, ['gpuClock', 'memClock'], loc='upper right')

plt.savefig('../PPT/DatagpuClockvsmemClock.png')




# %%
y = sns.pairplot(df, hue='memType')
plt.savefig('../PPT/DataPariPlot.png')

# %%
