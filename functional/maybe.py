# -*- coding: utf-8 -*-
from .monad import Monad

class Maybe(Monad):
    """Encapsulates an optional value.

    The Maybe type encapsulates an optional value. A value of type
    Maybe a either contains a value of (represented as Just a), or it
    is empty (represented as Nothing). Using Maybe is a good way to deal
    with errors or exceptional cases without resorting to drastic
    measures such as error.

    https://github.com/dbrattli/OSlash
    """

    def bind(self, fn):
        raise NotImplementedError

    def map(self, mapper):
        raise NotImplementedError

    def apply(self, something):
        raise NotImplementedError

    @classmethod
    def empty(cls):
        return Nothing()

    def append(self, other):
        raise NotImplementedError

    def from_just(self): 
        raise NotImplementedError

    @property
    def is_nothing(self):
        return False

    @property
    def is_just(self):
        return False

    def from_maybe(self, default):
        raise NotImplementedError

    def __eq__(self, other):
        raise NotImplementedError

    def __repr__(self):
        return self.__str__()

    def __bool__(self):
        return False

class Just(Maybe):
    """A Maybe that contains a value.
    Represents a Maybe that contains a value (represented as Just a).
    """
    def __init__(self, value):
        self._value = value

    def map(self, mapper):
        # fmap f (Just x) = Just (f x)

        value = self._value
        try:
            result = mapper(value)
        except TypeError:
            result = partial(mapper, value)

        return Just(result)

    def apply(self, something):
        return something.map(self._value)

    def append(self, other):
        # m `append` Nothing = m
        if other.is_nothing:
            return self

        other_value = other.from_just()

        # Use + for append if no append
        value = self._value
        if not hasattr(other_value, "append"):
            return Just(value + other_value)

        # Just m1 `append` Just m2 = Just (m1 `append` m2)
        return Just(value.append(other_value))

    def bind(self, func):
        """Just x >>= f = f x."""

        value = self._value
        return func(value)

    def from_just(self):
        return self._value

    def from_maybe(self, default):
        return self._value

    def is_just(self):
        return True

    def __bool__(self):
        """Convert Just to bool."""
        return bool(self._value)

    def __eq__(self, other):
        """Return self == other."""
        if other.is_nothing:
            return False

        return self._value == other.from_just()

    def __str__(self):
        return "Just %s" % self._value


class Nothing(Maybe):
    """Represents an empty Maybe.

    Represents an empty Maybe that holds nothing (in which case it has
    the value of Nothing).
    """

    def map(self, mapper):
        return Nothing()

    def apply(self, other):
        return Nothing()

    def append(self, other):
        return other

    def bind(self, func):
        """Nothing >>= f = Nothing

        Nothing in, Nothing out.
        """

        return Nothing()

    def from_just(self):
        raise Exception("Nothing")

    def from_maybe(self, default):
        return default

    def is_nothing(self):
        return True

    def __eq__(self, other):
        return isinstance(other, Nothing)

    def __str__(self):
        return "Nothing"



