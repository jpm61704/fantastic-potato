module Message where

import qualified Data.ByteString as B

data Message = Msg Header Body

type Body = B.ByteString

data Header = Header MessageID Sender


newtype MessageID = MsgID Integer

newtype Sender = Sender B.ByteString
