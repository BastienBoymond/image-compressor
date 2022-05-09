module Main where

import System.Environment (getArgs)

import Image.File.Parser
import Image.File.Reader
import Image.File.Writer
import Image.Transformer

import Image.Pixel

main :: IO ()
main = do
  args <- getArgs
  case args of
    i:[] -> readImageFile i >>= mapM_ (putStrLn . show)
    i:t:[] -> do
      putStrLn "########################################"
      putStrLn "BEFORE"
      putStrLn "########################################"
      pixels <- readImageFile i
      mapM_ (putStrLn . show) pixels
      
      putStrLn "########################################"
      putStrLn "TRANSFORMATION"
      putStrLn "########################################"
      transformation <- parseFile t
      flip mapM_ transformation $ \(c, ps) -> do
        putStrLn $ show c
        flip mapM_ ps $ \p -> do
          putStr "\t"
          putStrLn $ show p
      
      putStrLn "########################################"
      putStrLn "AFTER"
      putStrLn "########################################"
      mapM_ (putStrLn . show) (transformPixels pixels transformation)
    i:t:o:[] -> do
      pixels <- readImageFile i
      transformation <- parseFile t
      writeImageFile (transformPixels pixels transformation) o
    _ -> fail "ERROR: bad arguments"
