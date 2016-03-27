import os,glob
import numpy


files=glob.glob('trends_data/*')
#files=[files[0]]

of=open('trend_summary.txt','w')
for file in files:
    f=open(file)
    lines=f.readlines()
    term=lines[0].split(':')[1].lstrip(' ').strip()
    counts=[]
    for i in range(5,len(lines)):
        if not lines[i].find('-')>-1:
            break
        if lines[i].find('2015')>-1:
            count=lines[i].strip().split(',')[1]
            counts.append(int(count))
    print('%s: %0.2f'%(term,numpy.mean(counts)))
    of.write('%s\t%0.2f\n'%(term,numpy.mean(counts)))
of.close()
