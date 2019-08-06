module DisplayJSON ( displayJSON ) where

  import Data.Traversable

  import Asset
  import DisplayAsset
  import QueryJSON

  displayJSON :: Source -> IO ()
  displayJSON xs = do
    let d = [ y | x <- _source xs, let y = query x ]
    sequenceA d >>= display
