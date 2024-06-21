#%%
# conda install graphviz

import os
os.environ['PATH'] = os.environ['PATH']+';'+os.environ['CONDA_PREFIX']+r"\Library\bin\graphviz"

import pm4py
import pandas as pd
from pm4py.algo.discovery.alpha import algorithm as alpha_miner
from pm4py.algo.discovery.heuristics import algorithm as heurist_miner
from pm4py.algo.discovery.inductive import algorithm as inductive_miner
from pm4py.algo.simulation.playout.petri_net import algorithm as simulator
from pm4py.objects.conversion.log import converter as log_converter
from pm4py.visualization.petri_net import visualizer as pn_vis
from pm4py.algo.evaluation.replay_fitness import algorithm as replay_fitness_evaluator
from pm4py.algo.evaluation.precision import algorithm as precision_evaluator
from pm4py.algo.evaluation.generalization import algorithm as generalization_evaluator
from pm4py.algo.evaluation.simplicity import algorithm as simplicity_evaluator
from shutil import copyfile
from IPython.display import SVG, display

def meta(event_log, pn, i, f):
    print("Replay Fitness (TOKEN_BASED): ", replay_fitness_evaluator.apply(event_log, pn, i, f, variant=replay_fitness_evaluator.Variants.TOKEN_BASED))
    print("Replay Fitness (ALIGNMENT_BASED): ", replay_fitness_evaluator.apply(event_log, pn, i, f, variant=replay_fitness_evaluator.Variants.ALIGNMENT_BASED))
    print("Precision (ETCONFORMANCE_TOKEN): ", precision_evaluator.apply(event_log, pn, i, f, variant=precision_evaluator.Variants.ETCONFORMANCE_TOKEN))
    print("Precision (ALIGN_ETCONFORMANCE): ", precision_evaluator.apply(event_log, pn, i, f, variant=precision_evaluator.Variants.ALIGN_ETCONFORMANCE))
    print("Generalization: ", generalization_evaluator.apply(event_log, pn, i, f))
    print("Simplicity: ", simplicity_evaluator.apply(pn))

def display_pn(pn, i, f, name):
    gviz = pn_vis.apply(pn, i, f, parameters={pn_vis.Variants.WO_DECORATION.value.Parameters.FORMAT: "svg", pn_vis.Variants.WO_DECORATION.value.Parameters.DEBUG: False})
    f = gviz.render()
    copyfile(f, name + ".svg")
    display(SVG(f))

def load_csv(name):
    e = pd.read_csv(name, sep=';')
    e = pm4py.format_dataframe(e, case_id="case_id", activity_key="activity", timestamp_key="timestamp")
    return e

def am(event_log):
    pn, i, f = alpha_miner.apply(event_log)
    display_pn(pn, i, f, "alpha")
    return pn, i, f

def hm(event_log):
    pn, i, f = heurist_miner.apply(event_log)
    display_pn(pn, i, f, "heurist")
    return pn, i, f

def im(event_log):
    pn, i, f = inductive_miner.apply(event_log)
    display_pn(pn, i, f, "inductive")
    return pn, i, f
os.chdir("/Users/akshaychikhalkar/Desktop/ATA Exc 4")

event_log_coffee = load_csv("/Users/akshaychikhalkar/Desktop/ATA Exc 4/coffee.csv")
event_log_rt50 = pm4py.read_xes("/Users/akshaychikhalkar/Desktop/ATA Exc 4/roadtraffic50tracesxes.xes")
event_log_rt100 = pm4py.read_xes("/Users/akshaychikhalkar/Desktop/ATA Exc 4/roadtraffic100tracesxes.xes")

arr_normal = []
arr_scan = []

for i in range(1,7):

    arr_normal.append(pd.read_csv(f'Data/Normal/0_normal_run_{i}.csv').assign(caseID=i))
    if i<6: 
        arr_scan.append(pd.read_csv(f'Data/Scan/3_pn_scan_run_{i}.csv').assign(caseID=i))

