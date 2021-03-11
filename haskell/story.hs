#!/usr/bin/env stack
{- stack --system-ghc --resolver lts-17.5 script
--package "containers"
--package "mtl"
--package "parsec"
--package "text"
-}
module Main where
  import System.Environment
  import System.Exit
  import System.IO

  import Control.Monad
  import Data.Char
  import Data.Either
  import qualified Data.Map as Map
  import Data.Maybe
  import Text.ParserCombinators.Parsec
  import Text.Printf

  type Story = Map.Map String [String]

  main :: IO ()
  main = do
    makeStory "story.txt"

  display :: Story -> IO ()
  display m = do
    let ks = [ k | (k,v) <- Map.toList m ]
    displayEntry ks m

  -- format the display
  displayEntry :: [String] -> Story -> IO ()
  displayEntry [] _     = return ()
  displayEntry (x:xs) m = do
    let entry = makeEntry $ fromMaybe [] $ Map.lookup x m
    printf "%-8s\t%s\n" x entry
    displayEntry xs m

  makeEntry :: [String] -> String
  makeEntry []     = []
  makeEntry (x:xs) = x ++ "...  " ++ makeEntry xs

  makeStory :: FilePath -> IO ()
  makeStory x = do
    printf "%-20s ===\n" x
    result <- parseFromFile file x
    case result of
      Left err -> print err
      Right xs -> display $ listToMap xs

  -- | parser
  -- | identifier = digit character :
  -- | line       = comment | eol | identifier | item
  -- | expected content
  -- |   identifier: line
  comment :: Parser ()
  comment = do
    char '#'
    skipMany (noneOf "\r\n")
    <?> "comment"

  eol :: Parser ()
  eol = do
    oneOf "\n\r"
    return ()
    <?> "eol"

  file :: Parser [(String, [String])]
  file = do
    lines <- many line
    return (catMaybes lines)
    <?> "file"

  identifier :: Parser String
  identifier = do
    c <- digit <|> letter <|> char ':'
    cs <- many (digit <|> letter <|> char ':')
    return (c:cs)
    <?> "identifier"

  item :: Parser (String, [String])
  item = do
    key <- identifier
    skipMany space
    value <- manyTill anyChar (try eol <|> try comment <|> eof)
    return (key, [value])
    <?> "item"

  line :: Parser (Maybe (String, [String]))
  line = do
    skipMany space
    try (comment >> return Nothing) <|> fmap Just item
    <?> "line"

  -- listToMap -> Map String [String]
  listToMap :: [(String, [String])] -> Story
  listToMap []         = Map.empty
  listToMap ((k,v):xs) = Map.insertWith (++) k v (listToMap xs)
