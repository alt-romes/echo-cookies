{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.Text (Text, pack)
import System.Environment (getArgs)

import Servant
import Network.Wai.Handler.Warp


type API = "echo-cookies" :> Capture "cookie" Text -- <=> /echo-cookies/:cookie
         :> Get '[JSON] (Headers '[Header "Set-Cookie" Text] ())

server :: Text -> Server API
server cookie_to_set cookie = return (addHeader (cookie_to_set <> "=" <> cookie) ())

main :: IO ()
main = do
    [port, cookie_to_set] <- getArgs
    putStrLn "Started"
    run (read port) (serve (Proxy @API) (server (pack cookie_to_set)))

