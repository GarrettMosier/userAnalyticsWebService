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

readStorage :: IO [PostRequest]
readStorage = return []

getDataPure :: TimeStamp -> [PostRequest] -> Response
getDataPure ts requests = Response (length counts) clicks impressions 
               where counts = requests -- Make sure they're unique
                     clicks = length (filter isClick counts)
                     impressions = length (filter isImpression counts)

{-
getDataDirty :: TimeStamp -> Response
getDataDirty ts = Response (length counts) clicks impressions 
               where counts = readStorage -- Make sure they're unique
                     clicks = length (filter isClick counts)
                     impressions = length (filter isImpression counts)
-}

isClick (PostRequest _ _ Click) = True
isClick _ = False

isImpression (PostRequest _ _ Impression) = True
isImpression _ = False

main :: IO ()
main = do
  let testPostRequest = PostRequest 1 2 Click
  let testPostRequestTwo = PostRequest 1 2 Impression

  postData testPostRequest
  postData testPostRequestTwo

  print $ getDataPure 0 []
  --print $ getDataDirty []

  putStrLn "hello world"


