import os

ext = '.py'
language='Python'
fileOut = open('listatiLatex.txt','w')
for file in os.listdir():

    if file.endswith(ext):
    
        fileIn = open(file,'r')
    
        fileOut.write('\\subsection{'+file+'}\n\\begin{lstlisting}[language='+language+']\n')
    
        for line in fileIn:
        
            fileOut.write(line)
        
        fileOut.write('\\end{lstlisting}')
        fileIn.close()
fileOut.close()