module PrintClusters where
import Lib

displayPixelArray :: Int -> Cluster -> IO ()
displayPixelArray x (Cluster [] pixel) = return ()
displayPixelArray (0) (Cluster (x:xs) (Pixel (r,g,b) (u,o))) = putStrLn "--" >>
        putStrLn ("(" ++ show r ++ "," ++ show g ++ "," ++ show b ++ ")\n-") >>
        displayPixelArray 1 (Cluster (x:xs) (Pixel (r,g,b) (u,o)))
displayPixelArray i (Cluster (x:xs) pixel) = print x >> 
    displayPixelArray (i + 1) (Cluster xs pixel)

displayEachCluster :: Int -> [Cluster] -> IO ()
displayEachCluster _ [] = return ()
displayEachCluster 0 (x:xs) = displayPixelArray 0 x >> 
                            displayEachCluster 1 xs
displayEachCluster i (x:xs) = displayPixelArray 0 x >> 
                            displayEachCluster (i + 1) xs
