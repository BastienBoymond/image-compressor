module Image.File.Parser
  ( parseFile
  ) where
    
import System.Directory (doesFileExist)
    
import Image.File.Reader
import Image.Pixel

import Text.Parsec.String

import Text.ParserCombinators.Parsec.Char (char, digit, string, spaces)
import Text.ParserCombinators.Parsec.Combinator (many1, between)
import Text.ParserCombinators.Parsec.Prim (many)

parseFile :: String -> IO [(Color, [Pixel])]
parseFile f = do
  e <- doesFileExist f
  case e of
    False -> fail $ "ERROR: " ++ f ++ " doesn't exists"
    True -> do
      e <- parseFromFile pOUT f
      case e of
        Left msg -> fail $ "ERROR: " ++ (show msg)
        Right img -> return img

pOUT :: Parser [(Color, [Pixel])]
pOUT = many pCLUSTER

pCLUSTER :: Parser (Color, [Pixel])
pCLUSTER = do
  _ <- string "--\n"
  c <- pCOLOR
  _ <- string "\n-\n"
  ps <- pPIXELS
  return (c, ps)
  where
    pPIXELS :: Parser [Pixel]
    pPIXELS = many1 $ do
      p <- pPOINT
      _ <- spaces
      c <- pCOLOR
      char '\n'
      return $ Pixel p c

pPOINT :: Parser Position
pPOINT = do
  char '('
  x <- pINT
  char ','
  y <- pINT
  char ')'
  return $ Position x y

pINT :: Parser Int
pINT = do
  s <- many1 $ between spaces spaces digit
  return $ read s

pCOLOR :: Parser Color
pCOLOR = do
  char '('
  r <- pSHORT
  char ','
  g <- pSHORT
  char ','
  b <- pSHORT
  char ')'
  return $ Color r g b

pSHORT :: Parser Int
pSHORT = do
  s <- many1 $ between spaces spaces digit
  return $ read s