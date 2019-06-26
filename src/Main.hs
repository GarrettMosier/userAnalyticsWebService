{-# LANGUAGE OverloadedStrings #-}

module Main where

import DataProcessing
import Types

import Web.Scotty

main :: IO ()
main = do
  scotty 3000 $ do
    get "/foo" $ do
      text "Sup"
    get "/analytics?timestamp=:timestamp" $ do
      w <- param "timestamp" :: ActionM Integer
      text "Hey"
    post "/analytics?timestamp=:timestamp&user=:uid&event=:event" $ do
      text "Yo"
      -- return 204

      
  {-
  let testPostRequest = PostRequest 1 2 Click
  let testPostRequestTwo = PostRequest 1 2 Impression

  postData testPostRequest
  postData testPostRequestTwo

  getDataDirty 0 >>= print

-}

