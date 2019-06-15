#!/usr/bin/env stack
{- stack --system-ghc --resolver lts-13.15 script -}
module Main where
  import System.Environment
  import System.Exit
  import System.IO

  import Data.Char
  import Data.List
  import Data.Function (on)

  main :: IO ()
  main = do
    xs <- getContents
    let ys = map toLower xs
        count = [ (x, c) | x <- ['a' .. 'z'], let c = (length.filter (==x)) ys, c > 0]

    print $ sndSort count

  sndSort :: Ord b => [(a, b)] -> [(a, b)]
  sndSort = sortBy (flip compare `on` snd)
