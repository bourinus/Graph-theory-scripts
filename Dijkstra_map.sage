"""
	Dijkstra maps
                                           
From a starting point in a labyrinth 
A p,q-labyrinth is discovered from a starting point,
at each step the longest visible path is tried
if failing to progress return to last choice and change



limit:
suited for rectangle labyrinthe


TBD:
maps= limited_dijkstra = Dijkstra(G,start, rayon)


"""
folder_location="/home/david/Desktop/test"
load( folder_location+"/Dijkstra.sage" )
load( folder_location+"/labyrinthe.sage" )

# different distances in a *,q labyrinth
def reduction(n):
 	return [ (n-n % q) /q, n % q]
def dist_euclidean(A,B):
	A=reduction(A)
	B=reduction(B)
	d = sqrt( (B[0]-A[0])^2 + (B[1]-A[1])^2 )
	return d
def dist_manathan(A,B):
	A=reduction(A)
	B=reduction(B)
	return sqrt( abs(B[0]-A[0]) + abs(B[1]-A[1]) )
def dist_minkowsky(A,B):
	A=reduction(A,q)
	B=reduction(B,q)
	return ( (B[0]-A[0])^p + (B[1]-A[1])^p )^(1/p)
def dist_tchebychev(A,B):
	A=reduction(A,q)
	B=reduction(B,q)
	return max( abs(B[0]-A[0]), abs(B[1]-A[1]) )

# function: to increase M 
def maximise_forwardness(V,D,M,maps,step):
	log( 'maximising forwardness from', V[-1] )
	step_max=10000 # unpassable wall
	best_point=0
	best_distance=0  
	for point in [0..len(maps)-1]:
		test = maps[point]
		if test<=step:
			if test>best_distance:
				log("  considered", point, "distance", test)
				best_point=point
				best_distance=test
	if best_distance == 0: M.append(D[-1])
	log( 'maximising forwardness with', best_point, "distance", best_distance)
	M.append(best_point)

# function: to increase m
def minimise_distance(D,m,maps,end_point,step):
	log( 'minimising distance to', end_point )
	best_point=0
	best_distance=infinity
	for point in [1..len(maps)-1]:
		test = dist_euclidean(point,end_point)
		if test<=step :
			if test<best_distance:
				log("  considered", point, "distance", round(test,2))
				best_point=point
				best_distance=test
	if best_distance==infinity: m.append(D[-1])
	log( 'minimising distance', best_point, "distance", round(best_distance,2) )
	m.append(best_point)

# function: to increase S 
def strategy_update(G,V,D,S,M,m):
	log( 'Update strategy ::' )
	# change if loop detected
	# change is possible 'I feel like going this way'
	if m[-1]!=infinity and S[-1]=="M":
		S.append("m")
	elif M[-1]!=0 and S[-1]=="m":	
		S.append("M")
	# continue if possible 'My faith is strong'
	elif M[-1]==M[-2] and S[-1]=="M":
		S.append("M")
	elif m[-1]==m[-2] and S[-1]=="m":	
		S.append("m")
	# error detected: 'I loosely admit failure and have to think about it'
	elif M[-1]!=M[-2] and m[-1]!=m[-2]:
		S.append("Error")
		error_analysis(G,V,D,S,M,m)

# re-spawn function: increase all list 
def error_analysis(G,V,D,S,M,m):
	log( 'error analysis to find re-spawn point ::' )
	# error detected => re-spawn
	for i in [0..len(D)-1]:
		if D[len(D)-i] not in V: 
			found=D[len(D)-i] # re-spawn at first possibility
			break
	V[found]=D[found][0][1] 
	maps=dijkstra_discovering_Q(G,V[-1])  	# maps is updated  
	minimise_distance(V,m,maps[0],end_point,q)	# m is augmented  
	maximise_forwardness(V,D,M,maps[0],q)    	# M is augmented 
	strategy_update(G,V,D,S,M,m)						# S is augmented 
												# D  

# function: to increase V
def find_vertice(V,S,M,m,complete_map,step):
	log( 'Going to new position' )
	if S[-1]=="m": goal=m[-1]
	if S[-1]=="M": goal=M[-1]
	i=goal
	l=[ ]
	while i != V[-1]:
		l.append(i)
		i=complete_map[i]
	l.append(V[-1])		# path backward reading
	print l
	if len(l)<step-1: pos=l[-1]
	else: pos=l[step-1]
	print V
	log('done')
	if pos==V[-1]:
		print "I am stuck ................................................", pos
	if len(V)>1 and pos==V[-2]:
		print "I am looping ................................................", pos
	else: 
		print 'going to ', pos
		V.append(pos)
