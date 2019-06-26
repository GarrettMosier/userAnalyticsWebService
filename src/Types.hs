{-# LANGUAGE OverloadedStrings #-}

module Types where

import Data.Aeson

data Event = Click | Impression deriving (Show, Read)

type Clicks = Int
type Impressions = Int
type UserCount = Int
data Response = Response { uniqueUserCount :: UserCount,
                           clicks :: Clicks,
                           impressions :: Impressions } deriving Show

instance ToJSON Response where
  toJSON p = object [
    "uniqueUserCount" .= uniqueUserCount p,
    "clicks"  .= clicks p,
    "impressions" .= impressions p]

type TimeStamp = Int

type UserID = Int

data PostRequest = PostRequest TimeStamp UserID Event deriving (Show, Read)
