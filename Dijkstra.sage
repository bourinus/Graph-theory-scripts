"""Dijkstra Shortest paths algorithm for weighted directed graph
https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

:param G: a non void, simple, directed, connected weighted graph
:param i_0: a vertex in G from which to start the search

:returns: D: an array such that D[v] is the distance of a shortest path from i_0 to v.  
:returns: P: a dictionary of path in the form of list of vertex parents: P[v] is the parent of v.
:rtype: array, array

:Example:    

sage:    M = matrix([   
    [0, 10, 0, 30, 100],
    [0, 0, 50, 0, 0],
    [0, 0, 0,  0, 10],
    [0, 0, 20, 0, 60],
    [0, 0, 0,  0, 0]
    ])
    
sage: G = DiGraph(M, format='weighted_adjacency_matrix')

sage: print dijkstra(G, 0)
    ([0, 10, 50, 30, 60], [0, 0, 3, 0, 2])

.. note::
    case G==0
    find min(u,v) with path
"""

def dijkstra_0(G, i_0):
    """
    reference implementation 
    """
    # reshaped because bad presentation is bad
    bad_presentation = G.shortest_path_lengths(i_0, algorithm='Dijkstra_NetworkX', by_weight=True)
    D=list()
    for i in [0..len(bad_presentation)-1]:
        D.append(bad_presentation[i])
    return [D]

#

def dijkstra_E(G, i_0):
    """
    'E version': augmenting list of scanned nodes
        + Natural approach, easy to describe
        + quite fast 
        - more complex presentation, long initialisation
    """
    # Setup
    E = list()                                          # empty list of visited summit
    n = G.order() 
    D = [infinity] * n
    P = [infinity] * n
    # Initialisation:                                   # non trivial init D, P updated if direct edge from i_0
    for i in range(n-1):
        if( G.has_edge(i_0, i) ):                             
            D[i] = G.edge_label( i_0, i )                          
            P[i] = i_0                                  
    D[i_0] = 0                                          
    P[i_0] = i_0                
    E.append(i_0)    
    while (len(E) != n):
        distance_min = infinity                     
        for j in range(n):                               
            if(D[j]<distance_min and j not in E):       # minimization 'cannot' be externalised
                distance_min=D[j]       
                u = j                   
        E.append(u)                                     # add summit to visited list
        for v in G.neighbors(u):                        # relax           
            local = D[u] + G.edge_label(u, v) 
            if( G.edge_label(u, v) != 0 and local < D[v] and v not in E ):
                D[v] = local
                P[v] = u
    # Finishes
    return D, P


def dijkstra_Q(G, i_0):
    """
    'Q version': diminishing list of node to scan  
        + simple initialisation, algorithmically elegant' 
        + nice structure and presentation
        - far too slow implementation due to sorting in big Q list
    """
    # Setup
    Q = G.vertices()                                    # complete queue of nodes to scan      
    n = G.order() 
    D = [infinity] * n
    P = [infinity] * n                                            
    # Initialisation: 
    u=i_0
    D[i_0] = 0                          
    P[i_0] = i_0
    Q.remove(i_0)
    while Q:
        for v in G.neighbors(u):                        # relax  
            local = D[u] + G.edge_label(u, v)                
            if local < D[v]:
                D[v] = local
                P[v] = u
        u = mindist(D, Q)                               # minimise
        Q.remove(u)                                     # remove
    # Finishes
    return D, P



def gluttonous_dijkstra(G, i_0):
    """
    Modified Dijkstra 'Q version' to remove as many summit as possible each time
        +  reduction in the number of iterations 
        - not that faster, shouldn't be better ??
        ! this is not a dijsktra
        ! will return different P than Dijkstra algorithm
        https://arxiv.org/pdf/1212.6055.pdf
    """
    # setup
    Q = G.vertices()                                    # complete queue of nodes to visit
    n = G.order() 
    D_temp = [infinity] * n
    D = [infinity] * n
    P = [infinity] * n
    # Initialisation:
    u=[i_0]
    D[i_0] = 0                          
    P[i_0] = i_0
    Q.remove(i_0)
    while Q:                             
        for j in list(set(Q)):                          # relax
            for i in [0..len(u)-1]: 
                if G.has_edge(u[i], j) :                    
                    local = D[u[i]] + G.edge_label(u[i], j)
                    if local < D_temp[j]:
                        D_temp[j] = local 
        u = mindist2(D_temp, Q)                         # minimise
        for i in [0..len(u)-1]:
            D[u[i]]=D_temp[u[i]]                        # define D on summit where D-temp is min
            P[u[i]]=u[i]                                # define P on summit where D-temp is min
            Q.remove(u[i])                              # remove summit    
    # Finishes
    return D, P
 
def dijkstra_discovering_Q(G, i_0):
    """
    'Discovering the graph Q version': constructing list of node to scan while discovering graph 
        + Q is much smaller: faster implementation
        + less conditions: faster implementation
        ! real fast: reference implementation
    """
    # Setup:
    Q = list()                                          # incomplete queue of nodes to visit         
    n = G.order()     
    D = [infinity] * n
    P = [infinity] * n
    # Initialisation:
    u=i_0
    D[i_0] = 0                           
    P[i_0] = i_0                                           
    Q.append(i_0)
    while Q: 
        for v in G.neighbors(u):                        # relax
            local = D[u] + G.edge_label(u, v)  
            if local < D[v]:
                D[v] = local
                P[v] = u
                if v not in Q:
                    Q.append(v)                         # add v when reached 
        u = mindist(D, Q)                               # minimise
        Q.remove(u)                                     # remove        
    # Finishes
    return D, P

