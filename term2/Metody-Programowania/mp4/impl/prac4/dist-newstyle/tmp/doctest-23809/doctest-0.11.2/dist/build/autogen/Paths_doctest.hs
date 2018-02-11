{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_doctest (
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
version = Version [0,11,2] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/sgorawski/.cabal/store/ghc-8.0.2/doctest-0.11.2-45cd6d8a3dfc985269596d457c87dd1b53966d7e904e62a012b28ee1edc7a4bb/bin"
libdir     = "/Users/sgorawski/.cabal/store/ghc-8.0.2/doctest-0.11.2-45cd6d8a3dfc985269596d457c87dd1b53966d7e904e62a012b28ee1edc7a4bb/lib"
dynlibdir  = "/Users/sgorawski/.cabal/store/ghc-8.0.2/doctest-0.11.2-45cd6d8a3dfc985269596d457c87dd1b53966d7e904e62a012b28ee1edc7a4bb/lib"
datadir    = "/Users/sgorawski/.cabal/store/ghc-8.0.2/doctest-0.11.2-45cd6d8a3dfc985269596d457c87dd1b53966d7e904e62a012b28ee1edc7a4bb/share"
libexecdir = "/Users/sgorawski/.cabal/store/ghc-8.0.2/doctest-0.11.2-45cd6d8a3dfc985269596d457c87dd1b53966d7e904e62a012b28ee1edc7a4bb/libexec"
sysconfdir = "/Users/sgorawski/.cabal/store/ghc-8.0.2/doctest-0.11.2-45cd6d8a3dfc985269596d457c87dd1b53966d7e904e62a012b28ee1edc7a4bb/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "doctest_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "doctest_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "doctest_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "doctest_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "doctest_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "doctest_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
