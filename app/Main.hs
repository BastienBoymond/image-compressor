module Main where

import System.Environment
import Data.Char
import System.Exit
import System.IO
import Data.Maybe
import Text.Read
import Lib
import ErrorHandling
import ImageCompressor
import ParamsHandling
import ParsingFiles
-- import GetClustersConvergence

main :: IO ()
main = do
    args <- getArgs
    let parsedArgs = parseArgs args createDefautArgs
    errorhandling parsedArgs
    exitSuccess
