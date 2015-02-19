# -*- coding: utf-8 -*-
"""
Created on Sat Feb 14 14:26:37 2015

Recursive Function for Bagging (CSE 517 HW 2 Problem 4d)
@author: Danny Munro 423280
"""
import numpy as np

def p(m,k,n): #Calculate probability of an individual ratio of unique pairs
    if isinstance(m,int) and isinstance(k,int) and isinstance(n,int):    
        #if(m > 0 and k > 0 and n > 0):        
        if m == 1 and k == 1:
            return 1
        elif k == 1:
            return 0
        elif m == 1:
            return 1/(n**k)
        else:
            return (m/n)*p(m,k-1,n) + ((n-m)/n)*p(m-1,k-1,n)
        #else:
        #    raise TypeError("m,k and n must be positive")
    else:
        raise TypeError("m,k and n must be ints")
       
'''
def p(m,k,n):
    if isinstance(m,int) and isinstance(k,int) and isinstance(n,int):    
        pvalues = [[0 for x in range(m+1)] for x in range(k+1)]        
        for i in range(m):
            pvalues[i][1] = 0
        print(k)
        for j in range(k):
            print(j)
            pvalues[1][j] = 1/(n**j)
        pvalues[1][1] = 1
        for i in range(2,m+1):
            for j in range(2,k+1):
                pvalues[i][j] = (i/n)*pvalues[i,j-1,n] + \
                    ((n-i)/n)*pvalues[i-1,j-1,n]
        return pvalues[m][k]
    else:
        raise TypeError("m,k and n must be ints")
'''
'''
def p(m,k,n):
    pvalues = np.zeros((m+1,k+1))
    pvalues[:,1] = 0
    pvalues[1,:] = 1/(n^range(k))
    pvalues[1,1] = 1
    if m>1 and k>1:
       for i in range(2,m+1):
           for j in range(2,k+1):
               pvalues[i,j] = (i/n)*pvalues[i,j-1] + ((n-i)/n)*pvalues[i-1,j-1]
    return pvalues[m,k]
'''
def expected(n):
    if isinstance(n,int):    
        if n > 0:
            expected_value = 0
            for i in range(1,n):
                expected_value += (i/n)*p(i,n,n)
            return expected_value
        else:
            print("m,k and n must be positive")
    else:
        raise TypeError("m,k and n must be ints")
        
for i in range(2,5):
    print(expected(10**i))