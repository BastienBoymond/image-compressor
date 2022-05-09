module ParamsHandling where
import Lib
import Text.Read (readMaybe)

parseArgs :: [String] -> Args -> Maybe Args
parseArgs [] args = Just args
parseArgs [_] _ = Nothing
parseArgs ("-l":l:ls) args = 
    parseArgs ls (args {limit = readMaybe l :: Maybe Float})
parseArgs ("-n":n:ns) args = 
    parseArgs ns (args {nbColors = readMaybe n ::  Maybe Int})
parseArgs ("-f":f:fs) args = parseArgs fs (args {filePath = Just f})
parseArgs _ _ = Nothing
