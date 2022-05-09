{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
module ErrorHandling where

import Lib
import ImageCompressor
import System.Exit
import ParsingFiles (parseFiles)

errorhandling :: Maybe Args ->  IO ()
errorhandling Nothing = putStrLn "No arguments" >> exitWith (ExitFailure 84)
errorhandling (Just (Args Nothing _ _ ))
    = putStrLn "No input file" >> exitWith (ExitFailure 84)
errorhandling (Just (Args _ Nothing _ ))
    = putStrLn "No output file" >> exitWith (ExitFailure 84)
errorhandling (Just (Args _ _ Nothing )) 
    = putStrLn "No algorithm" >> exitWith (ExitFailure 84)
errorhandling (Just args) = parseFiles args Nothing >>  exitSuccess
errorhandling _ = putStrLn "Error: Unknown error" >> exitWith (ExitFailure 84)
