def updateMaxErr(maxE,err):
    
    if err > maxE:
        
        return err
    
    else:
        
        return maxE
    
    



def computeSingle(inWName,inRName,inIName, resName):
    
    fileInW = open(inWName,"r")
    fileInR = open(inRName,"r")
    fileInI = open(inIName,"r")
    fileRes = open(resName,"r")
    fileTable = open('singleTable.txt','w')
    fileLog = open('logSingle.txt','w')
    convFact = 2**18
    
    totErr = 0.0
    nErr = 0
    meanErr = 0
    maxErr = 0
    fileTable.write('\\begin{center}\n\\begin{tabular}{||c c c c c c c||}\n\\hline\nA & B & W & A\'att & A\' & B\'att & B\' \\\\ [0.5ex]\n\\hline\\hline\n')
    for lineW in fileInW:
    
        inW = lineW.split(" ")
        Wr = float(inW[0])
        Wi = float(inW[1])
        fileInI.seek(0)
        
        for lineI in fileInI:
        
            fileInR.seek(0)
        
            inI = lineI.split(" ")
            Ai = float(inI[0])
            Bi = float(inI[1])
            for lineR in fileInR:
            
                inR = lineR.split(" ")
                
                Ar = float(inR[0])
                Br = float(inR[1])
                
                resR = fileRes.readline().split(" ")
                ArRes = float(resR[0])/convFact
                BrRes = float(resR[1])/convFact
                
                resI = fileRes.readline().split(" ")
                AiRes = float(resI[0])/convFact
                BiRes = float(resI[1])/convFact
                
                ArAtt = Ar + Br*Wr - Bi*Wi
                BrAtt = Ar - Br*Wr + Bi*Wi
                AiAtt = Ai + Br*Wi + Bi*Wr
                BiAtt = Ai - Br*Wi - Bi*Wr
                
                err = abs(ArAtt - ArRes)
                totErr += err
                maxErr = updateMaxErr(maxErr, err)
                
                err = abs(BrAtt - BrRes)
                totErr += err
                maxErr = updateMaxErr(maxErr, err)
                
                
                err = abs(AiAtt - AiRes)
                totErr += err
                maxErr = updateMaxErr(maxErr, err)
                
                
                err = abs(BiAtt - BiRes)
                totErr += err
                maxErr = updateMaxErr(maxErr, err)
                
                nErr += 4
                
                #print('errore massimo:',maxErr)
                #print('errore medio', totErr/nErr)
                #print('errore massimo su massimo possibile', maxErr/(2**17))            
                fileLog.write('Errore massimo: '+str(maxErr)+'\n')
                fileLog.write('Errore medio: '+str(meanErr)+'\n')
                fileLog.write('Rapporto tra errore ottenuto ed atteso: '+str(maxErr*(2**18))+'\n')
    
                
                
                fileTable.write(str(Ar)+' '+str(Ai)+'j&'+str(Br)+' '+str(Bi)+'j&'+str(Wr)+' '+str(Wi)+'j&'+str(ArAtt)+' '+str(AiAtt)+'j&'+str(ArRes)+' '+str(AiRes)+'j&'+str(BrAtt)+' '+str(BiAtt)+'j&'+str(BrRes)+' '+str(BiRes)+'j&\n\\hline\n')
                #print(inW, inI, inR, resI, resR)
    meanErr = totErr / nErr
    print('errore massimo:',maxErr)
    print('errore medio', totErr/nErr)
    print('errore massimo su massimo possibile', maxErr/(2**18))            
                    
    fileLog.write('Errore massimo: '+str(maxErr)+'\n')
    fileLog.write('Errore medio: '+str(meanErr)+'\n')
    fileLog.write('Rapporto tra errore ottenuto ed atteso: '+str(maxErr/(2**18))+'\n')
            
    fileTable.write('\\end{tabular}\\end{center}')
    
    fileLog.close()
    fileTable.close()
    fileInI.close()
    fileInR.close()
    fileInW.close()
    fileRes.close()