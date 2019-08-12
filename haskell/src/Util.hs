module Util ( nth
            , big
            , mib
            , gib
            , tib
            ) where

  import Data.Char
  import Data.List

  -- | nth safe chooser
  nth :: Int -> [a] -> Maybe a
  nth _ []     = Nothing
  nth 1 (x:_)  = Just x
  nth n (x:xs) = nth (n - 1) xs

  -- | names valid: [a-z0-9-./]
  names :: String -> String
  names x = intercalate "-" $ words $ map toLower x

  -- | replace 'a' 'b' "aabb"
  replace :: Eq a => a -> a -> [a] -> [a]
  replace a b = map (\c -> if c == a then b else c)

  -- | helper functions: big, mib, gib, tib
  big :: Float -> String
  big x
    | x >= mib * mib * mib = "PiB"
    | x >= mib * mib       = "TiB"
    | otherwise            = "GiB"

  mib :: Float
  mib = 1024.0

  gib :: Float -> Float
  gib x
    | x > 1.0   = x / mib
    | otherwise = x

  tib :: Float -> Float
  tib x
    | x >= mib  = x / mib
    | otherwise = x
