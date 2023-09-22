#%%
#########################################################################################################
######################## Start with initial linear classifier (initial accuracy) ########################
#########################################################################################################
import warnings
warnings.filterwarnings("ignore")
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV, RandomizedSearchCV
import warnings
from sklearn.decomposition import PCA
from sklearn.model_selection import GridSearchCV
from sklearn.preprocessing import StandardScaler
import pandas as pd
import numpy as np
import time
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.ensemble import RandomForestClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn import model_selection
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.naive_bayes import GaussianNB
from tabulate import tabulate
from sklearn.feature_selection import SelectKBest, f_classif
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.metrics import confusion_matrix, accuracy_score, classification_report, ConfusionMatrixDisplay


#Import  Dataset 
df = pd.read_csv('gpu_specs_v6.csv', header= 0,encoding= 'utf-8')

########### Data Preprocessing ###########
# Load the GPU dataset from CSV
df = pd.read_csv('gpu_specs_v6.csv', header=0, encoding='utf-8')
print("Number of rows and columns before dropping columns:", df.shape)

df_filtered = df.interpolate()
print("Number of rows and columns after interpolation columns:", df_filtered.shape)

df_filtered = df_filtered.dropna()
print("Number of rows and columns after dropping rows with missing values:", df_filtered.shape)

####### Dataset Features Selection #######
# List of columns to eliminate
columns_to_eliminate = ['manufacturer', 'productName', 'igp', 'bus', 'memType', 'gpuChip', 'pixelShader', 'vertexShader']

# Drop the specified columns from the DataFrame
df_HPO = df_FeatureSelection = df_filtered.drop(columns=columns_to_eliminate)

###### Dataset Hyperparameter optimization ########

def calculate_metrics(confusion_matrix):
    tn, fp, fn, tp = confusion_matrix[0, 0], confusion_matrix[0,
                                                              1], confusion_matrix[1, 0], confusion_matrix[1, 1]
    accuracy = (tp + tn) / (tp + tn + fp + fn)
    precision = tp / (tp + fp)
    recall = tp / (tp + fn)
    f1_score = 2 * (precision * recall) / (precision + recall)
    return accuracy, precision, recall, f1_score

###########################################################
################# Linear Cross Validation #################
###########################################################

features = df_filtered.loc[:,['releaseYear','memSize','gpuClock','memClock','memBusWidth']]
features.head()


y =  features.pop('releaseYear')

X_train, X_test, Y_train, Y_test = train_test_split(features.values, y, test_size=0.2, random_state=42)


modelSVM = SVC()
modelSVM.fit(X_train, Y_train)
predSVM=modelSVM.predict(X_test)

modelRFC = RandomForestClassifier()
modelRFC.fit(X_train, Y_train)
predRFC=modelRFC.predict(X_test)

modeDST = DecisionTreeClassifier()
modeDST.fit(X_train, Y_train)
predDST=modeDST.predict(X_test)

modeLDA = LinearDiscriminantAnalysis()
modeLDA.fit(X_train, Y_train)
predLDA=modeLDA.predict(X_test)

modelKNN = KNeighborsClassifier(n_neighbors=3)
modelKNN.fit(X_train, Y_train)
predKNN=modelKNN.predict(X_test)

modelGNB = GaussianNB()
modelGNB.fit(X_train, Y_train)
predGNB=modelGNB.predict(X_test)

models = []
models.append(('SVM', SVC(), Y_test, predSVM, classification_report(Y_test, predSVM,output_dict=True)))
models.append(('RFC', RandomForestClassifier(), Y_test, predRFC, classification_report(Y_test, predRFC,output_dict=True)))
models.append(('DTC', DecisionTreeClassifier(), Y_test, predDST, classification_report(Y_test, predDST,output_dict=True)))
models.append(('LDA', LinearDiscriminantAnalysis(), Y_test, predLDA, classification_report(Y_test, predLDA,output_dict=True)))
models.append(('KNN', KNeighborsClassifier(), Y_test, predKNN, classification_report(Y_test, predKNN,output_dict=True)))
models.append(('GNB', GaussianNB(), Y_test, predGNB, classification_report(Y_test, predGNB,output_dict=True)))

