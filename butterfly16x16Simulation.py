#!/usr/bin/env python
import os
import subprocess
from inputGen import generateInputs
from inputGen import generateW

#from dataConversion import convertToInt
from dataConversion import convertTo2C

from computeFFT import computeFFT



wFloat = "wFloat.txt"
#da commentare se si usano gli esempi del professore
inputFloat = "butterfly16x16FloatData.txt"
#da commentare se si usano gli input casuale
#inputFloat = "esempiZamboni.txt"

w2C = "butterflyW.txt"
input2C = "butterfly16x16InputData.txt"

resTb = "butterfly16x16TbResults.txt"
resTbFloat = "butterfly16x16fftFloatResults.txt"
log = "log16x16.txt"
resFloat = "butterfly16x16tbFloatResults.txt"

#generazione dei file di input

#questa riga serve per il test col metodo Montecarlo
#da commentare se si usano gli esempi del professore
generateInputs(inputFloat,"random")
generateW(wFloat)

#conversione dei valori da float a binario complemento a 2

convertTo2C(wFloat, w2C)
convertTo2C(inputFloat, input2C)


#compliazione dei listati vhdl ed avvio del testbench

# Setting up environement variables
os.environ["PATH"] += os.pathsep + "/software/mentor/modelsim_6.5c/modeltech/linux_x86_64/"
os.environ["LM_LICENSE_FILE"] = "1717@led-x3850-1.polito.it"

# Print out environement variables
os.system("echo $PATH")
os.system("echo $LM_LICENSE_FILE")

# Launch Modelsim simulation
print ("Starting simulation...")
process = subprocess.call(["vsim", "-c", "-do", "compile.do"])
print ("Simulation completed")

#calcolo dei risultati attesi ed analisi degli errori

computeFFT(inputFloat, resTb, log,resFloat,resTbFloat)

ext = input('premi per uscire')