{-# LANGUAGE OverloadedStrings #-}
module Client where

import Network.Simple.TCP
import qualified Data.ByteString as B
import Data.String
import Control.Concurrent



startClient :: IO ()
startClient = connect "localhost" "1420" $ \(socket, addr) -> do
  putStrLn $ "Connection established to " ++ show addr
  send socket "Hello My friend in serverland"
  listenID <- forkIO $ listenToServer socket 10
  sendUserInput socket
  
--  myloop socket 10



myloop :: Socket -> Int -> IO ()
myloop s n = do
  -- listenToServer s n
  sendUserInput s
  myloop s n

listenToServer :: Socket -> Int -> IO ()
listenToServer s n = do
  x <- recv s n
  case x of
    Just b -> putStrLn $ "We got a message: " ++ (show b)
    Nothing -> return ()
  listenToServer s n

sendUserInput :: Socket -> IO ()
sendUserInput s = do
  b <- getLine
  sendLazy s (fromString b)
  sendUserInput s
