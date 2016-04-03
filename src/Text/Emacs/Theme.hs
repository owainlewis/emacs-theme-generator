{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
-- |
-- Module:      Text.Emacs.Theme
-- Copyright:   Owain Lewis 2016
-- License:     BSD3
--
-- Maintainer:  Owain Lewis <owain@owainlewis.com>
-- Stability:   experimental
-- Portability: unknown
--
module Text.Emacs.Theme
       ( render
       , writeTheme
       , compileTheme
       , Palette(..)
       , Theme(..)
       ) where

import           Control.Applicative  ((<$>))
import           Control.Monad        (liftM, mzero)
import           Data.Aeson
import qualified Data.ByteString.Lazy as BS
import qualified Data.Map             as M
import           Data.Maybe           (fromMaybe)
import           Data.Monoid          ((<>))
import           GHC.Generics
import           Text.Regex           (Regex, matchRegexAll, mkRegex, subRegex)

data Palette = Palette {
    fg1      :: String
  , fg2      :: String
  , fg3      :: String
  , fg4      :: String
  , bg1      :: String
  , bg2      :: String
  , bg3      :: String
  , bg4      :: String
  , builtin  :: String
  , keyword  :: String
  , constant :: String
  , comment  :: String
  , function :: String
  , string   :: String
  , types    :: String
  , variable :: String
  , warning  :: String
} deriving ( Generic, Show )

instance FromJSON Palette

data Theme = Theme {
    name    :: String
  , palette :: Palette
} deriving ( Show )

instance FromJSON Theme where
    parseJSON (Object o) =
        Theme <$> (o .: "name")
              <*> (o .: "palette")
    parseJSON _ = mzero

class ToMap a where
    toStringMap :: a -> M.Map String String

instance ToMap Palette where
    toStringMap (Palette fg1 fg2 fg3 fg4 bg1 bg2 bg3 bg4 builtin keyword constant comment func str types var warning) =
        M.fromList [ ("fg1", fg1)
                   , ("fg2", fg2)
                   , ("fg3", fg3)
                   , ("fg4", fg4)
                   , ("bg1", bg1)
                   , ("bg2", bg2)
                   , ("bg3", bg3)
                   , ("bg4", bg4)
                   , ("builtin", builtin)
                   , ("keyword", keyword)
                   , ("constant", constant)
                   , ("comment", comment)
                   , ("function", func)
                   , ("string", str)
                   , ("types", types)
                   , ("variable", var)
                   , ("warning", warning)
                   ]

instance ToMap Theme where
    toStringMap (Theme name palette) =
        M.union m1 m2
          where m1 = M.fromList [ ("name", name) ]
                m2 = toStringMap palette

openPattern :: String
openPattern = "{{"

closePattern :: String
closePattern = "}}"

-- Fairly crude template generation function
--
compileTemplate :: String -> M.Map String String -> String
compileTemplate template subs =
    M.foldrWithKey doReplace template subs
      where doReplace expr replacement str =
              let e = mkRegex $ openPattern <> expr <> closePattern in
              subRegex e str replacement

render :: ToMap a => a -> IO String
render theme = do
    template <- readFile "resources/templates/theme.txt"
    let compiled = compileTemplate template (toStringMap theme)
    return compiled

loadTheme :: FilePath -> IO (Maybe Theme)
loadTheme themePath = do
     content <- BS.readFile themePath
     let result = decode content :: Maybe Theme
     pure result

compileTheme :: FilePath -> IO String
compileTheme themeName = do
    theme <- loadTheme $ "resources/themes/" <> themeName
    fromMaybe (pure mzero) (render <$> theme)

writeTheme :: FilePath -> IO ()
writeTheme themeName = do
    compiled <- compileTheme $ themeName <> ".json"
    writeFile (mconcat ["resources/generated/", themeName, ".el"]) compiled
