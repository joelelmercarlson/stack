module Main where

  import System.Environment
  import System.Exit
  import System.IO

  import Data.Maybe

  import Asset
  import DisplayAsset
  import DisplayJSON
  import QueryJSON
  import Util

  test :: String
  test = "data/mesos-test.json"

  main :: IO ()
  main = do
    xs <- getArgs

    let json = fromMaybe test (nth 1 xs)
    d <- loadSource json
    case d of
      Left err -> putStrLn err
      Right xs -> displayJSON xs
