import pandas as pd
import matplotlib.pyplot as plt

f = pd.read_csv("pull_pullx.xvg", sep="\s+",skiprows=17,header=None)

for j in range(15):
    d=0.6+(j*0.2)
    l=0
    for k,i in enumerate(f[1]):
        if (abs(float(i)) > (d-0.00001)) and (abs(float(i)) < (d+0.00001)):
            print (int(d*10),f[0][k],i)
            l+=1
            break
    if (l==0):
        for k,i in enumerate(f[1]):
            if (abs(float(i)) > (d-0.0001)) and (abs(float(i)) < (d+0.0001)):
                print (int(d*10),f[0][k],i)
                l+=1
                break
        if (l==0):
            for k,i in enumerate(f[1]):
                if (abs(float(i)) > (d-0.001)) and (abs(float(i)) < (d+0.001)):
                    print (int(d*10),f[0][k],i)
                    l+=1
                    break



