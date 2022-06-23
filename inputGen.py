import random
import math

def generateInputs(fileName,mode):
    #"butterfly2CData.txt"
    fileOut = open(fileName,"w")

    N = 10000

    if mode == "random":

        #genero N righe di 16 valori casuali tra -0.5 e 0.5 

        for _ in range(N):
    
            values = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]

            for i in values:
        
                i = (random.random()-0.5)
                fileOut.write(" "+str(i))
        
            fileOut.write(" \n")
        
        
def generateW(fileName):
    
    #creo i w seguendo le formule della teoria dell'fft
    fIn = open(fileName,"w")
    for m in range(0,17):
        WR = math.cos((math.pi/8)*m)
        WI = -math.sin((math.pi/8)*m)
        fIn.write(str(WR)+" "+str(WI)+" \n")

def generateCouples(fileName,N):
    
    
    fileOut = open(fileName,"w")
    couple = [-1.0,-1.0]
    
    #salvo nel file le coppie di valori float per la singola butterfly
    #le coppie sono le combinazioni dei numeri tra -1 ed 1 con un passo di 2**(-N)
    
    for _ in range(2**(N+1)):
        
        couple[1] = -1.0
        
        for _ in range(2**(N+1)):
            
            couple[1] += 2**(-N)
            fileOut.write(str(couple[0])+' '+str(couple[1])+' \n')
            
        couple[0] += 2**(-N)
    
    