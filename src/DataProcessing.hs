module DataProcessing where

import           Control.Exception
import           Data.List
import           Types

fileLocation = "storageUnit.txt" -- TODO Modify to write outside repo

-- Writes a POST request to storage
-- TODO Maybe prepend data since reading recent more often
writeAnalyticsEntry :: PostRequest -> IO ()
writeAnalyticsEntry pr = appendFile fileLocation (show pr ++ "\n")


-- Reads all previously posted data
getPriorAnalyticsEntriesFromStorage :: IO [PostRequest]
getPriorAnalyticsEntriesFromStorage = do
    fileLines <- try (fmap lines (readFile fileLocation)) :: IO (Either IOException [String])
    case fileLines of
      Left except    -> return []
      Right contents -> return (map toPostRequest contents)


-- Reads storage and sumarizes data
summarizeEntriesFromStorage :: TimeStamp -> IO Response
summarizeEntriesFromStorage ts = fmap (summarizeAnalyticsEntries ts) getPriorAnalyticsEntriesFromStorage


-- Summarizes analytics data from within an hour
summarizeAnalyticsEntries :: TimeStamp -> [PostRequest] -> Response
summarizeAnalyticsEntries ts requests = Response uniqueUserCount clicks impressions
               where uniqueUserCount = length ((nub . sort ) (map getUserID currentEvents)) -- Consider more efficient solution
                     clicks = length (filter isClick currentEvents)
                     impressions = length (filter isImpression currentEvents)
                     currentEvents = filter (withinHour ts) requests


-- Checks to see if a request was from the last hour.
-- This does not check to see if the request was made since the top of the hour.
-- TODO Check if that is what the spec wanted
withinHour :: TimeStamp -> (PostRequest -> Bool)
withinHour ts = \(PostRequest x _ _) -> ts - x <= millisecondsPerHour
           where millisecondsPerHour = 3600000


-- Extracts user ID from post request.
-- Consider using lens instead
getUserID :: PostRequest -> UserID
getUserID (PostRequest _ uid _) = uid


-- TODO Use a library to automate
toPostRequest :: String -> PostRequest
toPostRequest s = read s


isClick (PostRequest _ _ Click) = True
isClick _                       = False

-- TODO Derive from typeclass
isImpression (PostRequest _ _ Impression) = True
isImpression _                            = False