normal = pd.concat(arr_normal)
scan = pd.concat(arr_scan)

df_log = pm4py.format_dataframe(normal, case_id='case ID', timestamp_key='Time', activity_key='Protocol')
df_log = df_log.rename(columns={'Source': 'org:resource'})
normal_log = pm4py.convert_to_event_log(df_log)

df_log = pm4py.format_dataframe(scan, case_id='case ID', timestamp_key='Time', activity_key='Protocol')
df_log = df_log.rename(columns={'Source': 'org:resource'})
scan_log = pm4py.convert_to_event_log(df_log)

for i in range(1,7):
    #event_log = load_csv(f'Data/Normal/0_normal_run_{i}.csv')
    pn, i, f = am(normal_log)
    meta(normal_log, pn, i, f)
    if i<6: 
        #event_log = load_csv(f'Data/Scan/3_pn_scan_run_{i}.csv')
        pn, i, f = am(scan_log)
        meta(scan_log, pn, i, f)
#print("\n *********** Coffee ***********\n")
#pn, i, f = am(event_log_coffee)
#meta(event_log_coffee, pn, i, f)
#
#pn, i, f = hm(event_log_coffee)
#meta(event_log_coffee, pn, i, f)
#
#pn, i, f = im(event_log_coffee)
#meta(event_log_coffee, pn, i, f)
#
#print("\n *********** Road Traffic 50 ***********\n")
#
#pn, i, f = im(event_log_rt50)
#meta(event_log_rt50, pn, i, f)
#
#pn, i, f = im(event_log_rt50)
#meta(event_log_rt50, pn, i, f)
#
#pn, i, f = im(event_log_rt50)
#meta(event_log_rt50, pn, i, f)
#
#print("\n *********** Road Traffic 100 ***********\n")
#
#pn, i, f = im(event_log_rt100)
#meta(event_log_rt100, pn, i, f)
#
#pn, i, f = im(event_log_rt100)
#meta(event_log_rt100, pn, i, f)
#
#pn, i, f = im(event_log_rt100)
#meta(event_log_rt100, pn, i, f)

# %% Exercise 2
import pm4py
import pandas as pd

arr_normal = []
arr_scan = []

for i in range(1,7):

    arr_normal.append(pd.read_csv(f'Data/Normal/0_normal_run_{i}.csv').assign(caseID=i))
    if i<6: 
        arr_scan.append(pd.read_csv(f'Data/Scan/3_pn_scan_run_{i}.csv').assign(caseID=i))

normal = pd.concat(arr_normal)
scan = pd.concat(arr_scan)

df_log = pm4py.format_dataframe(normal, case_id='caseID', timestamp_key='Time', activity_key='Protocol')
df_log = df_log.rename(columns={'Source': 'org:resource'})
normal_log = pm4py.convert_to_event_log(df_log)

df_log = pm4py.format_dataframe(scan, case_id='caseID', timestamp_key='Time', activity_key='Protocol')
df_log = df_log.rename(columns={'Source': 'org:resource'})
scan_log = pm4py.convert_to_event_log(df_log)

hm = ()
#pn_normal, i_normal ,f_normal = hm(normal_log)
#pn_scan, i_scan ,f_scan = hm(scan_log)
print(normal_log)
print(scan_log)
# %%
#%%
# conda install graphviz

import os
os.environ['PATH'] = os.environ['PATH']+';'+os.environ['CONDA_PREFIX']+r"\Library\bin\graphviz"

