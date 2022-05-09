module ImageCompressor where
import Lib
import PrintClusters
import System.Exit
import System.Random
import Text.Printf
import Data.List (elemIndex)

instance Show Cluster where
  show (Cluster arrPixel pixel) = printf "Cluster: %s, %s" (show arrPixel) (show pixel)

createRef :: Cluster -> Int -> Pixel
createRef (Cluster [] (Pixel (r,g,b) (x,y))) 0 =
  Pixel (0, 0, 0) (x,y)
createRef (Cluster (x:xs) ref) 0 = createRef (Cluster xs x) 1
createRef (Cluster (Pixel (r1,g1,b1) (x1,y1):xs) (Pixel (r2,g2,b2) (x2,y2))) i
  = createRef (Cluster xs (Pixel (r1+r2,g1+g2,b1+b2) (x1+x2,y1+y2))) (i+1)
createRef (Cluster [] (Pixel (r,g,b) (x,y))) i =
  Pixel (r `div` i,g `div` i, b `div` i) (0,0)

reEvaluateCentroids :: [Cluster] -> [Cluster] -> [Cluster]
reEvaluateCentroids ((Cluster [] pixelRef):clusters) (c:cs) =
  Cluster [] pixelRef : reEvaluateCentroids clusters cs
reEvaluateCentroids (x:clusters) (c:cs) =
  Cluster [] (createRef x 0) : reEvaluateCentroids clusters cs
reEvaluateCentroids clusterArray [] = clusterArray
reEvaluateCentroids _ _ = []

addPixel :: Cluster -> Pixel -> Cluster
addPixel (Cluster pArr pRef) p = Cluster (p:pArr) pRef

attributePixelToCluster :: Float -> Maybe Int -> [Cluster] -> [Cluster] -> Pixel -> [Cluster]
attributePixelToCluster dist i save ((Cluster pArr pref):xs) p
  | dist <= cdist = attributePixelToCluster dist i save xs p
  | otherwise =
  attributePixelToCluster cdist (elemIndex (Cluster pArr pref) save) save xs p
  where cdist = getColorDistance pref p
attributePixelToCluster dist (Just i) x [] pixel =
  take i x <> (addPixel (x !! i) pixel : drop (i + 1) x)
attributePixelToCluster _ _ _ _ _ = []

algorithm :: Int -> [Pixel] -> [Pixel] -> [Cluster] -> [Cluster] -> IO ()
algorithm cond pArray (pixel:rest) ((Cluster pixelArr pRef):xs) tmpCluster =
   algorithm cond pArray rest (attributePixelToCluster
   (getColorDistance pRef pixel) (Just 0) (Cluster pixelArr pRef:xs)
   (Cluster pixelArr pRef:xs) pixel) tmpCluster
algorithm cond pArray [] cl tmpCluster
  | cl == tmpCluster = displayEachCluster 0 cl
  | otherwise =
  algorithm (cond + 1) pArray pArray (reEvaluateCentroids cl cl) cl
algorithm _ _ _ _ _ = return ()

deletePixelArray :: [Pixel] -> Pixel -> [Pixel]
deletePixelArray ((Pixel (r1,g1,b1) (x1,y1)):ks) (Pixel (r2,g2,b2) (x2,y2))
  | x1 == x2 && y1 == y2 = ks
  | otherwise =
  Pixel (r1,g1,b1) (x1,y1):deletePixelArray ks (Pixel (r2,g2,b2) (x2,y2))
deletePixelArray _ _ = []

deleteSameColor :: [Pixel] -> Pixel -> [Pixel]
deleteSameColor ((Pixel (r1,g1,b1) (x1,y1)):ks) (Pixel (r2,g2,b2) (x2,y2))
  | r1 == r2 && g1 == g2 && b1 == b2 =
     deleteSameColor ks (Pixel (r2,g2,b2) (x2,y2))
  | otherwise =
  Pixel (r1,g1,b1) (x1,y1):deleteSameColor ks (Pixel (r2,g2,b2) (x2,y2))
deleteSameColor [] _ = []

createClusterArray :: Int -> Float -> [Pixel] -> [Pixel] -> [Pixel] -> [Cluster] -> IO ()
createClusterArray cCount a pArr kArr [] cArr | cCount > 0
    = putStrLn "Too many clusters for n pixels" >> exitWith( ExitFailure 84)
    | otherwise = algorithm 0 pArr [] cArr cArr
createClusterArray 0 c pArr rArr kArr cArr = algorithm 0 pArr rArr cArr []
createClusterArray n c pArr rArr kArr cArr = do
    let len = length kArr
    i <- randomRIO (0, len - 1)
    let cluser = Cluster [kArr !! i] (kArr !! i)
    let withoutref = deletePixelArray rArr (kArr !! i)
    let delSColor = deleteSameColor kArr (kArr !! i)
    createClusterArray (n - 1) c pArr withoutref delSColor (cluser:cArr)

imageCompressor :: Int -> Float ->  String -> [Pixel] ->  IO ()
imageCompressor n c str array = createClusterArray n c array array array []