names = []        
arr_Var = [] 
arr_Mean = [] 
arr_Iteration = []
arr_results=[]
results =[]
j = 1
for n in range(0,6,2):
    for i in range(0, n):
        arr_executionTime = [] 
        for name, model, a, b, c in models:
            kfold = model_selection.StratifiedKFold(n_splits=10)
            cv_results = model_selection.cross_val_score(model, X_train, Y_train,cv=kfold, scoring='accuracy')
            dT1 = time.time()
            model.fit(X_train, Y_train)
            pred = model.predict(X_test)
            dT2 = time.time()
            arr_executionTime.append(dT2-dT1)
            names.append(name)
            #results.append(cv_results)
            arr_results.append(cv_results.mean())
            #arr_Var.append(np.var(arr_executionTime))
            arr_Mean.append(np.mean(arr_executionTime))
            arr_Iteration.append(n)
            j=j+1

            report = classification_report(Y_test, pred, output_dict=True)
            results.append((name, cv_results.mean(), report['accuracy'], report['weighted avg']['precision'],
                        report['weighted avg']['recall'], report['weighted avg']['f1-score'], dT2-dT1, n))
            

            
# Convert results to a DataFrame
results_df = pd.DataFrame(results, columns=[
                          'Algorithm', 'CV_Accuracy', 'Accuracy', 'Precision', 'Recall', 'F1', 'Execution Time', 'Iterations']).groupby('Algorithm').mean().reset_index()
results_crossValidation = results_df



################################################################################################################
######################## Perform dimentionality reduction (based on initial parameters) ########################
################################################################################################################
###### Feature Extraction / Feature Selection ######

# Separate features and target variable
X = df_HPO.drop(columns=['releaseYear'])  # Features
y = df_HPO['releaseYear']                  # Target variable

# Feature Selection: Select top k features using ANOVA F-value
k_best = SelectKBest(score_func=f_classif, k=5)
X_selected = k_best.fit_transform(X, y)

# Print selected features
selected_feature_indices = k_best.get_support(indices=True)
selected_features = X.columns[selected_feature_indices]
#print("Selected Features:")
#print(selected_features)

# Feature Extraction: Apply PCA (Principal Component Analysis)
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)  # Standardize features

pca = PCA(n_components=5)  # Choose the number of components
X_pca = pca.fit_transform(X_scaled)

# Print explained variance ratio of PCA components
#print("Explained Variance Ratio of PCA Components:")
#print(pca.explained_variance_ratio_)

#########################################################################################################
######################## Design new classifier with higher accuracy (refinement) ########################
#########################################################################################################
#%%
# Separate features (X) and target (y)
#X = df_HPO.drop(columns=['releaseYear'])
#y = df_HPO['releaseYear']

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Standardize features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Feature selection using SelectKBest and ANOVA
# Choose the number of top features to select
selector = SelectKBest(score_func=f_classif, k=5)
X_train_selected = selector.fit_transform(X_train_scaled, y_train)
X_test_selected = selector.transform(X_test_scaled)

# Define a list of classifiers
classifiers = [
    ('RFC', RandomForestClassifier(random_state=42), {'n_estimators': [100, 200, 300], 'max_depth': [None, 10, 20], 'min_samples_split': [2, 5, 10]}),
    ('DTC', DecisionTreeClassifier(random_state=42), {'max_depth': [None, 10, 20], 'min_samples_split': [2, 5, 10]}), 
    ('SVM', SVC(random_state=42), {'C': [0.1, 1, 10],  'gamma': [
     'scale', 'auto']}),  # For SVM, gamma parameter
    ('KNN', KNeighborsClassifier(), {'n_neighbors': [3, 5, 7], 'weights': ['uniform', 'distance']}),
    ('LDA', LinearDiscriminantAnalysis(), {}),  # LDA has no hyperparameters in this example
    ('GNB', GaussianNB(), {})  # Gaussian Naive Bayes has no hyperparameters
]

