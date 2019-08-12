{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}

module Asset ( Asset(..)
             , Frameworks(..)
             , FrameworkInfo(..)
             , FrameworkID(..)
             , Resource(..)
             , Number(..)
             , Scalar(..)
             , Source(..)
             ) where

  import Data.Aeson
  import Data.Aeson.Types
  import Data.String
  import GHC.Generics

  -- | mesos nests JSON
  data Asset = Asset {
    _type            :: String
    , _getFrameworks :: Frameworks
  } deriving (Show, Generic)

  instance FromJSON Asset where
    parseJSON = genericParseJSON defaultOptions {
      fieldLabelModifier = camelTo2 '_' . drop 1
  }

  newtype Frameworks = Frameworks {
    _frameworks :: [FrameworkInfo]
  } deriving (Show, Generic)

  instance FromJSON Frameworks where
    parseJSON = genericParseJSON defaultOptions {
      fieldLabelModifier = drop 1
  }

  data FrameworkInfo = FrameworkInfo {
    _frameworkInfo :: FrameworkID
    , _allocatedResources :: Maybe [Resource]
  } deriving (Show, Generic)

  instance FromJSON FrameworkInfo where
    parseJSON = genericParseJSON defaultOptions {
      fieldLabelModifier = camelTo2 '_' . drop 1
  }

  data FrameworkID = FrameworkID {
    _user   :: String
    , _name :: String
    , _id   :: Scalar
  } deriving (Show, Generic)

  instance FromJSON FrameworkID where
    parseJSON = genericParseJSON defaultOptions {
      fieldLabelModifier = drop 1
  }

  data Resource = Resource {
    __name     :: String
    , __type   :: String
    , __scalar :: Maybe Number
  } deriving (Show, Generic)

  instance FromJSON Resource where
    parseJSON = genericParseJSON defaultOptions {
      fieldLabelModifier = drop 2
  }

  newtype Number = Number {
    __value   :: Float
  } deriving (Show, Generic)

  instance FromJSON Number where
    parseJSON = genericParseJSON defaultOptions {
      fieldLabelModifier = drop 2
  }

  newtype Scalar = Scalar {
    _value :: String
  } deriving (Show, Generic)

  instance FromJSON Scalar where
    parseJSON = genericParseJSON defaultOptions {
      fieldLabelModifier = drop 1
  }

  newtype Source = Source {
    _source :: [String]
  } deriving (Show, Generic)

  instance FromJSON Source where
    parseJSON = genericParseJSON defaultOptions {
      fieldLabelModifier = drop 1
  }
