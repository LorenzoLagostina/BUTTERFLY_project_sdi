import sys
sys.path.append("..")

import numpy as np
from scipy.fft import fft

def computeFFT(fileInput,fileResult,fileLog,fileResFloat,fileResTbFloat):
    
    fileIn = open(fileInput,"r")
    fileRes = open(fileResult,"r")
    fileL = open(fileLog,"w")
    fileResF = open(fileResFloat,"w")
    fileResFFT = open(fileResTbFloat,"w")
    values = np.array([0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
    relativeError = ([])
    meanErr=0.0
    nErr=0
    maxErr=0
    
    N = 2**15
        
    for line in fileIn:
        
        numbers = line.split(" ")
        if len(numbers) == 18:
            
 
            numbers.pop(0)
            for i in range(16):
                
                values[i] = float(numbers[i])
            
            #calcolo i valori attesi dell'fft
            attended = fft(values)
        
            resLine = fileRes.readline()
            results = resLine.split(" ")
            if len(results) == 17:
                results.pop(16)
                resLine = ""
                resFL = ""
                relativeError = ([])
                for i in range(16):
                    print(attended[i], float(results[i])/N)
                    relativeError.append(abs( ( attended[i].real - (float(results[i]) / N ))))
                    resLine+=(str(attended[i].real)+" ")
                    meanErr+=abs(attended[i].real - float(results[i]) / N)
                    nErr +=1
                    resFL += str(float(results[i]) / N) + " "
                    if abs( ( attended[i].real - (float(results[i]) / N) )) > maxErr:
                        maxErr = abs( ( attended[i].real - (float(results[i]) / N )))
                    
                fileResFFT.write(resLine+"\n")
                fileResF.write(resFL+"\n")
            resLine = fileRes.readline()
            results = resLine.split(" ")
            if len(results) == 17:
                results.pop(16)
                resLine = ""
                resFL = ""
                relativeError = ([])
                for i in range(16):
                
                    print(attended[i].imag, float(results[i])/N)
                    relativeError.append( ( attended[i].imag - (float(results[i]) / N ) ))
                    resLine+=(str(attended[i].imag)+" ")
                    meanErr+=abs(attended[i].imag - float(results[i]) / N)
                    nErr+=1
                    resFL += str(float(results[i]) / N) + " "
                    if abs( ( attended[i].imag - (float(results[i]) / N) )) > maxErr:
                        maxErr = abs( ( attended[i].imag - (float(results[i]) / N) ))
                fileResFFT.write(resLine+"\n")
            
                fileResF.write(resFL+"\n")
                resLine = ""

    meanErr /=nErr
    attErr = (2**(-13))
    fileL.write("Errore massimo: "+str(maxErr)+'\n')
    fileL.write("Errore medio: "+str(meanErr)+'\n')
    fileL.write("Rapporto tra errore ottenuto ed atteso: "+str(maxErr/attErr)+'\n')