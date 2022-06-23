fileTable = open('latexTable.txt','w')

fileInput = open('esempiZamboni.txt','r')
fileAttended = open('butterfly16x16fftFloatResults.txt','r')
fileResults = open('butterfly16x16tbFloatResults.txt','r')

    
for lineIn in fileInput:
    fileTable.write('\\begin{center}\n\\begin{tabular}{||c c c||}\n\\hline\nInput & Atteso & Risultato \\\\ [0.5ex]\n\\hline\\hline\n')
    cleanLineIn = lineIn[:-2]
        
    dataIn = cleanLineIn.split(' ')
        
    lineAtt = fileAttended.readline()[:-2]
    dataAttReal = lineAtt.split(' ')
        
    lineAtt = fileAttended.readline()[:-2]
    dataAttImag = lineAtt.split(' ')
        
    lineRes = fileResults.readline()[:-2]
    dataResReal = lineRes.split(' ')
        
    lineRes = fileResults.readline()[:-2]
    dataResImag = lineRes.split(' ')
        
    for i in range(16):
        
        fileTable.write(dataIn[i+1]+ '&'+dataAttReal[i]+' '+dataAttImag[i] +'j&'+dataResReal[i]+' '+ dataResImag[i]+ 'j&\n\\hline\n')
        
    fileTable.write('\\end{tabular}\\end{center}')
    
