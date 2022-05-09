module Image.File.Writer
  ( writeImageFile
  ) where

import Data.List

import qualified Data.Vector.Storable as VS
import qualified Codec.Picture.Types as JP
import qualified Codec.Picture.Png as JP
import qualified Codec.Picture.Tga as JP

import Image.Pixel

writeImageFile :: [Pixel] -> String -> IO ()
writeImageFile pixels = writeImage
  where
    writeImage filename
      | checkExtension "png" filename = JP.writePng filename image
      | checkExtension "tga" filename = JP.writeTga filename image
      | otherwise = fail "ERROR: output format not supported"

    image :: JP.Image JP.PixelRGB8
    image = JP.Image w h $ VS.fromList $ map fromIntegral $ colors
    
    w :: Int
    h :: Int
    (w, h) = let (Pixel (Position w' h') _ ) = maximum pixels in (w' + 1, h' + 1)
    
    positions :: [Position]
    positions = [Position x y | y <- [0..(h - 1)], x <- [0..(w - 1)]]
    
    colors :: [Int]
    colors = concatMap colorAt positions
    
    colorAt :: Position -> [Int]
    colorAt p = let (Color r g b) = maybe (error "Color Not Found") id color in [r, g, b]
      where
        color :: Maybe Color
        color = foldl get Nothing pixels
        
        get :: Maybe Color -> Pixel -> Maybe Color
        get Nothing (Pixel p' c) = if p' == p then Just c else Nothing
        get c _ = c

checkExtension :: String -> String -> Bool
checkExtension ext filename = (reverse ('.':ext)) == (take (length ext + 1) (reverse filename))