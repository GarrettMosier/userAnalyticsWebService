{-# LANGUAGE OverloadedStrings #-}

module Main where

import DataProcessing
import Types

import Web.Scotty
import Network.HTTP.Types
import Control.Monad.IO.Class

main :: IO ()
main = do
  scotty 3000 $ do
    get "/analytics" $ do -- TODO Deal with case where timestamp isn't provided.
      -- TODO Currently fails if foo doesn't exist (which it doesn't on startup)
      timestamp <- param "timestamp" :: ActionM Int
      dataSummary <- liftIO (getDataDirty timestamp) 
      json dataSummary
    post "/analytics" $ do
      timestamp <- param "timestamp"
      event <- param "event"
      user <- param "user"

      liftIO (postData (PostRequest timestamp user event)) 

      status status204
