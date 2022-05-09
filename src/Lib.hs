{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
module Lib  where
import Text.Read
import System.IO

import System.Exit (exitSuccess)
import Data.Bits

data Cluster = Cluster {
    arrPixel :: [Pixel],
    pixel :: Pixel
}

data Args = Args {
  nbColors :: Maybe Int,
  limit :: Maybe Float,
  filePath :: Maybe String
}

data Pixel = Pixel {
  color :: (Int , Int , Int),
  pos :: (Int , Int)
} deriving (Eq)

instance Show Pixel where
  show (Pixel (r,g,b) (x,y)) = "(" ++ show x ++ "," ++ show y ++ ") (" ++ show r ++ "," ++ show g ++ "," ++ show b ++ ")"

instance Eq Cluster where
  Cluster pArr pRef == Cluster pArr2 pRef2 = pRef == pRef2

createDefautArgs :: Args
createDefautArgs = Args {
  nbColors = Nothing,
  limit = Nothing,
  filePath = Nothing
}

getColorDistance :: Pixel -> Pixel -> Float
getColorDistance (Pixel (r1, g1, b1)(x1, y1)) (Pixel (r2, g2, b2)(x2, y2))
    = sqrt $ fromIntegral ((r1 - r2)^2 + (g1 - g2)^2 + (b1 - b2)^2)

replaceComma :: String -> String
replaceComma [] = []
replaceComma (',':cs) = ' ' : replaceComma cs
replaceComma (c:cs) = c : replaceComma cs

getPixelLine :: String -> Pixel
getPixelLine line = Pixel {
  color = (read (params !! 2) :: Int, read (params !! 3) :: Int,
  read (params !! 4) :: Int),
  pos = (read (head params) :: Int, read (params !! 1) :: Int)
} where params = words (replaceComma line)

cleanString :: String -> String
cleanString (x:xs) = filter (not . (`elem` "()")) xs

parsePixel :: [String] -> [Pixel] -> [Pixel]
parsePixel xs pixels = foldMap (\x -> [getPixelLine (cleanString x)]) xs

getPixels :: [String] -> [Pixel]
getPixels [] = []
getPixels content = parsePixel content []

readFiles :: String -> IO [Pixel]
readFiles fp = do
    content <- readFile fp
    return $ getPixels $ lines content
