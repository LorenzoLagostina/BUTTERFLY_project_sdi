
N = 19
def TransformToBin(val):
    floatVal = val * (2 ** N)
    intVal = int(round(floatVal))
    if intVal >= 2 ** 19:
        intVal -= 1
        
    if intVal <= -2**19:
        intVal += 1
        
    if intVal < 0:
        intVal = (intVal ^ ((2**20)-1)) +1         
    return intVal
    

def convertTo2C(intName,twoCName):
    
    try:
    #apri file
    #"butterflyGreatData.txt"
        fileReader = open(intName, "r")
        #"butterflySignedData.txt"
        fileWriter = open(twoCName, "w")
        for line in fileReader:
            listVal = line.split()
            for i in listVal:
                
                retVal = TransformToBin(float(i))
                
                if str(format(retVal, "020b"))[0] == '-': 
                    fileWriter.write(format(retVal, "020b")[1:] + " ")
                else:
                    fileWriter.write(format(retVal, "020b") + " ")
    
            fileWriter.write("\n")
        fileReader.close()
        fileWriter.close()
    
    
    except Exception as e:
        print(e)