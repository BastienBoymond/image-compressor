module Image.Transformer
  ( transformPixels
  )where
    
import Image.Pixel

transformPixels :: [Pixel] -> [(Color, [Pixel])] -> [Pixel]
transformPixels ps = foldl tr ps
  where
    tr :: [Pixel] -> (Color, [Pixel]) -> [Pixel]
    tr ps1 (c, ps2) = foldl tr' ps1 ps2
      where
        tr' :: [Pixel] -> Pixel -> [Pixel]
        tr' ps p@(Pixel pos col)
          | p `elem` ps = map (\p' -> if p == p' then (Pixel pos c) else p') ps
          | otherwise = error $ "ERROR: Pixel Not Found: " ++ (show p)