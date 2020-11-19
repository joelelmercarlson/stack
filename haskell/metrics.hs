#!/usr/bin/env stack
{- stack --system-ghc --resolver lts-16.20 script
--package "bytestring"
--package "cassava"
--package "text"
--package "vector"
-}
{-# LANGUAGE OverloadedStrings #-}
module Main where
  import System.Environment
  import System.Exit
  import System.IO

  import qualified Data.ByteString.Lazy as BSL
  import Prelude hiding (filter)
  import Data.Csv
  import Data.List (nub, sort)
  import Data.Vector (Vector, filter, toList)
  import Text.Printf

  main :: IO ()
  main = do
    d <- BSL.readFile "metrics.csv"
    let a = decode NoHeader d :: Either String (Vector (String, Float))
    case a of
      Left  err -> print err
      Right xs  -> makeMap xs

  buildKV :: String -> Vector (String, Float) -> (String, [Float])
  buildKV k vs = (k,v)
    where
      v  = elementN 7 xs
      xs = [ y | (x,y) <- toList $ lookupVS k vs ]

  buildKVs :: Vector (String, Float) -> [(String, [Float])]
  buildKVs vs = map (`buildKV` vs) ks
    where
      ks = nub $ sort xs
      xs = [ x | (x,y) <- toList vs ]

  display :: [(String, [Float])] -> IO ()
  display []         = return ()
  display ((k,v):xs) = do
    printf "%s %s\n" k (unwords $ map show v)
    display xs

  elementN :: Int -> [Float] -> [Float]
  elementN x vs = take x $ vs ++ replicate x 0

  lookupVS :: String -> Vector (String, Float) -> Vector (String, Float)
  lookupVS x = filter (\y -> fst y == x)

  makeMap :: Vector (String, Float) -> IO ()
  makeMap vs = do
    gnuPlotH
    display $ buildKVs vs
    gnuPlotF

  -- | gnuplot
  gnuPlotH :: IO ()
  gnuPlotH = do
    printf "set terminal svg\n"
    printf "set output \"weekly.svg\"\n"
    printf "unset key\n"
    printf "set view map scale 1\n"
    printf "set style data lines\n"
    printf "set title \"cpu heat map\"\n"
    printf "set xtics border in scale 0,0 mirror norotate autojustify norangelimit\n"
    printf "set ytics border in scale 0,0 mirror norotate autojustify norangelimit\n"
    printf "set rtics border in scale 0,0 mirror norotate autojustify\n"
    printf "set cblabel \"cpu utilized\"\n"
    printf "set cbrange [ 0.0 : 56.0 ] noreverse nowriteback\n"
    printf "set palette rgbformulae 21,22,23\n"
    printf "$map << EOD\n"
    printf "Sun Mon Tue Wed Thu Fri Sat \n"

  gnuPlotF :: IO ()
  gnuPlotF = do
    printf "EOD\n"
    printf "plot $map matrix rowheaders columnheaders using 1:2:3 with image\n"
