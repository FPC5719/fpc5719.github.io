{-# LANGUAGE OverloadedStrings #-}

import Hakyll

main :: IO ()
main = hakyll $ do
  match "index.html" $ do
    route idRoute
    compile $ do
      getResourceBody
        >>= relativizeUrls
