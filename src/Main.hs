{-# LANGUAGE OverloadedStrings #-}

module Main where

import           DataProcessing
import           Types

import           Control.Monad.IO.Class
import           Network.HTTP.Types
import           Web.Scotty


-- Takes the endpoints and creates the web app
main :: IO ()
main = do
  scotty 3000 $ do
    getSummary
    postEntry


-- Summarizes all data from the last hour
getSummary :: ScottyM ()
getSummary = do
    get "/analytics" $ do -- TODO Deal with case where timestamp isn't provided.
      timestamp <- param "timestamp" :: ActionM Int
      dataSummary <- liftIO (summarizeEntriesFromStorage timestamp)
      json dataSummary


-- Posts a new analytic entry to the storage unit
postEntry :: ScottyM ()
postEntry = do
  post "/analytics" $ do
      timestamp <- param "timestamp"
      event <- param "event"
      user <- param "user" -- TODO Return 400 instead of 500 when param not found. Might want to use rescue or modify default handler

      liftIO (writeAnalyticsEntry (PostRequest timestamp user event))

      status status204
