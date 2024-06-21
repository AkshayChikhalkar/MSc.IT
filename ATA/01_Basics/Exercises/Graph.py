
# %%
import random
import math
import networkx as nx
import matplotlib.pyplot as plt
import matplotlib
import pandas as pd


from networkx.classes.graph import Graph
from networkx.algorithms.shortest_paths.weighted import _weight_function
from heapq import heappush, heappop
from itertools import count

matplotlib.rcParams.update({'font.size': 22, 'font.family': 'Arial'})


def dist(a, b):
    (x1, y1) = a
    (x2, y2) = b
    return ((x1 - x2) ** 2 + (y1 - y2) ** 2) ** 0.5

def draw(G, nodes, current, step, f_n, g_n, h_n):
    plt.figure(1, figsize=(8, 8))
    pos = nx.spring_layout(G, seed=3068)
    nx.draw(G, pos=pos, with_labels=True)
    nx.draw_networkx_edge_labels(G, pos)

    for e in nodes.keys():
        nx.draw_networkx(G.subgraph(e), pos=pos, node_color='red')
    
    nx.draw_networkx(G.subgraph(current), pos=pos, node_color='green')

    plt.show()

    frame = pd.DataFrame([f_n, g_n, h_n]).T
    frame = frame.rename(columns={0: 'f_n', 1: 'g_n', 2: 'h_n'})
    print(frame)

    
# Extended networkx a* implementation
def star(G, source, target, heuristic=None, weight="weight"):

    push = heappush
    pop = heappop
    weight = _weight_function(G, weight)

    # The queue stores priority, node, cost to reach, and parent.
    # Uses Python heapq to keep in priority order.
    # Add a counter to the queue to prevent the underlying heap from
    # attempting to compare the nodes themselves. The hash breaks ties in the
    # priority and is guaranteed unique for all nodes in the graph.
    c = count()
    queue = [(0, next(c), source, 0, None)]

    # Maps enqueued nodes to distance of discovered paths and the
    # computed heuristics to target. We avoid computing the heuristics
    # more than once and inserting the node into the queue too many times.
    enqueued = {}
    # Maps explored nodes to parent closest to the source.
    explored = {}

    f_n = {}
    g_n = {}
    h_n = {}

    step = 1
    while queue:

        # Pop the smallest item from queue.
        _, __, curnode, dist, parent = pop(queue)

        # End reached
        if curnode == target:
            path = [curnode]
            node = parent
            while node is not None:
                path.append(node)
                node = explored[node]
            path.reverse()
            return path

        if curnode in explored:
            
            # Do not override the parent of starting node
            if explored[curnode] is None:
                continue

            # Skip bad paths that were enqueued before finding a better one
            qcost, h = enqueued[curnode]
            
            if qcost < dist:
                continue


        for neighbor, w in G[curnode].items():

            weight_n = weight(curnode, neighbor, w)
            ncost = dist + weight_n

            if neighbor in enqueued:
                qcost, h = enqueued[neighbor]
                # if qcost <= ncost, a less costly path from the
                # neighbor to the source was already determined.
                # Therefore, we won't attempt to push this neighbor
                # to the queue
                if qcost <= ncost:
                    continue
            else:
                h = heuristic(neighbor, target)

            # Save results
            f_n[neighbor] = ncost + h
            g_n[neighbor] = ncost
            h_n[neighbor] = h

            explored[curnode] = parent

            enqueued[neighbor] = ncost, h
            push(queue, (ncost + h, next(c), neighbor, ncost, curnode))

        draw(G, {}, curnode, step, f_n, g_n, h_n)
        step += 1

# Create graph
G = nx.path_graph(5)
G = nx.grid_graph(dim=[3, 3])

# Add costs
c = {}
i = 1
for e in G.edges():
    c[e] = i
    i += 1

nx.set_edge_attributes(G, c, "cost")

# Calculate shortest path
path = star(G, (0, 0), (2, 2), heuristic=dist, weight="cost")
print(path)
