{-# LANGUAGE OverloadedStrings #-}
module QueryJSON ( query
                 , loadSource
                 ) where

  import Data.Aeson
  import qualified Data.ByteString.Lazy.Char8 as L8
  import Network.HTTP.Client
  import Network.HTTP.Client.TLS
  import Network.HTTP.Types.Status (statusCode)

  import Asset

  loadSource :: FilePath -> IO (Either String Source)
  loadSource x = do
    d <- eitherDecode <$> L8.readFile x
    return $ case d of
      Left err -> Left err
      Right xs -> Right xs

  -- | https://github.com/snoyberg/http-client/blob/master/TUTORIAL.md
  query :: String -> IO (Either String Asset)
  query uri = do
    let requestObj = object [ "type" .= ( "GET_FRAMEWORKS" :: String ) ]

    manager <- newManager tlsManagerSettings

    initialRequest <- parseRequest uri
    let request = initialRequest {
        method           = "POST"
        , requestBody    = RequestBodyLBS $ encode requestObj
        , requestHeaders = [ ("Content-Type", "application/json") ]
        }

    response <- httpLbs request manager
    let status = statusCode $ responseStatus response
        body   = responseBody response
    -- putStrLn $ "response" ++ show status
    -- L8.putStrLn $ responseBody response

    if status > 200
    then
      return $ Left ("response: " ++ show status)
    else
      return $ case eitherDecode body of
                 Left err -> Left err
                 Right xs -> Right xs
