module Main where

data Event = Click | Impression deriving Show

type Clicks = Int
type Impressions = Int
type UserCount = Int
data Response = Response UserCount Clicks Impressions deriving Show

main :: IO ()
main = do
  putStrLn "hello world"
