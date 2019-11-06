# Converting QAPLIB files to csv and numpy file formats
#
# Created by Ali S. Mazloom on 8/10/19.
# Copyright © 2019 Ali S. Mazloom. All rights reserved.

import numpy as np
import sys
import os

def main():
  os.system('clear')

# read the dataset   
  QAP = []
  with open(sys.argv[1]) as txt_file:
    for line in txt_file:
      QAP.append(line.rstrip('\n').split())
  txt_file.close()

  # retrieve problem size
  n = int(QAP[0][0])

# parse .dat file into distance and flow matrices
  def parseFile(matrix, size):
    v = np.zeros((0,size))
    c = np.zeros((3,size**2)).astype(np.int)
    r = len(matrix)
    l = 0
    s = 1
    c[0,0] = size

    for i in range(r):
      if l >= size * size:
        s = 2
        l = 0
      for j in range(len(matrix[i])):
        v = np.asarray(matrix[i:i+1])
        if (i != 0) | (j != 0):
            c[s,l] = int(v[0][j])        
            l +=1

    # for i in range(3):
    #   for j in range(size**2):
    #       c[i][j] = int(c[i][j])
    return c

  filename = 'lipa90aa'

  tb = parseFile(QAP, n)
  # dump distance dataset into .in and .csv files
  #np.savetxt(filename + '.csv', tb, delimiter=",")
  tb = np.genfromtxt(filename + '.csv', delimiter=',')
  np.savetxt(filename + '.in', tb, delimiter=",")
  #np.save(filename + '_dist.npy',tb)

if __name__ == '__main__':
  main()