import pm4py
import pandas as pd
from pm4py.algo.discovery.alpha import algorithm as alpha_miner
from pm4py.algo.discovery.heuristics import algorithm as heurist_miner
from pm4py.algo.discovery.inductive import algorithm as inductive_miner
from pm4py.algo.simulation.playout.petri_net import algorithm as simulator
from pm4py.objects.conversion.log import converter as log_converter
from pm4py.visualization.petri_net import visualizer as pn_vis
from pm4py.algo.evaluation.replay_fitness import algorithm as replay_fitness_evaluator
from pm4py.algo.evaluation.precision import algorithm as precision_evaluator
from pm4py.algo.evaluation.generalization import algorithm as generalization_evaluator
from pm4py.algo.evaluation.simplicity import algorithm as simplicity_evaluator
from shutil import copyfile
from IPython.display import SVG, display

def meta(event_log, pn, i, f):
    print("Replay Fitness (TOKEN_BASED): ", replay_fitness_evaluator.apply(event_log, pn, i, f, variant=replay_fitness_evaluator.Variants.TOKEN_BASED))
    print("Replay Fitness (ALIGNMENT_BASED): ", replay_fitness_evaluator.apply(event_log, pn, i, f, variant=replay_fitness_evaluator.Variants.ALIGNMENT_BASED))
    print("Precision (ETCONFORMANCE_TOKEN): ", precision_evaluator.apply(event_log, pn, i, f, variant=precision_evaluator.Variants.ETCONFORMANCE_TOKEN))
    print("Precision (ALIGN_ETCONFORMANCE): ", precision_evaluator.apply(event_log, pn, i, f, variant=precision_evaluator.Variants.ALIGN_ETCONFORMANCE))
    print("Generalization: ", generalization_evaluator.apply(event_log, pn, i, f))
    print("Simplicity: ", simplicity_evaluator.apply(pn))

def display_pn(pn, i, f, name):
    gviz = pn_vis.apply(pn, i, f, parameters={pn_vis.Variants.WO_DECORATION.value.Parameters.FORMAT: "svg", pn_vis.Variants.WO_DECORATION.value.Parameters.DEBUG: False})
    f = gviz.render()
    copyfile(f, name + ".svg")
    display(SVG(f))

def load_csv(name):
    e = pd.read_csv(name, sep=';')
    e = pm4py.format_dataframe(e, case_id="case_id", activity_key="activity", timestamp_key="timestamp")
    return e

def am(event_log):
    pn, i, f = alpha_miner.apply(event_log)
    display_pn(pn, i, f, "alpha")
    return pn, i, f

def hm(event_log):
    pn, i, f = heurist_miner.apply(event_log)
    display_pn(pn, i, f, "heurist")
    return pn, i, f

def im(event_log):
    pn, i, f = inductive_miner.apply(event_log)
    display_pn(pn, i, f, "inductive")
    return pn, i, f
os.chdir("/Users/akshaychikhalkar/Desktop/ATA Exc 4")

arr_normal = []
arr_scan = []

for i in range(1,7):

    arr_normal.append(pd.read_csv(f'Data/Normal/0_normal_run_{i}.csv').assign(caseID=i))
    if i<6: 
        arr_scan.append(pd.read_csv(f'Data/Scan/3_pn_scan_run_{i}.csv').assign(caseID=i))

normal = pd.concat(arr_normal)
scan = pd.concat(arr_scan)

df_log = pm4py.format_dataframe(normal, case_id='caseID', timestamp_key='Time', activity_key='Protocol')
df_log = df_log.rename(columns={'Source': 'org:resource'})
normal_log = pm4py.convert_to_event_log(df_log)

df_log = pm4py.format_dataframe(scan, case_id='caseID', timestamp_key='Time', activity_key='Protocol')
df_log = df_log.rename(columns={'Source': 'org:resource'})
scan_log = pm4py.convert_to_event_log(df_log)
for i in range(1,7):
    event_log = load_csv(f'Data/Normal/0_normal_run_{i}.csv')
    pn, i, f = am(event_log)
    meta(event_log, pn, i, f)
    if i<6: 
        event_log = load_csv(f'Data/Scan/3_pn_scan_run_{i}.csv')
        pn, i, f = am(event_log)
        meta(event_log, pn, i, f)
