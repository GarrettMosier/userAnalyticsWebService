module Main where

data Event = Click | Impression deriving Show

type Clicks = Int
type Impressions = Int
type UserCount = Int
data Response = Response UserCount Clicks Impressions deriving Show

type TimeStamp = Int

type UserID = Int

data PostRequest = PostRequest TimeStamp UserID Event deriving Show

fileLocation = "foo.txt"

postData :: PostRequest -> IO ()
postData pr@(PostRequest ts uid event) = appendFile fileLocation ((show pr) ++ "\n")

main :: IO ()
main = do
  let testPostRequest = PostRequest 1 2 Click
  let testPostRequestTwo = PostRequest 1 2 Impression

  postData testPostRequest
  postData testPostRequestTwo

  putStrLn "hello world"


