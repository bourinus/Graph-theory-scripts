def floyd_warshall_roy(A):
    """
    Shortest paths
    https://yetanothermathblog.com/2010/02/08/floyd-warshall-roy/

    INPUT: 
        A - weighted adjacency matrix 

    OUTPUT
        dist  - a matrix of distances of shortest paths
        paths - a matrix of shortest paths

    EXAMPLES:
        sage: A = matrix([[0,1,2,3],[0,0,2,1],[20,10,0,3],[11,12,13,0]]); A
        sage: floyd_warshall_roy(A)
        ([[0, 1, 2, 2], [12, 0, 2, 1], [14, 10, 0, 3], [11, 12, 13, 0]], 
          [-1  1  2  1]
          [ 3 -1  2  3]
          [ 3 -1 -1  3]
          [-1 -1 -1 -1])
        sage: A = matrix([[0,1,2,4],[0,0,2,1],[0,0,0,5],[0,0,0,0]])
        sage: floyd_warshall_roy(A)
        ([[0, 1, 2, 2], [+Infinity, 0, 2, 1], [+Infinity, +Infinity, 0, 5],
          [+Infinity, +Infinity, +Infinity, 0]], 
          [-1  1  2  1]
          [-1 -1  2  3]
          [-1 -1 -1  3]
          [-1 -1 -1 -1])
        sage: A = matrix([[0,1,2,3],[0,0,2,1],[-5,0,0,3],[1,0,1,0]]); A
        sage: floyd_warshall_roy(A)
        Traceback (click to the left of this block for traceback)
        ...
        ValueError: A negative edge weight cycle exists.
        sage: A = matrix([[0,1,2,3],[0,0,2,1],[-1/2,0,0,3],[1,0,1,0]]); A
        sage: floyd_warshall_roy(A)
        ([[0, 1, 2, 2], [3/2, 0, 2, 1], [-1/2, 1/2, 0, 3/2], [1/2, 3/2, 1, 0]],
          [-1  1  2  1]
          [ 2 -1  2  3]
          [-1  0 -1  1]
          [ 2  2 -1 -1])
    """

    G = Graph(A, format="weighted_adjacency_matrix")
    V = G.vertices()
    E = [(e[0],e[1]) for e in G.edges()]
    n = len(V)
    dist = [[0]*n for i in range(n)]
    paths = [[-1]*n for i in range(n)]
    # initialization step
    for i in range(n):
        for j in range(n):
            if (i,j) in E:
                paths[i][j] = j
            if i == j:
                dist[i][j] = 0
            elif A[i][j] != 0:
                dist[i][j] = A[i][j]
            else:
                dist[i][j] = infinity
    # iteratively finding the shortest path
    for j in range(n):
        for i in range(n):
            if i != j:
                for k in range(n):
                    if k != j:
                        if dist[i][k]>dist[i][j]+dist[j][k]:
                            paths[i][k] = V[j]
                        dist[i][k] = min(dist[i][k], dist[i][j] +dist[j][k])
    for i in range(n):
        if dist[i][i] < 0:
            raise ValueError, "A negative edge weight cycle exists."
    return dist, matrix(paths)   
