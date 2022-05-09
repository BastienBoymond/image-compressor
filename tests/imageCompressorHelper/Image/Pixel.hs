module Image.Pixel where

data Color = Color Int Int Int

showColor :: Color -> String
showColor (Color r g b) = "(" ++ (show r) ++ ", " ++ (show g) ++ ", " ++ (show b) ++ ")"

instance Show Color where
  show = showColor
  
instance Eq Color where
  (Color r0 g0 b0) == (Color r1 g1 b1) = and [ r0 == r1, g0 == g1, b0 == b1 ]

data Position = Position Int Int

showPosition :: Position -> String
showPosition (Position x y) = "(" ++ (show x) ++ ", " ++ (show y) ++ ")"

instance Show Position where
  show = showPosition
  
instance Eq Position where
  (Position x0 y0) == (Position x1 y1) = and [ x0 == x1, y0 == y1 ]
  
instance Ord Position where
  compare (Position x0 y0) (Position x1 y1) = if x0 == y0 then compare y0 y1 else compare x0 x1

data Pixel = Pixel Position Color

showPixel :: Pixel -> String
showPixel (Pixel p c) = (show p) ++ " " ++ (show c)

instance Show Pixel where
  show = showPixel
  
instance Eq Pixel where
  (Pixel p0 c0) == (Pixel p1 c1) = and [ p0 == p1, c0 == c1 ]
  
instance Ord Pixel where
  compare (Pixel p0 _) (Pixel p1 _) = compare p0 p1