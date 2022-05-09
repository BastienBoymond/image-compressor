module Image.File.Reader
  ( readImageFile
  ) where
    
import Control.Applicative

import qualified Data.Vector.Storable as VS

import System.Directory (doesFileExist)

import qualified Data.ByteString as BS

import qualified Codec.Picture.Jpg as JP (decodeJpeg)
import qualified Codec.Picture.Png as JP (decodePng)
import qualified Codec.Picture.Types as JP

import Image.Pixel

readImageFile :: String -> IO [Pixel]
readImageFile ifn = do
  e <- doesFileExist ifn
  case e of
    False -> fail $ "ERROR: " ++ ifn ++ " doesn't exists"
    True -> do
      e <- return . (\a -> JP.decodePng a <|> JP.decodeJpeg a) =<< BS.readFile ifn
      case e of
        Left msg -> fail $ "ERROR: " ++ msg
        Right img -> return $ imagePixels img

imagePixels :: JP.DynamicImage -> [Pixel]
imagePixels (JP.ImageY8     i) = pixels $ JP.pixelMap (JP.promotePixel :: JP.Pixel8  -> JP.PixelRGB8 ) i
imagePixels (JP.ImageY16    i) = pixels $ JP.pixelMap (JP.promotePixel :: JP.Pixel16 -> JP.PixelRGB16) i
imagePixels (JP.ImageYF     i) = pixels $ JP.pixelMap (JP.promotePixel :: JP.PixelF  -> JP.PixelRGBF ) i
imagePixels (JP.ImageYA8    i) = pixels $ JP.pixelMap JP.dropTransparency $ (JP.promoteImage i :: JP.Image JP.PixelRGBA8 )
imagePixels (JP.ImageYA16   i) = pixels $ JP.pixelMap JP.dropTransparency $ (JP.promoteImage i :: JP.Image JP.PixelRGBA16)
imagePixels (JP.ImageRGB8   i) = pixels i
imagePixels (JP.ImageRGB16  i) = pixels i
imagePixels (JP.ImageRGBF   i) = pixels i
imagePixels (JP.ImageRGBA8  i) = pixels $ JP.pixelMap JP.dropTransparency i
imagePixels (JP.ImageRGBA16 i) = pixels $ JP.pixelMap JP.dropTransparency i
imagePixels (JP.ImageYCbCr8 i) = pixels $ (JP.convertImage i :: JP.Image JP.PixelRGB8 )
imagePixels (JP.ImageCMYK8  i) = pixels $ (JP.convertImage i :: JP.Image JP.PixelRGB8 )
imagePixels (JP.ImageCMYK16 i) = pixels $ (JP.convertImage i :: JP.Image JP.PixelRGB16)

pixels :: ImageGetColors a => JP.Image a -> [Pixel]
pixels i@(JP.Image w h _) = map get coords
  where
    coords :: [Position]
    coords = [Position x y | x <- [0..(w - 1)], y <- [0..(h - 1)]]
    
    get :: Position -> Pixel
    get p = let c = getColor i p in Pixel p c

class ImageGetColors a where
  getColor :: JP.Image a -> Position -> Color

instance ImageGetColors JP.PixelRGB8 where
  getColor (JP.Image w _ d) (Position x y) =
    let r:g:b:[] = VS.toList
                 $ VS.map fromIntegral
                 $ VS.take 3
                 $ VS.drop (3 * (x + y * w)) d
    in Color r g b

instance ImageGetColors JP.PixelRGB16 where
  getColor (JP.Image w _ d) (Position x y) =
    let r:g:b:[] = VS.toList
                 $ VS.map (`quot` 256)
                 $ VS.map fromIntegral
                 $ VS.take 3
                 $ VS.drop (3 * (x + y * w)) d
    in Color r g b

instance ImageGetColors JP.PixelRGBF where
  getColor (JP.Image w _ d) (Position x y) =
    let r:g:b:[] = VS.toList
                 $ VS.map round
                 $ VS.map (* 256)
                 $ VS.take 3
                 $ VS.drop (3 * (x + y * w)) d
    in Color r g b
    




