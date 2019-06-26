module DataProcessing where

import Types
import Data.List

fileLocation = "foo.txt" -- TODO Modify to write outside repo

-- Writes a POST request to storage
-- TODO Maybe prepend data since reading recent more often
postData :: PostRequest -> IO ()
postData pr@(PostRequest ts uid event) = appendFile fileLocation (show pr ++ "\n")


-- Reads all previously posted data
readStorage :: IO [PostRequest]
readStorage = do
    fileLines <- fmap lines (readFile fileLocation)
    return (map toPostRequest fileLines)


-- Summarizes data assuming it's given 
getDataPure :: TimeStamp -> [PostRequest] -> Response
getDataPure ts requests = Response uniqueUserCount clicks impressions 
               where uniqueUserCount = length ((nub . sort ) (map getUserID currentEvents)) -- Consider more efficient solution
                     clicks = length (filter isClick currentEvents)
                     impressions = length (filter isImpression currentEvents)
                     currentEvents = filter (withinHour ts) requests 


-- TODO Make sure matches spec. Ideally data store would do this filter
withinHour :: TimeStamp -> (PostRequest -> Bool)
withinHour ts = \x -> True


-- Extracts user ID from post request.
-- Consider using lens instead
getUserID :: PostRequest -> UserID
getUserID (PostRequest _ uid _) = uid


-- Reads storage and sumarizes data
getDataDirty :: TimeStamp -> IO Response
getDataDirty ts = fmap (getDataPure ts) readStorage


-- TODO Use a library to automate
toPostRequest :: String -> PostRequest
toPostRequest s = read s


isClick (PostRequest _ _ Click) = True
isClick _ = False

-- TODO Derive from typeclass
isImpression (PostRequest _ _ Impression) = True
isImpression _ = False
