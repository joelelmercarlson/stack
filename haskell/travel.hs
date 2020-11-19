#!/usr/bin/env stack
{- stack --system-ghc --resolver lts-16.20 script
--package "text"
--package "vector"
-}
{-# LANGUAGE OverloadedStrings #-}
module Main where
  import System.Environment
  import System.Exit
  import System.IO

  import Data.List
  import Data.Function (on)
  import Data.Vector (Vector, fromList, (!))
  import Text.Printf


  coordinates :: Vector (Float, Float)
  coordinates = fromList [ (0,0), (1,0), (0,2), (1,1), (4,6), (2,3), (2,4) ]

  distance :: (Float, Float) -> (Float, Float) -> Float
  distance (x1,y1) (x2,y2) = sqrt ((x1-x2)^2 + (y1-y2)^2)

  tourLength ::  Vector (Float, Float) -> [Int] -> Float
  tourLength pairs tour = let coords = [ y | x <- tour, let y = pairs ! x ]
                          in sum $ zipWith distance coords (tail coords)

  display :: [([Int], Float)] -> IO ()
  display [] = return ()
  display (x:xs) = do
    display' x
    display xs

  display' :: ([Int], Float) -> IO ()
  display' (k, v) = printf "route %s is length %2.2f\n" (show k) v

  mapTour :: [[Int]] -> [([Int], Float)]
  mapTour xs = [(k, v) | k <- xs, let v = tourLength coordinates k]

  fstSort :: Ord a => [(a, b)] -> [(a, b)]
  fstSort = sortBy (flip compare `on` fst)

  sndSort :: Ord b => [(a, b)] -> [(a, b)]
  sndSort = sortBy (flip compare `on` snd)

  main :: IO ()
  main = do
    let tour = [1 .. 6]
        tours = permutations tour
    display' $ last (sndSort $ mapTour tours)


