#
# Implementations of Dijkstra's algorithm
#

#
# Generates a length function of unit lenghts
#
def unit_lengths(D):
    l = { }
    for a in D.edges(labels = False):
        l[a] = 1

    return l

#
# Generates random lengths for the arcs of a directed graph
#
def random_lengths(D, max_length):
    l = { }
    for a in D.edges(labels = False):
        l[a] = randint(1, max_length)

    return l

#
# Returns True if a < b, where a value of 'None' represents infinity
#
def less(a, b):
    if a is None: return False
    if b is None: return True
    return a < b

#
# Checks the potential to see if Dijkstra's algorithm computed correctly
#
def check_potential(D, l, dist, parent):
    for a in D.edges(labels = False):
        u, v = a
        
        if dist[v] is None and not dist[u] is None:
            return False
        
        if not dist[u] is None and not dist[v] is None:
            if dist[v] - dist[u] > l[a]:
                return False
            if parent[v] == u and dist[v] - dist[u] != l[a]:
                return False

    return True

#
# Returns a list of vertices and arcs giving a shortest path between s
# and a vertex t
#
def shortest_path(parent, t):
    verts = [ ]
    arcs = [ ]

    v = t
    while not parent[v] is None:
        u = parent[v]
        verts = [ u ] + verts
        arcs = [ (u, v) ] + arcs
        v = u

    if arcs:
        verts.append(t)

    return verts, arcs

#
# Shows the arcs of a shortest path in color!
#
def show_path(D, parent, t):
    verts, arcs = shortest_path(parent, t)
    edge_colors = { 'red': arcs }
    return D.plot(edge_colors = edge_colors)

#
# Builds the 5-letter words graph
#
def five_letters(filename):
    # Reads the words
    V = [ ]
    with open(filename, 'r') as infile:
        for l in infile:
            if l.strip() != '':
                V.append(l.strip())

    # Divides the words into 5 different lists
    L = [ ]
    sort_key = lambda w: w[0]
    
    for k in xrange(5):
        tmp = [ ]
        for l in xrange(len(V)):
            v = V[l]
            tmp.append((v[0:k] + v[k + 1:], l))

        tmp.sort(key = sort_key)
        L.append(tmp)

    # Builds the graph
    D = DiGraph()
    D.add_vertices(V)

    for k in xrange(5):
        while L[k]:
            cluster = [ L[k].pop() ]
        
            while L[k] and L[k][-1][0] == cluster[0][0]:
                cluster.append(L[k].pop())

            for x, i in cluster:
                for y, j in cluster:
                    if i != j: D.add_edge(V[i], V[j])

    return D
load("/home/epsi/Desktop/RO/graphes/Dijkstra.sage")