results_CV = []
i = 0
# Step 2: Model selection and evaluation using cross-validation
for name, classifier, param_dist in classifiers:
    # Perform cross-validation
    dT1 = time.time()
    i+=1
    print(i)
    scores = cross_val_score(classifier, X_train_selected,
                             y_train, cv=5, scoring='accuracy')
    # Train the selected classifier on the whole training set
    classifier.fit(X_train_selected, y_train)
    # Make predictions on the test set
    y_pred = classifier.predict(X_test_selected)
    dT2 = time.time()

    # Evaluate the classifier
    accuracy = accuracy_score(y_test, y_pred)
    classification_rep = classification_report(y_test, y_pred)
    cm = confusion_matrix(y_test, y_pred)
    accuracy, precision, recall, f1_score = calculate_metrics(cm)

    # Append results to the DataFrame
    results_CV.append({
        'Classifier': name,
        'Cross-Val Accuracy': scores.mean(),
        'Cross-Val Accuracy Std': scores.std(),
        'Test Accuracy': accuracy,
        'Precision': precision,
        'Recall': recall,
        'F1': f1_score,
        'Execution Time': dT2-dT1
    })

    # Perform cross-validation with hyperparameter optimization
    dT1 = time.time()
    grid_search = GridSearchCV(
        classifier, param_dist, cv=5, scoring='accuracy')
    grid_search.fit(X_train_selected, y_train)

    # Get the best classifier with optimized hyperparameters
    best_classifier = grid_search.best_estimator_

    # Make predictions on the test set
    y_pred = best_classifier.predict(X_test_selected)
    dT2 = time.time()
    # Calculate metrics
    cm = confusion_matrix(y_test, y_pred)
    accuracy, precision, recall, f1_score = calculate_metrics(cm)

    # Append results to the DataFrame
    results_CV.append({
        'Classifier': name,
        'CV_Accuracy': grid_search.best_score_,
        'Test Accuracy': accuracy,
        'Precision': precision,
        'Recall': recall,
        'F1': f1_score,
        'Execution Time': dT2-dT1,
        'Best Parameters': grid_search.best_params_
    })

    # Perform cross-validation with hyperparameter optimization using RandomizedSearchCV
    dT1 = time.time()
    random_search = RandomizedSearchCV(
        classifier, param_distributions=param_dist, n_iter=10, cv=5, scoring='accuracy')
    random_search.fit(X_train, y_train)

    # Get the best classifier with optimized hyperparameters
    best_classifier = random_search.best_estimator_

    # Train the best classifier on the whole training set
    best_classifier.fit(X_train, y_train)

    # Make predictions on the test set
    y_pred = best_classifier.predict(X_test)
    dT2 = time.time()

    # Calculate metrics
    accuracy = accuracy_score(y_test, y_pred)
    classification_rep = classification_report(y_test, y_pred)
    cm = confusion_matrix(y_test, y_pred)
    accuracy, precision, recall, f1_score = calculate_metrics(cm)

    # Append results to the DataFrame
    results_CV.append({
        'Classifier': name,
        'Cross-Val Accuracy': random_search.best_score_,
        'Test Accuracy': accuracy,
        'Precision': precision,
        'Recall': recall,
        'F1': f1_score,
        'Execution Time': dT2 - dT1,
        #'Classification Report': classification_rep,
        'Best Parameters': random_search.best_params_
    })
#print("\nResults from Cross validation:")
results_CV_new = pd.DataFrame(results_CV)

# Create a Pandas DataFrame from the results
results_GS = pd.DataFrame(results_CV)

# Create a Pandas DataFrame from the results
results_RS = pd.DataFrame(results_CV)

#%%
######### Plotting #########
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
#df_plt = results_df[['Algorithm', 'Iterations', 'Accuracy', 'Execution Time']]
fig, ax = plt.subplots()
ax.set(ylabel='Accuracy')
ax.set(title='Accuracy plot  for SVM, RFC, DTC, LDA, KNN, GNB')

for label, group in df_plt.groupby('Algorithm'):
    group.plot('Algorithm', 'Score', label=label, ax=ax)
ax.tick_params(bottom=False)
ax.grid()
ax.set(xticklabels=[])
ax.set(xlabel=None)
plt.legend(loc='upper right')
plt.savefig('../Report/Plots/Accuracy Plot.png')


fig, ax = plt.subplots()
ax.set(ylabel='Execution Time (Sec)')
ax.set(title='Execution Time plot for SVM, RFC, DTC, LDA, KNN, GNB')
#print(df_plt)
for label, group in df_plt.groupby('Algorithm'):
    group.plot('Algorithm','Execution Time',label=label, ax=ax)
ax.tick_params(bottom=False)
ax.grid()
ax.set(xticklabels=[])
ax.set(xlabel='Total Iterations = ' + str(j))
plt.legend(loc='upper right')
plt.savefig('../Report/Plots/Execution Time Plot.png')


#%%
######### Performance #########
arr_algo = ['SVM', 'RFC', 'DTC', 'LDA', 'KNN', 'GNB']
arr_accuracy=[]
arr_precision =[]
arr_recall=[]
arr_f1=[]
for name, model, a, b, c in models:
    arr_accuracy.append(c['accuracy'])
    arr_precision.append(c['weighted avg']['precision'])
    arr_recall.append(c['weighted avg']['recall'])
    arr_f1.append(c['weighted avg']['f1-score'])

#dataset = pd.DataFrame({'Algo': arr_algo,'accuracy': arr_accuracy, 'precision': arr_precision, 'recall': arr_recall, 'f1-score': arr_f1})


plt.figure(figsize=(5, 7))

series_labels = ['Accuracy', 'Execution Time (Sec)']
data = df_plt.groupby("Algorithm").mean()[['Score', 'Execution Time']]
#print("************* Cross validation Results **************")
#print(df_plt.groupby("Algorithm").mean())
#print(tabulate(df_plt.groupby("Algorithm").mean(), headers='keys', tablefmt='pretty', showindex=False))

