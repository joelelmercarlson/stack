#!/usr/bin/env stack
{- stack --system-ghc --resolver lts-16.18 script -}
module Main where
  import System.Environment
  import System.Exit
  import System.IO

  import Control.Arrow ((&&&))
  import Data.Char
  import Data.List
  import Data.Function (on)
  import Text.Printf

  main :: IO ()
  main = do
    d <- getContents

    let xs = filter (\x -> snd x > 0) $ map wordFilter $ wordCount d 
    display $ sndSort xs

  display :: [(String, Int)] -> IO ()
  display []     = return ()
  display (x:xs) = do
    printf "%-8d %s\n" (snd x) (fst x)
    display xs

  fstSort :: Ord a => [(a, b)] -> [(a, b)]
  fstSort = sortBy (flip compare `on` fst)

  lengthF :: (String, Int) -> (String, Int)
  lengthF (a, b) = if b > 1 then (a, b) else (a, 0)

  sndSort :: Ord b => [(a, b)] -> [(a, b)]
  sndSort = sortBy (flip compare `on` snd)

  wordCount :: String -> [(String, Int)]
  wordCount = map (head &&& length) . group . sort . words . map toLower

  wordF :: (String, Int) -> (String, Int)
  wordF (a, b) = case a of
                "to"  -> (a, 0)
                "and" -> (a, 0)
                "for" -> (a, 0)
                "be"  -> (a, 0)
                "are" -> (a, 0)
                "in"  -> (a, 0)
                "the" -> (a, 0)
                "of"  -> (a, 0)
                "with" -> (a, 0)
                "will" -> (a, 0)
                "where" -> (a, 0)
                "which" -> (a, 0)
                "week" -> (a, 0)
                "was" -> (a, 0)
                _     -> (a, b)

  wordFilter :: (String, Int) -> (String, Int)
  wordFilter a = lengthF $ wordL $ wordF a

  wordL :: (String, Int) -> (String, Int)
  wordL (a, b) = if length a > 1 then (a, b) else (a, 0)
