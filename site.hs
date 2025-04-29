{-# LANGUAGE OverloadedStrings #-}

import Hakyll

main :: IO ()
main = hakyll $ do
  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match "template/*" $ do
    compile templateBodyCompiler

  match "posts/*" $ do
    route $ setExtension "html"
    compile $ do
      postTemplate <- loadBody "template/post.html"
      pandocCompiler
        >>= applyTemplate postTemplate postContext
        >>= relativizeUrls

  create ["index.html"] $ do
    route idRoute
    compile $ do
      postListContext' <- postListContext
      indexTemplate    <- loadBody "template/index.html"
      makeItem ""
        >>= applyTemplate indexTemplate postListContext'
        >>= relativizeUrls

postContext :: Context String
postContext = mconcat
  [ dateField "date" "%Y-%m-%d"
  , defaultContext
  ]

postListContext :: Compiler (Context String)
postListContext = do
  posts <- loadAll "posts/*" >>= recentFirst
  pure $ mconcat
    [ listField "posts" postContext (return posts)
    , defaultContext
    ]