data = [
    data['Score'],
    data['Execution Time']
]
category_labels = ['DTC', 'RFC', 'SVM', 'LDA', 'KNN', 'GNB']
plot_stacked_bar(
    data, 
    series_labels, 
    category_labels=category_labels, 
    show_values=True, 
    value_format="{:.2f}",
    colors=['#29a8ab','#bbbbbb'],
    y_label="Performance Cross-validation (Total iterations = " + str(j) + ")"
)

plt.savefig('bar.png')
plt.legend(loc='upper right')
plt.savefig('../Report/Plots/Performance_CV.png')
plt.show()


plt.figure(figsize=(8, 6))

series_labels = ['Accuracy', 'Precision', 'Recall', 'F1']
#print("************* Confusion Matrix Results **************")
#data = dataset.groupby("Algo").mean()
#results_df = results_df
#print(data)
#print(tabulate(data, headers='keys', tablefmt='pretty', showindex=False, floatfmt='.3f'))

results_df = [results_df['Accuracy'], results_df['Precision'], results_df['Recall'], results_df['F1']]

plot_stacked_bar(
    results_df, 
    series_labels, 
    category_labels=category_labels, 
    show_values=True, 
    value_format="{:.2f}",
    colors=['#29a8ab','#bbbbbb','#cccccc', '#dddddd'],
    y_label="Performance Confusion Matrix"
)

plt.savefig('bar.png')
plt.legend(loc='upper right')
plt.savefig('../Report/Plots/Performance_CM.png')
plt.show()


# %%
###### Confusion Matrix ######
for name, model, y_test, y_pred, c in models:
    fig, ax = plt.subplots(figsize=(10,10))
    ax.set_title('Confussion Matrix Heatmap - ' + name)
    ConfusionMatrixDisplay.from_predictions(y_test, y_pred, labels=model.classes_,xticks_rotation="vertical",cmap="Blues",
                                display_labels=model.classes_, ax=ax, colorbar=False)
    plt.savefig('../Report/Plots/CM_Heatmap_' + name + '.png')




# %%
###### Heatmap ######
corr = features.corr(method='pearson')
sns.heatmap(corr, cmap="Pastel1", annot=True)
plt.savefig('../Report/Plots/DataCorelation.png')




# %%
import warnings
warnings.filterwarnings("ignore")
###### Bar Plot ######
plt.title('GPU Memory Type')
df['memType'].value_counts().plot.bar(color=['#bbbbbb','#66CDAA','#008B8B'])
fig = plt.figure(figsize =(8, 8))
plt.show()
plt.savefig('../Report/Plots/DataBarplot.png')

# %%
###### Scatter Plot ######
gCmC = sns.scatterplot(x="memSize", y="gpuClock", ci=None, data=features,color = '#bbbbbb')
gCmC = sns.scatterplot(x="memSize", y="memClock", ci=None, data=features, color = '#29a8ab')
gCmC.figure.autofmt_xdate()
plt.xlabel('memSize')
# Set y-axis label
plt.ylabel('Clock speed (MHz)')
plt.savefig('../Report/Plots/DatagpuClockvsmemClock.png')




# %%
##### Pairplot (Hue) #####
y = sns.pairplot(df, hue='memType')
plt.savefig('../Report/Plots/DataPariPlot.png')


#%%
########################## Print all results ##########################

# Print Cross-validation and Performance Results
print("Cross-validation and Performance Results:\n")
print(tabulate(results_crossValidation.applymap(lambda x: f"{x:.3f}" if isinstance(x, (int, float)) else x), headers='keys', tablefmt='pretty', showindex=False, floatfmt=".3f"))

# Print Selected Features
print("Selected Features:")
print(selected_features)

# Print Explained Variance Ratio of PCA Components
print("\nExplained Variance Ratio of PCA Components:")
print(np.around(pca.explained_variance_ratio_, decimals=3))

# Print Results: Cross-validation
print("\nResults Cross-validation:")
print(tabulate(results_CV_new.groupby('Classifier').mean().reset_index().applymap(lambda x: f"{x:.3f}" if isinstance(x, (int, float)) else x), headers='keys', tablefmt='pretty', showindex=False, floatfmt=".3f"))

# Print Results: Grid Search CV
print("\nResults Grid Search CV:")
print(tabulate(results_GS.groupby('Classifier').mean().reset_index().applymap(lambda x: f"{x:.3f}" if isinstance(x, (int, float)) else x), headers='keys', tablefmt='pretty', showindex=False, floatfmt=".3f"))

# Print Results: Random Search CV
print("\nResults Random Search CV:")
print(tabulate(results_RS.groupby('Classifier').mean().reset_index().applymap(lambda x: f"{x:.3f}" if isinstance(x, (int, float)) else x), headers='keys', tablefmt='pretty', showindex=False, floatfmt=".3f"))

# %%
