# -*- coding: utf-8 -*-
from helper_class.infinity import counter

def repeat(fn):
    while 1:
      print (next(fn))

def run():
    print ("generator to Infinity")
    c = counter(10)
    print (next(c))

    print ("map square list")
    val = [next(c), next(c), next(c)]
    print (list(map(lambda x: x**2, val)))

    print ("filter < 0 list")
    val = range(-5,5)
    print (list(filter(lambda x: x<0, val)))

    print ("run out the counter")
    repeat(c)

run()
