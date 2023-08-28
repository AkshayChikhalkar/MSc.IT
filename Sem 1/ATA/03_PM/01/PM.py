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

event_log = load_csv("coffee.csv")
am(event_log)
hm(event_log)
im(event_log)
