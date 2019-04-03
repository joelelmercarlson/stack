{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_org (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,0,1,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/jcarl16/stack/.stack-work/install/x86_64-osx/lts-13.15/8.6.4/bin"
libdir     = "/Users/jcarl16/stack/.stack-work/install/x86_64-osx/lts-13.15/8.6.4/lib/x86_64-osx-ghc-8.6.4/org-0.0.1.0-GTyh6v3N2YJ6p5b5GTVCSz"
dynlibdir  = "/Users/jcarl16/stack/.stack-work/install/x86_64-osx/lts-13.15/8.6.4/lib/x86_64-osx-ghc-8.6.4"
datadir    = "/Users/jcarl16/stack/.stack-work/install/x86_64-osx/lts-13.15/8.6.4/share/x86_64-osx-ghc-8.6.4/org-0.0.1.0"
libexecdir = "/Users/jcarl16/stack/.stack-work/install/x86_64-osx/lts-13.15/8.6.4/libexec/x86_64-osx-ghc-8.6.4/org-0.0.1.0"
sysconfdir = "/Users/jcarl16/stack/.stack-work/install/x86_64-osx/lts-13.15/8.6.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "org_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "org_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "org_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "org_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "org_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "org_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
