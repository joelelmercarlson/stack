# -*- coding: utf-8 -*-

class Monad():
    r"""The Monad abstract base class.

All instances of the Monad typeclass should obey the three monad laws:

    1) Left identity: return a >>= f = f a
    2) Right identity: m >>= return = m
    3) Associativity: (m >>= f) >>= g = m >>= (\x -> f x >>= g)
    """

    def bind(self, fn):
        """Monad bind method
        Python: bind(self: Monad[A], func: Callable[[A], Monad[B]]) -> Monad[B]
        Haskell: (>>=) :: m a -> (a -> m b) -> m b
        """
        raise NotImplementedError

    @classmethod
    def unit(cls, value):
        """Wrap a value in a default context.

        Haskell: return :: a -> m a .
        """
        return cls(value)

    def lift(self, func):
        """Map function over monadic value.

        Haskell: liftM :: (Monad m) => (a -> b) -> m a -> m b
        """
        return self.bind(lambda x: self.unit(func(x)))

    def join(self):
        """
        join :: Monad m => m (m a) -> m a
        """
        return self.bind(identity)

    def __or__(self, func):
        """Use | as operator for bind.
        Haskel: >>= operator
        """
        return self.bind(func)

    def __rshift__(self, next):
        """Then operator
        Haskell: (>>) :: m a -> m b -> m b
        """
        return self.bind(lambda _: next)