#
# function: to increase D
def decision_detection(G,V,D,complete_map):
	log( 'decision_detection: Storing ignored path along the move' )
	# get vertices between V[i] et V[i-1]
	i=V[-1]
	l0=list()
	while i != V[-2]:
		l0.append(i)
		i=complete_map[i]
	log( 'l0', l0 )		
	# incident vertices along the way
	l1=list()		
	for s in l0:
		l1.append(G.edges_incident(s, labels=True, sort=True))
	log( 'l1', l1 )		
	# return edge ignored
	#l1=list(set(l1))
	L=list()
	for list_group in l1: 
		for l in list_group:
			if l[0] not in l0: L.append(l[0])
	log( 'L', L )
	for i in [0..len(L)-1]:
		if s not in V: D.append(L[i])
	log('decision_detection: end storing',)
"""
	A p,q labelled labyrinth is generated or created from file
			
								i
			
						-------------------------
						p 	p 	p 	p 	p 	p 	p
		
			| 	q 		S	0	0	0	0	0	0
		j	| 	q 		.	.  [0]	0	0	0	0
			| 	q 		.	0	0	.	.	.	.
			| 	q 		.	.	0	0	0	0	0
			| 	q 		0	0	0	.	0	.	E

	From a start_point till reaching end_point do:
		at each step alternate when possible between: 
			maximise march forwardness 
			minimise distance to end_point
			if failing to progress return to last ignored edge
"""
def ia_1(G,start_point,end_point,step):

	debug=True
	m=[start_point]			# m best minimising candidates
	M=[start_point]			# M best maximising candidates
	S=["m"]					# S strategy: at step i: "m" or "M"
	V=[start_point] 		# V vertices: at step i point was V[i]
	D=[[]] 					# D edges: at step i a list of edges were ignored
	log( 'Going to', end_point)
	log( 'Debug=True', m,M,S,V,D )
	while V[-1] != end_point:
		# [-1] last element of list
		maps=dijkstra_discovering_Q(G,V[-1])  				# maps is updated  
		log(maps)
		maximise_forwardness(V,D,M,maps[0],step)    			# M is augmented 
		minimise_distance(V,m,maps[0],end_point,step)			# m is augmented  
		strategy_update(G,V,D,S,M,m)						# S is augmented   
		find_vertice(V,S,M,m,maps[1],step) 					# V is augmented 
		decision_detection(G,V,D,maps[1]) 					# D is augmented  
		log( "end sss Loop:")

		log( "Loop:",len(V) )
		log( "parameter",M[-1],m[-1],S[-1],D[-1],V[-1] ) 
	return M,m,S,D,V


def log(*s): 
	if debug: print(s)
	
#
# Exec
p=18
q=5

print dist_euclidean(0,2)
file_path	=	folder_location+"/map.txt"
G = labyrinth_from_file(file_path)
G.set_latex_options(
	graphic_size=(350,350), #large value helps for large dense graphs
	vertex_size=.1,
	edge_thickness=0.03,
	)
H = G.plot(
	#layout='planar',
	color_by_label=True,
	edge_labels=False, 
	vertex_labels=True, 
	graph_border=True
	)     #show weight
H.show() 

debug=True
print ia_1(G,0,13,5)
#
#S =sub(G,1)
#H = S.plot(
#	#layout='planar',
#	color_by_label=True,
#	edge_labels=True, 
#	vertex_labels=True, 
#	graph_border=True
#	)
#H.show() 
#
#from sage.graphs.base.boost_graph import shortest_paths


# path = dijkstra_discovering_Q(G,0)[1]
# draw_path(G,path,0,85)
# H = G.plot(
# 	#layout='planar',
# 	color_by_label=True,
# 	edge_labels=False, 
# 	vertex_labels=True, 
# 	graph_border=True
# 	)
# H.show() 


#load(folder_location+"/Dijkstra.sage")
#load(folder_location+"/labyrinthe.sage")
#alg_list=[dijkstra_E, dijkstra_Q, gluttonous_dijkstra, dijkstra_0, dijkstra_discovering_Q ]
#tupu = timing_comparisons(alg_list,20,1)
#show(sage.plot.plot3d.list_plot3d.list_plot3d(tupu), grid=True)



