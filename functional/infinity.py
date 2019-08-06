# -*- coding: utf-8 -*-
r"""
    Modularity¶
A more practical benefit of functional programming is that it forces you to break apart your problem into small pieces. Programs are more modular as a result. It’s easier to specify and write a small function that does one thing than a large function that performs a complicated transformation. Small functions are also easier to read and to check for errors.

    Composability¶
    As you work on a functional-style program, you’ll write a number of functions with varying inputs and outputs. Some of these functions will be unavoidably specialized to a particular application, but others will be useful in a wide variety of programs. For example, a function that takes a directory path and returns all the XML files in the directory, or a function that takes a filename and returns its contents, can be applied to many different situations.
-  https://docs.python.org/3/howtofunctional.html
"""

def counter(maximum):
    """ generator function """
    i = 0
    while i < maximum:
        val = (yield i)
        if val is not None:
            i = val
        else:
            i+=1

if __name__ == '__main__':

    print ("generator to Infinity")
    c = counter(10)
    print (next(c))

    print ("map square list")
    val = [next(c), next(c), next(c)]
    print (list(map(lambda x: x**2, val)))

    print ("filter < 0 list")
    val = range(-5,5)
    print (list(filter(lambda x: x<0, val)))
