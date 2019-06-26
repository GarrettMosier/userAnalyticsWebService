module Main where

import Data.List

data Event = Click | Impression deriving (Show, Read)

type Clicks = Int
type Impressions = Int
type UserCount = Int
data Response = Response UserCount Clicks Impressions deriving Show

type TimeStamp = Int

type UserID = Int

data PostRequest = PostRequest TimeStamp UserID Event deriving (Show, Read)

fileLocation = "foo.txt" -- TODO Modify to write outside repo

-- Writes a POST request to storage
postData :: PostRequest -> IO ()
postData pr@(PostRequest ts uid event) = appendFile fileLocation (show pr ++ "\n")


-- Reads all previously posted data
readStorage :: IO [PostRequest]
readStorage = do
    fileLines <- fmap lines (readFile fileLocation)
    return (map toPostRequest fileLines)


-- Summarizes data assuming it's given 
getDataPure :: TimeStamp -> [PostRequest] -> Response
getDataPure ts requests = Response uniqueUsers clicks impressions 
               where uniqueUsers = length ((nub . sort ) (map getUserID currentEvents)) -- Consider more efficient solution
                     clicks = length (filter isClick currentEvents)
                     impressions = length (filter isImpression currentEvents)
                     currentEvents = requests -- TODO Make sure matches spec


-- Extracts user ID from post request.
-- Consider using lens instead
getUserID :: PostRequest -> UserID
getUserID (PostRequest _ uid _) = uid


-- Reads storage and sumarizes data
getDataDirty :: TimeStamp -> IO Response
getDataDirty ts = do
  f <- readStorage
  return (getDataPure ts f)

-- TODO Use a library to automate
toPostRequest :: String -> PostRequest
toPostRequest s = read s


isClick (PostRequest _ _ Click) = True
isClick _ = False

-- TODO Derive from typeclass
isImpression (PostRequest _ _ Impression) = True
isImpression _ = False


main :: IO ()
main = do
  let testPostRequest = PostRequest 1 2 Click
  let testPostRequestTwo = PostRequest 1 2 Impression

  postData testPostRequest
  postData testPostRequestTwo

  print $ getDataPure 0 []
  f <- getDataDirty 0
  print f


