def bellman_ford(G, s):
    """
    Computes the shortest distance from s to all other vertices in Gamma.
    If Gamma has a negative weight cycle, then return an error.

    INPUT:

    - Gamma -- a graph.
    - s -- the source vertex.

    OUTPUT:

    - (d,p) -- pair of dictionaries keyed on the list of vertices,
      which store the distance and shortest paths.

    REFERENCE:

    http://en.wikipedia.org/wiki/Bellman-Ford_algorithm
    """
    from sage.rings.infinity import Infinity
    P = []
    dist = {}
    predecessor = {}
    V = G.vertices()
    N = G.num_verts()
    E = G.edges()
    for v in V:
        if v == s:
            dist[v] = 0
        else:
            dist[v] = Infinity
        predecessor[v] = 0
    W = {}
    for e in E:
        W[(e[0],e[1])] = e[2]
        W[(e[1],e[0])] = e[2]
    A = set([s])
    B = set()
    cpt = 0
    while len(A) > 0 and cpt < N:
        while len(A) > 0:
            u = A.pop()
            for v in G.neighbor_iterator(u):
                if dist[u] + W[(u,v)] < dist[v]:
                    dist[v] = dist[u] + W[u,v]
                    predecessor[v] = u
                    B.add(v)
        A = B.copy()
        B.clear()
        cpt += 1
    # check for negative-weight cycles
    for e in E:
	u = e[0]
        v = e[1]
        wt = e[2]
        if dist[u] + wt < dist[v]:
            raise ValueError("Graph contains a negative-weight cycle")
    return dist, predecessor