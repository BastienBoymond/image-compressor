module ParsingFiles where

import System.Exit
import Lib
import ImageCompressor (imageCompressor)

parseFiles:: Args -> Maybe [Pixel] -> IO ()
parseFiles (Args (Just c) (Just l) (Just f)) Nothing  = do
    pixelArray <- readFiles f
    parseFiles (Args (Just c) (Just l) (Just f)) (Just pixelArray)
parseFiles (Args (Just c) (Just l) (Just f)) (Just pixelArray) = 
    imageCompressor c l f pixelArray >> exitSuccess
parseFiles args _  = exitWith (ExitFailure 84)
