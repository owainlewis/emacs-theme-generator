module Main where

import System.Directory(getDirectoryContents)
import           Text.Emacs.Theme as Emacs
import Data.List(isSuffixOf)
import Control.Monad(forM_)
import Control.Applicative ((<$>))

--main :: IO ()
main = do
    putStrLn "Generating all themes..."
    allThemes <- filter (isSuffixOf ".json") <$> getDirectoryContents "resources/themes"
    forM_ allThemes $ \theme ->
        writeTheme ((reverse . (drop 5) . reverse) theme)
