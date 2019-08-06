# -*- coding: utf-8 -*-
from helper_class.maybe import Maybe, Just, Nothing

def fromByteString(string):
    try:
        return string.decode()
    except ValueError:
        return string

def run():
    m0 = Just('a')
    m1 = Just('b')
    m2 = Just('c')
    m3 = Nothing()
    m4 = m0.append(m1)
    m5 = [m0, m1, m2]
    m6 = Just(b'{"result": "200"}') # example: result from a urllib call,
    m7 = Just(b'{"result": "503"}') #          non 200 result,
    m8 = Just(b'errorResult') #                and a failure.
    xs0 = list(map(lambda x: x.from_just().upper(), m5))
    xs1 = list(map(lambda x: fromByteString(x.from_just()), [m6, m7, m8]))

    print (m0)
    print (m1)
    print (m2)
    print (m3.is_nothing())
    print (m4)
    print (m5)
    print (m6)
    print (xs0)
    print (xs1)


run()
