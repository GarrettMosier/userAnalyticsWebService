{-# LANGUAGE OverloadedStrings #-}

module Main where

import DataProcessing
import Types

import Web.Scotty
import Control.Monad.IO.Class

main :: IO ()
main = do
  scotty 3000 $ do
    get "/foo" $ do
      text "Sup"
    get "/analytics" $ do -- TODO Deal with case where timestamp isn't provided
      timestamp <- param "timestamp" :: ActionM Int
      dataSummary <- liftIO (getDataDirty timestamp) 
      json dataSummary
    post "/analytics" $ do
      timestamp <- param "timestamp"
      event <- param ":event"
      user <- param ":user"

      liftIO (postData (PostRequest timestamp user event)) 
      
      text "Yo"
      -- return 204

      
  {-
  let testPostRequest = PostRequest 1 2 Click
  let testPostRequestTwo = PostRequest 1 2 Impression

  postData testPostRequest
  postData testPostRequestTwo

  getDataDirty 0 >>= print

-}

