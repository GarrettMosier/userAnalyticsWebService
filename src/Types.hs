module Types where

data Event = Click | Impression deriving (Show, Read)

type Clicks = Int
type Impressions = Int
type UserCount = Int
data Response = Response UserCount Clicks Impressions deriving Show

type TimeStamp = Int

type UserID = Int

data PostRequest = PostRequest TimeStamp UserID Event deriving (Show, Read)
