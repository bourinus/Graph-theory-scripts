load("/home/epsi/Desktop/RO/graphes/Dijkstra.sage")

#variable declaration

#resale price
RV1=9
RV2=6
RV3=2
RV4=1
RV5=0
#buying price
PA=15
#maintenance cost
CE1=2
CE2=4
CE3=5
CE4=9
CE5=12

#costs calculations
l5=PA+CE1+CE2+CE3+CE4+CE5-RV5
l4=PA+CE1+CE2+CE3+CE4-RV4
l3=PA+CE1+CE2+CE3-RV3
l2=PA+CE1+CE2-RV2
l1=PA+CE1-RV1

M = matrix([[0, 10, 0, 30, 100],
            [0, 0, 50, 0, 0],
            [0, 0, 0,  0, 10],
            [0, 0, 20, 0, 60],
            [0, 0, 0,  0, 0]])
G = DiGraph(M, format="weighted_adjacency_matrix")
H = G.plot(edge_labels=True, graph_border=True)     #show weight
H.show()                                            #show graph

#
## call the function
print dijkstra_E(G, 0)
print dijkstra_Q(G, 0)
print dijkstra(G, 0)
