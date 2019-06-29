{-# LANGUAGE OverloadedStrings #-}

module Types where

import           Data.Aeson
import           Web.Scotty

data Event = Click | Impression deriving (Show, Read)

-- Converts String from URL to well-typed value
instance Parsable Event where
  parseParam "click"      = Right Click -- Might be worth having this not be case sensitive
  parseParam "impression" = Right Impression
  parseParam _            = Left "Denied"


type Clicks = Int
type Impressions = Int
type UserCount = Int

data Response = Response { uniqueUserCount :: UserCount,
                           clicks          :: Clicks,
                           impressions     :: Impressions } deriving Show

instance ToJSON Response where
  toJSON p = object [
    "uniqueUserCount" .= uniqueUserCount p,
    "clicks"  .= clicks p,
    "impressions" .= impressions p]

type TimeStamp = Int

type UserID = Int

data PostRequest = PostRequest TimeStamp UserID Event deriving (Show, Read)
