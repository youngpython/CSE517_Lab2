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
        
for i in range(2,10):
    print(expected(10**i))