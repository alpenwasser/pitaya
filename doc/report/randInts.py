#!/usr/bin/env python3

import random
from math import floor

cols = 15
rows = 5

#randlist = random.randint(5, 10)
population = range(0,75)
alphabetUpper = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','X','Y','Z']
alphabetLower = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','x','y','z']
for i in range(1,21):
    randlist = random.sample(population, i)
    k = 1
    for field in randlist:
        x = field % cols
        y = floor(field / cols)
        print('\pgfkeyssetvalue{/chapter ' + str(i) + '/hexagon ' + str(k) + '/x}{' + str(x) + '}')
        print('\pgfkeyssetvalue{/chapter ' + str(i) + '/hexagon ' + str(k) + '/y}{' + str(y) + '}')
        k += 1

for i in range(1,26):
    randlist = random.sample(population, i)
    k = 1
    for field in randlist:
        x = field % cols
        y = floor(field / cols)
        print('\pgfkeyssetvalue{/appendix ' + alphabetUpper[i-1] + '/hexagon ' + alphabetUpper[k-1] + '/x}{' + str(x) + '}')
        print('\pgfkeyssetvalue{/appendix ' + alphabetUpper[i-1] + '/hexagon ' + alphabetUpper[k-1] + '/y}{' + str(y) + '}')
        print('\pgfkeyssetvalue{/appendix ' + alphabetLower[i-1] + '/hexagon ' + alphabetLower[k-1] + '/x}{' + str(x) + '}')
        print('\pgfkeyssetvalue{/appendix ' + alphabetLower[i-1] + '/hexagon ' + alphabetLower[k-1] + '/y}{' + str(y) + '}')
        k += 1
