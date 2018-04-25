{-# LANGUAGE OverloadedStrings #-}
module Server where

import Network.Simple.TCP
import Control.Concurrent.Chan
import Control.Concurrent
import Data.ByteString as B


type Msg = B.ByteString

startServer :: IO ()
startServer = do
  chan <- newChan
  serve HostAny "1420" $ \(socket, addr) -> do
    Prelude.putStrLn $ "TCP connection established from " ++ show addr
    chan' <- dupChan chan
    forkIO $ sendBroadcast chan' socket
    listenForClient socket 10 chan'
    return ()

sendBroadcast :: Chan Msg -> Socket -> IO ()
sendBroadcast chan s = do
  b <- readChan chan
  send s b
  sendBroadcast chan s

listenForClient :: Socket -> Int -> Chan Msg -> IO ()
listenForClient s n chan = do
  x <- recv s n
  case x of
    Just b -> do
      Prelude.putStrLn $ "Message Recieved: " ++ (show b)
      writeChan chan b
    Nothing -> return ()
  listenForClient s n chan