#
#
def dijkstra_unweighted(G, i_0):
    '''
    Shortest paths in a unweighted  graph using Dijkstra's algorithm.
 
    :param G: a simple, unweighted, undirected, connected graph. Thus each edge has unit weight.
    :param i_0: a vertex in G from which to start the search.
    :Example:  
    sage: G = graphs.PetersenGraph()

    sage: dijkstra(G, 0)

    ([0, 1, 2, 2, 1, 1, 2, 2, 2, 2], {1: 0, 2: 1, 3: 4, 4: 0, 5: 0, 6: 1, 7: 5, 8: 5, 9: 4})
 
    sage: G = Graph({0:{1:1, 3:1}, 1:{2:1, 3:1, 4:1}, 2:{4:1}})
    sage: dijkstra(G, 0)
    ([0, 1, 2, 1, 2], {1: 0, 2: 1, 3: 0, 4: 1})
    '''
    n = G.order()  # how many vertices
    m = G.size()   # how many edges
    D = [infinity for _ in range(n)]  # largest weights; represent +infinity
    D[i_0] = 0       # distance from vertex to itself is zero
    P = {}           # a dictionary for fast look-up
    Q = set(G.vertices())
    while len(Q) > 0:
        v = mindist(D, Q)
        Q.remove(v)
        Adj = set(G.neighbors(v))
        for u in Adj.intersection(Q):
            if D[u] > D[v] + 1:     # each edge has unit weight, so add 1
                D[u] = D[v] + 1
                P.setdefault(u, v)  # the parent of u is v
    return D, P

def mindist(D, Q):
    """
        return a vertex in Q such that it has minimal distance to the array D.

    """
    v = None                                             
    low = infinity                                   
    for u in Q:
        if D[u] < low:
            v = u
            low = D[v]
    return v    

def mindist2(D, Q):
    """
        return all vertices i in Q such that D[i] is min.
    """
    low = infinity 
    v=list() 
    for u in Q:
        if D[u] <= low:
            v.append(u) 
            if D[u] != low:
                low = D[u]
                v = [u]          
    return v 


folder_location="/home/david/Desktop/test"
import time as time_instance
import numpy as np
def timing_comparisons(alg_list, nb_point, nb_test):
    """
    timing comparisons, at each loop each test as same instance dijkstra(labyrinth(p,q))
    """
    startOverallTime = time_instance.clock()
    nb_alg = len(alg_list)
    D = np.full((nb_point, nb_alg), 1,dtype=float)
    out = list()
    G = labyrinth( 3, 4 )
    print 'Free run:', G
    for i in [0..nb_alg-1]:
        print 'algorithm', i
        out.append(alg_list[i](G,1)[0])
    status = True 
    for i in [0..nb_alg-2]: 
        status = status and out[i] == out[i+1]    
    if status==True:
        print 'Free run success: results are as expected.'
    else:   
        print 'better first having working algorithms dude.'
        H = G.plot(
        #layout='planar',
        color_by_label=True,
        edge_labels=False, 
        vertex_labels=True, 
        graph_border=False
        )     #show weight
        H.show() 
        print 'Dijkstra_NetworkX', G.shortest_path_lengths(1, algorithm='Dijkstra_NetworkX', by_weight=True)
        for i in [0..nb_alg-1]: print out[i]
        return 0    
    for i in [0..nb_point-1]:
        for cpt_test in [0..nb_test-1]:
            for j in [0..nb_alg-1]:
                #print 'Pass', i,'test', cpt_test, 'alg', j
                G = labyrinth( i+2, i+2 )
                startTime = time_instance.clock()
                alg_list[j](G,1)
                endTime = time_instance.clock()
                D[i, j] = endTime - startTime    
        for j in range(nb_alg): D[i, j] = D[i, j]/nb_test
    endOverallTime = time_instance.clock()
    print 'Timing comparisons in overall', endOverallTime - startOverallTime
    return D


'''
from sage.graphs.base.boost_graph import shortest_paths

H = G.plot(edge_labels=True, vertex_labels=True, graph_border=True)     #show weight
H.show() 

from sage.graphs.base.boost_graph import shortest_paths
print 'Dijkstra_NetworkX', G.shortest_path_lengths(1, algorithm='Dijkstra_NetworkX', by_weight=True)

load('/home/epsimaths/Desktop/RO/graphes/bellman_ford.sage')
print('bellman_ford', bellman_ford(G, G.vertices()[1]))

load('/home/epsimaths/Desktop/RO/graphes/floyd_warshall_roy.sage')
print('floyd_warshall_roy',floyd_warshall_roy(M))

print('shortest_path_all_pairs Floyd-Warshall-Python', G.shortest_path_all_pairs(by_weight = True, algorithm = 'Floyd-Warshall-Python'))
from sage.graphs.distances_all_pairs import distances_all_pairs
print('distances_all_pairs', distances_all_pairs(G))
from sage.graphs.distances_all_pairs import shortest_path_all_pairs
print('shortest_path_all_pairs BFS', G.shortest_path_all_pairs(by_weight = False, algorithm = 'BFS'))  
from sage.graphs.distances_all_pairs import floyd_warshall
print('floyd_warshall', floyd_warshall(G))
'''
