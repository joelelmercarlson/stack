module Main where
  import System.Environment
  import System.Exit
  import System.IO

  import System.Directory
  import Data.Time
  import Text.Read (readMaybe)
  import Text.Printf

  import Util (nth)

  main :: IO ()
  main = do
    xs   <- getArgs

    case nth 1 xs of
      Just "org"   -> org
      Just "next"  -> next
      Just "study" -> study
      _            -> org

  createOrg :: String -> String -> String -> IO ()
  createOrg month date file = do
    putStrLn $ file ++ "..."
    createDirectoryIfMissing True month
    dir <- doesFileExist file
    if dir then
      (do s <- readFile file
          putStrLn s)
      else writeFile file (content date)

  currentTimePlusMinutes :: NominalDiffTime -> IO UTCTime
  currentTimePlusMinutes minutes = getCurrentTime
    >>= (\time -> return (addUTCTime (minutes * 60) time))

  org :: IO ()
  org = do
    time <- getCurrentTime

    let m = formatTime defaultTimeLocale "%B" time
        d = formatTime defaultTimeLocale "%Y-%m-%d" time
        f = m ++ "/" ++ d ++ ".org"
    createOrg m d f

  next :: IO ()
  next = do
    time <- currentTimePlusMinutes (24*60)

    let m = formatTime defaultTimeLocale "%B" time
        d = formatTime defaultTimeLocale "%Y-%m-%d" time
        f = m ++ "/" ++ d ++ ".org"
    createOrg m d f

  nextStudy :: [FilePath] -> Integer -> Integer
  nextStudy [] y = y + 1
  nextStudy (x:xs) y = case readMaybe x of
                         Nothing -> nextStudy xs y
                         Just x -> if x > y then nextStudy xs x else nextStudy xs y

  study :: IO ()
  study = do
    time      <- getCurrentTime
    directory <- listDirectory "Studies"

    let d  = nextStudy directory 0
        e  = printf "%02d" d
        dr = "Studies/" ++ e
        f  = dr ++ "/" ++ e ++ ".org"
        t  = formatTime defaultTimeLocale "%Y-%m-%d" time
    putStrLn $ f ++ "..."
    createDirectoryIfMissing True dr
    writeFile f (studyContent e t)

  content :: String -> String
  content x = "#+TITLE: Org\n" ++
    "#+AUTHOR: \"Joel E Carlson\" <joel.elmer.carlson@gmail.com>\n" ++
    "#+DATE: " ++ x ++ "\n" ++
    "#+KEYWORDS:\n" ++
    "\n\n" ++
    "* TODO <" ++ x ++ " 10:00 - 10:45> Agenda\n" ++
    "\n\n"

  studyContent :: String -> String -> String
  studyContent x y = "#+TITLE: Study " ++ x ++ "\n" ++
    "#+AUTHOR: \"Joel E Carlson\" <joel.elmer.carlson@gmail.com>\n" ++
    "#+DATE: " ++ y ++ "\n" ++
    "#+KEYWORDS: AEET Study\n" ++
    "\n\n" ++
    "* Study " ++ x ++ "\n\n" ++
    "** Abstract\n\n" ++
    "** Problem Statement\n\n" ++
    "** Team\n\n" ++
    "** Current Model\n\n" ++
    "** Proposed Model\n\n" ++
    "** Benefits\n\n" ++
    "** References\n\n" ++
    "\n\n"
