module Main where

import DataProcessing
import Types


main :: IO ()
main = do
  let testPostRequest = PostRequest 1 2 Click
  let testPostRequestTwo = PostRequest 1 2 Impression

  postData testPostRequest
  postData testPostRequestTwo

  -- print $ getDataPure 0 []
  f <- getDataDirty 0
  print f


