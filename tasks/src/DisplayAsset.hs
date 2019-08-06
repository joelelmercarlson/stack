module DisplayAsset ( display ) where

  import Data.Either
  import Data.Maybe
  import qualified Data.Map as M
  import Data.Time.Clock.POSIX
  import Text.Printf

  import Asset
  import Util

  display :: [Either String Asset] -> IO ()
  display [] = return ()
  display xs = do
    let ls = partitionEithers xs

    displayFrameworkHeader
    if not (null (fst ls))
    then
      print (fst ls)
    else
      displayFrameworkContent (snd ls)

  displayFrameworkContent :: [Asset] -> IO ()
  displayFrameworkContent []     = return ()
  displayFrameworkContent (x:xs) = do
    displayFrameworkInfo $ _frameworks $ _getFrameworks x
    displayFrameworkContent xs

  displayFrameworkHeader :: IO ()
  displayFrameworkHeader = do
    printf "|%s|%s|%s|%s|\n" "timestamp" "name" "id" "USED: cpus, gpus, mem, disk"
    printf "|%s|%s|%s|%s|\n" ":----" ":----" ":----" ":----"

  -- | displayFrameworkInfo - aggregate all resources for a framework
  displayFrameworkInfo :: [FrameworkInfo] -> IO ()
  displayFrameworkInfo []     = return ()
  displayFrameworkInfo (x:xs) = do
    tm <- round `fmap` getPOSIXTime
    let d     = _frameworkInfo x
        r     = _allocatedResources x
        name  = _name d
        value = _value $ _id d
        rm    = makeMyMap $ getResource r
        cpus  = fromMaybe 0.0 $ M.lookup "cpus" rm
        gpus  = fromMaybe 0.0 $ M.lookup "gpus" rm
        mem   = fromMaybe 0.0 $ M.lookup "mem"  rm
        disk  = fromMaybe 0.0 $ M.lookup "disk" rm
    printf "|%s|%s|%s| %-4.2f,%-4.2f,%-4.2f,%-4.2f |\n" (show tm) (serviceName name) value cpus gpus (gib mem) (gib disk)
    displayFrameworkInfo xs

  getResource :: Maybe [Resource] -> [(String, Float)]
  getResource Nothing   = [ ("cpus", 0.0)
                          , ("gpus", 0.0)
                          , ("mem", 0.0)
                          , ("disk", 0.0)
                          ]
  getResource (Just xs) = [ (z, y) | x <- xs
                          , let y = getNumber $ __scalar x
                          , let z = __name x
                          ]

  -- | getNumber - nested Maybe
  getNumber :: Maybe Number -> Float
  getNumber Nothing  = 0.0
  getNumber (Just x) = __value x

  type SFMap = M.Map String Float

  makeMyMap :: [(String, Float)] -> SFMap 
  makeMyMap []          = M.empty
  makeMyMap ((k, v):xs) = M.insertWith (+) k v (makeMyMap xs)
