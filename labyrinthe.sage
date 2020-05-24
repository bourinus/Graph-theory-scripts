'''
p-q labyrinth

								i
			
						-------------------------
						p 	p 	p 	p 	p 	p 	p
		
			| 	q 		S	0	0	0	0	0	0
		j	| 	q 		.	.  [0]	0	0	0	0
			| 	q 		.	0	0	.	.	.	.
			| 	q 		.	.	0	0	0	0	0
			| 	q 		0	0	0	.	0	.	E
'''



#
# place at coordinates i,j a summit of weight w and link it to close summits
def place_weight(G,w,i,j,p,q):
	n=i+j*p
	if i<p-1: 										# right
		if G.has_edge(n,n+1) : G.delete_edge(n,n+1) 
		if G.has_edge(n+1,n) : G.delete_edge(n+1,n) 
		G.add_edges( [(n,n+1,w) ,(n+1,n,w)] ) 
	if i>0:  										# left
		if G.has_edge(n,n-1) : G.delete_edge( n,n-1 )
		if G.has_edge(n-1,n) : G.delete_edge( n-1,n )
		G.add_edges( [(n,n-1,w), (n-1,n,w)] ) 
	if j<q-1 :  									# down
		if G.has_edge(n,n+p) : G.delete_edge( (n+p,n) )
		if G.has_edge(n+p,n) : G.delete_edge( (n,n+p) )
		G.add_edges( [(n,n+p,w) ,(n+p,n,w)] ) 
	if j>0 : 										# up
		if G.has_edge(n,n-p) : G.delete_edge( (n,n-p) )
		if G.has_edge(n-p,n) : G.delete_edge( (n-p,n) )
		G.add_edges( [(n,n-p,w) ,(n-p,n,w)] ) 

#
# generate graph G of random p-q labyrinth
def labyrinth(p, q):
	# Init empty square graph
	G = DiGraph(sparse=True, weighted=True)
	for j in [0..q-1]:
		for i in [0..p-1]:
			place_weight(G,1,i,j,p,q)
	# place obstacle
	n=floor(p*q/7)		
	for j in [0..n-1]:
		r_p=randrange(0,p-1)
		r_q=randrange(0,q-1)
		place_weight(G,10000,r_p,r_q,p,q)
	return G

#
# create graph G of random p-q labyrinth from file 
def labyrinth_from_file(file_path):
	#file_path	=	"/home/epsi/Desktop/RO/graphes/map.txt"
	with open(file_path,"r") as file:
		lines = file.read().splitlines()
		q 	= 	len( lines[0] ) 
		p 	= 	len( lines )  
		file.close() 
	G = Graph(sparse=True, weighted=True) 			# Init emtpy square graph
	cpt_line = 0
	for line in lines:
		cpt_char = 0
		for char in line:
			if char == "0": 
				place_weight(G,1,cpt_line,cpt_char,p,q)
			cpt_char += 1
		cpt_line += 1
	cpt_line = 0
	for line in lines:
		cpt_char = 0		
		for char in line:
			if char == ".": 
				place_weight(G,10000,cpt_line,cpt_char,p,q)
			cpt_char += 1
		cpt_line += 1
	return G

#
# Modify a graph to highlight a shortest path
# 	dictionary path from i_0
# 	node from which return to i_0 
def draw_path(G, path, i_0, i_1):
	i=i_1
	while i != i_0:
		if G.has_edge(path[i],i): G.delete_edge(path[i],i) 
		G.add_edges([(path[i],i,777),(path[i],i,777)]) 
		i=path[i]

def sub(G,w):
	return 	G.subgraph(edge_property=(lambda e: e[2] == w)).to_simple()