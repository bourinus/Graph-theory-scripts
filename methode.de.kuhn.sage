#Licence : Attribution-NonCommercial-ShareAlike 4.0 International
#Python 2.7.12
#Version : 1.1 - Now french free
#By : Maël L'Hostis

'''

This program calculates the minimum cost of a matrix, and gives the affected task to every machine of the system.
It use two main function : index and khun.

index generates every possible combinason of indexes for a given matrix, and return an array containing all of them.
This function calls itself during the execution to be able to generate every combinason possible.

khun calculates all possible cost of the given matrix. It uses the function index to store all indexes of that matrix
and stores them in an array. It then uses this array to calculate the costs. The minimum cost is store in the variable minval.
khun return minval and the index corrresponding to that cost.

This program also benefits of a debug function : log.
It is able to write in the console a string with multiple variables, with the particularity that you can activate it or not when calling
for the function you want to debug. It has two level of debug.

Execution example:


Input a Square matrix :     [13, 4, 7, 6]
                            [1, 11, 5, 4]
                            [6, 7, 2, 8]
                            [1, 3, 5, 9]


Gives tasks affected to machines and the total cost:

                    Machine 0 is affected to task 1
                    Machine 1 is affected to task 3
                    Machine 2 is affected to task 2
                    Machine 3 is affected to task 0


                    For a total cost of 11

'''

#
# dependencies
import time


###################
#     function    #
###################

'''
  Fuction to write log in the console
  
  Parameter
      debug     :   boolean to activate or not the log
      s         :   string to write
      *variable :   optionnal variables tuple to write in the above string
                    you can write multiple variables, place them in the srting with {}
'''
def log(debug,s,*variables_tuple):
  
  if debug :
    i = 0
    while i < len(variables_tuple):
      cut = s.index('}') + 1                      #Find the index of the first }, and add one to it
      stemp = s[:cut]                             #Cut the string at the previous index
      stemp = stemp.format(variables_tuple[i])    #Replace {} with the variable i of the tuple
      s = stemp + s[cut:]                         #Put the piece of string back into s
      i += 1    
    print (s)

'''
  Function that generate the traversal indexes
  generate the optimal set to create all permutations of
  the indexes necessary to traverse the matrix so that no row and column
  are used more than once
  Parameter
      a : length of a matrix
      r : array that will contain indexes list
  Return variable
      r : return the index list to assign it to a array
'''
def index(a, r, debug1=False, debug2=False):
        #if the lenght of the matrix is equal to 1 clone the matrix in the indexes
        if len(a) == 1:
            r.insert(len(r), a)
            log(debug1,"Debug -- Matrix length equals 1, only one combinaison possible")
        else:
            log(debug1,"Debug -- Matrix length greater than 1, start to generated combinaison list")
            for i in range(0, len(a)):
                element = a[i]
               	b = [a[j] for j in range(0, len(a)) if j != i]
                subresults = []
                index(b, subresults)#call itself with new inputs and outputs
                for subresult in subresults:
                    result = [element] + subresult
                    log(debug2,"Debug -- result : {}", result)
                    r.insert(len(r), result)              
            log(debug1,"Debug -- Combinaison list generated, {} different combinaison possible", len(r))
        return r

'''
    Function that calculate the minimum cost of a matrix
    Uses the function index to generate all index combinaison possible      
    Parameter
        m : Square matrix
    Return variable
        minval : Minimum value generated during cost calculation
        finalIndex : The index on which the cost has been calculated
'''
def khun(m, debug1=False, debug2=False):
  t1 = time.time()
  log(debug1,"------------Start Calculating minimal cost of a matrix------------")
  log(debug1,"Debug -- matrix : {}\n", m)
  results = []
  results = index(range(len(m)), results, debug1, debug2)
  log(debug1,"Debug -- Index list generated\n")
  minval = sys.maxsize
  #calculation of the smallest cost of the combinations
  log(debug1,"Debug -- Start calculating the cost")
  for indexes in results:
          cost = 0
          for row, col in enumerate(indexes):
              cost += m[row][col]
          log(debug2,"Debug -- Index {} : cost = {}",indexes,cost)
          log(debug2,"Debug -- minval =  {} : cost = {}",minval,cost)
          if cost < minval : 
            log(debug2,"Debug -- cost lower than minval : minval is now equal to cost\n")
            finalIndex = indexes
          elif cost >= minval : 
            log(debug2,"Debug -- cost greater or equal to minval : minval stay unchange\n")
          minval = min(cost, minval)
  t2 = time.time()
  log(debug1,"Debug -- Minimum cost calculated : {}, Calculated in {} second\n", minval, t2-t1)
  log(debug1,"------------End of calulation of minimal cost of the matrix------------\n\n")
  return minval, finalIndex

#
# print some matrix stuff
def printMatrix(m):
  print "Square matrix :"
  i=0
  while i < len(m):
    print "\t\t",m[i]
    i+=1
  print "\n"

#
# print all in index
def printAffectation(index):
  i=0
  while i < len(index):
    print  "\t\tMachine {} is affected to task {}".format(i,index[i])
    i+=1
  print "\n"


###################
#       main      #
###################


#cost matrix
matrix1 = ([[82, 83, 69, 92],
           [77, 37, 49, 92],
           [11, 69, 5, 86],
           [8, 9, 98, 23]])


#cost matrix 2
matrix2 = ([[13, 4, 7, 6],
           [1, 11, 5, 4],
           [6, 7, 2, 8],
           [1, 3, 5, 9]])

matrix3 = ([[4]])


costMatrix1, indexMatrix1 = khun(matrix1,True,True)
printMatrix(matrix1)
printAffectation(indexMatrix1)
print "\t\tFor a total cost of {}\n\n".format(costMatrix1)


costMatrix2, indexMatrix2 = khun(matrix2,True,False)
printMatrix(matrix2)
printAffectation(indexMatrix2)
print "\t\tFor a total cost of {}\n\n".format(costMatrix2)

costMatrix3, indexMatrix3 = khun(matrix3)
printMatrix(matrix3)
printAffectation(indexMatrix3)
print "\t\tFor a total cost of {}\n\n".format(costMatrix3)



