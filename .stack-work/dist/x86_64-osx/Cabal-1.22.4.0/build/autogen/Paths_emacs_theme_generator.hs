module Paths_emacs_theme_generator (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/owainlewis/Code/personal/emacs-theme-generator/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/bin"
libdir     = "/Users/owainlewis/Code/personal/emacs-theme-generator/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/lib/x86_64-osx-ghc-7.10.2/emacs-theme-generator-0.1.0.0-L13ERIXmNDbKFGNBBjFJoE"
datadir    = "/Users/owainlewis/Code/personal/emacs-theme-generator/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/share/x86_64-osx-ghc-7.10.2/emacs-theme-generator-0.1.0.0"
libexecdir = "/Users/owainlewis/Code/personal/emacs-theme-generator/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/libexec"
sysconfdir = "/Users/owainlewis/Code/personal/emacs-theme-generator/.stack-work/install/x86_64-osx/lts-3.12/7.10.2/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "emacs_theme_generator_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "emacs_theme_generator_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "emacs_theme_generator_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "emacs_theme_generator_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "emacs_theme_generator_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
