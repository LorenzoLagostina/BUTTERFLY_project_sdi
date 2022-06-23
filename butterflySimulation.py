import os
import subprocess

from inputGen import generateCouples
from inputGen import generateW

from dataConversion import convertTo2C

from computeSingle import computeSingle

inputFloatReal = "butterflyFloatRealData.txt"
inputFloatImag = "butterflyFloatImagData.txt"

wFloat = "wFloat.txt"

#generazione dei file diinput

#generateCouples(inputFloatReal,3)
#generateCouples(inputFloatImag,3)
#generateW(wFloat)

#conversione dei valori float in complemento a 2

input2CR = "butterflyInputRealData.txt"
input2CI = "butterflyInputImagData.txt"
w2C = "butterflyW.txt"

convertTo2C(wFloat, w2C)
convertTo2C(inputFloatReal, input2CR)
convertTo2C(inputFloatImag, input2CI)

resTb = "butterflyTbResults.txt"

#compilazione dei listati vhdl ed avvio del testbench

# Setting up environement variables
os.environ["PATH"] += os.pathsep + "/software/mentor/modelsim_6.5c/modeltech/linux_x86_64/"
os.environ["LM_LICENSE_FILE"] = "1717@led-x3850-1.polito.it"

# Print out environement variables
os.system("echo $PATH")
os.system("echo $LM_LICENSE_FILE")

# Launch Modelsim simulation
print ("Starting simulation...")
process = subprocess.call(["vsim", "-c", "-do", "compileSingle.do"])
print ("Simulation completed")

#calcolo dei valori attesi ed analisi degli errori
computeSingle(wFloat , inputFloatReal, inputFloatImag, resTb)

ext = input('premi per uscire')